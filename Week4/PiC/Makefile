CC = mpicc
CFLAGS = -O2 -g -Wall -Wextra

all: pi.exe

pi.exe: pi.o
	$(CC) $(CFLAGS) -o $@ $<

clean:
	$(RM) $(wildcard *.o) $(wildcard *.exe)
	$(RM) core $(wildcard core.*)
