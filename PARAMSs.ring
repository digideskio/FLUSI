32     = nx         (number of points in x-direction, nx>=16)
32     = ny         (number of points in y-direction, ny>=16)
32     = nz         (number of points in z-direction, nz>=16)
20  = nt         (number of time steps in simulation)
10.01    = tmax      (maximum physical time)
0.01     = cfl        ( ) 
2.5     = tsave      (interval for saving fields)
0       = ifield (1) (pressure:  0 = don't save, 1 = save)
0       = ifield (2) (velocity:  0 = don't save, 1 = save)
0       = ifield (3) (vorticity: 0 = don't save, 1 = save)
10.0    = xl         (size of computational domain in x-direction)
10.0    = yl         (size of computational domain in y-direction)
10.0    = zl         (size of computational domain in z-direction)
1.0e-3  = nu         (kinematic viscosity)
0       = idealias   (0 = no de-aliasing, 1 = elliptical de-aliasing)
0       = ihypervisc (0 = Newtonian viscosity, 1 = hyperviscosity)
1       = iobst      (0 = no obstacle, 1 = obstacle, 2 = symmetric obstacle)
1       = inicond    (1 = 3 vortices, 2 = mean flow, 3 = read from file)
0.01    = tdrag      (interval for calculating drag)
111       = imask      (1=cube, 2=sph, 3=chan, 4=cyl, 6=from file)
0       = ismth      (0 = no smoothing, 1 = smoothing)
0       = imove      (0 = no moving, 1 = moving, 2 = moving ver.2007)

1.0     = size       (length of obstacle)
1.0     = Ux         (speed of mean flow in x)
0.0     = Uy         (speed of mean flow in y)
0.0     = Uz         (speed of mean flow in z)
0.0     = Ax          (acceleration of the mean flow in x)
0.0     = Ay          (acceleration of the mean flow in y)
0.0     = Az          (acceleration of the mean flow in z)
4000    = istart     (starting time step, if reading from a file)
vor_004000 = infile  (file to read from, if reading from a file)
