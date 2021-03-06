!-------------------------------------------------------------------------------
! ./flusi --postprocess --compare-timeseries forces.t ref/forces.t
!-------------------------------------------------------------------------------
subroutine compare_timeseries(help)
  use vars
  use mpi
  implicit none
  character(len=strlen) :: file1,file2
  character(len=1024) :: header, line
  character(len=15) ::format
  real(kind=pr),dimension(:),allocatable :: values1, values2, error
  real(kind=pr)::diff
  integer :: i,columns,io_error,columns2, mpicode
  logical, intent(in) :: help

  if (help.and.root) then
    write(*,*) "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    write(*,*) "./flusi -p "
    write(*,*) "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    write(*,*) ""
    write(*,*) "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    write(*,*) "Parallel: yes"
    return
  endif


  call get_command_argument(3,file1)
  call get_command_argument(4,file2)

  call check_file_exists(file1)
  call check_file_exists(file2)

  !-----------------------------------------------------------------------------
  ! how many colums are in the *.t file?
  !-----------------------------------------------------------------------------
  open  (14, file = file1, status = 'unknown', action='read')
  read (14,'(A)') header
  read (14,'(A)') line
  columns=1
  do i=2,len_trim(line)
    if ((line(i:i)==" ").and.(line(i+1:i+1)/=" ")) columns=columns+1
  enddo
  close (14)

  !-----------------------------------------------------------------------------
  ! how many colums are in the second *.t file?
  !-----------------------------------------------------------------------------
  open  (14, file = file1, status = 'unknown', action='read')
  read (14,'(A)') header
  read (14,'(A)') line
  columns2=1
  do i=2,len_trim(line)
    if ((line(i:i)==" ").and.(line(i+1:i+1)/=" ")) columns2=columns2+1
  enddo
  close (14)

  if(columns/=columns2) then
    write(*,*) "trying to compare two t files with different #columns..."
    call MPI_FINALIZE(mpicode)
    call exit(666)
  endif

  write(format,'("(",i2.2,"(es15.8,1x))")') columns
  !   write(*,*) format
  !-----------------------------------------------------------------------------
  ! alloc arrays, then scan line by line for errors
  !-----------------------------------------------------------------------------
  allocate( values1(1:columns), values2(1:columns), error(1:columns) )

  ! read in files, line by line
  io_error=0
  open (20, file = file1, status = 'unknown', action='read')
  open (30, file = file2, status = 'unknown', action='read')
  read (20,'(A)') header
  read (30,'(A)') header
  do while (io_error==0)
    ! compare this line
    read (20,*,iostat=io_error) values1
    read (30,*,iostat=io_error) values2

    do i=1,columns
      diff = values1(i)-values2(i)
      ! ignore values smaller 1e-4 in ref file
      if ((dabs(values2(i))>1.d-4).and.(diff>1.d-7)) then
        error(i) = dabs(diff/values2(i))
      else
        error(i) = 0.0
      endif
    enddo

    if (maxval(error)>1.d-4) then
      write(*,*) "time series comparison failed..."
      write(*,format) values1
      write(*,format) values2
      write(*,format) error
      call MPI_FINALIZE(mpicode)
      call exit(666)
    endif
  enddo
  close (20)
  close (30)
  deallocate (values1,values2,error)
end subroutine compare_timeseries
