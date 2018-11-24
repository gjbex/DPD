FC = mpif90
FFLAGS = -O2 -g -Wall -Wextra

all: pi.exe

pi.exe: pi.o
	$(FC) $(FFLAGS) -o $@ $<

%.o: %.f90
	$(FC) $(FFLAGS) -c -o $@ $<

clean:
	$(RM) $(wildcard *.o) $(wildcard *.mod) $(wildcard *.exe)
	$(RM) core $(wildcard core.*)
