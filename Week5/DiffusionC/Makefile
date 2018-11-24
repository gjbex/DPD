CC = gcc
MPICC = mpicc
CFLAGS = -g -O2 -Wall -Wextra

all: diffusion.exe diffusion_serial.exe

diffusion.exe: diffusion.o
	$(MPICC) $(CFLAGS) -o $@ $<

diffusion_serial.exe: diffusion_serial.o
	$(CC) $(CFLAGS) -o $@ $<

clean:
	$(RM) $(wildcard *.o) $(wildcard *.exe)
	$(RM) core $(wildcard core.*)
