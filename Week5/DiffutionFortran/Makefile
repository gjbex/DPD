FC = gfortran
MPIFC = mpif90
FFLAGS = -g -O2 -Wall -Wextra

all: diffusion_serial.exe diffusion.exe

diffusion_serial.exe: diffusion_serial.f90
	$(FC) $(FFLAGS) -o $@ $<

diffusion.exe: diffusion.f90
	$(MPIFC) $(FFLAGS) -o $@ $<

clean:
	$(RM) $(wildcard *.o) $(wildcard *.mod) $(wildcard *.exe)
	$(RM) core $(wildcard core.*)
