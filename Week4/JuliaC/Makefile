CC = gcc
CFLAGS = -fopenmp -O2 -g -Wall -Wextra
LDLIBS = -lm

all: julia.exe

%.exe: %.o
	$(CC) $(CFLAGS) -o $@ $< $(LDLIBS)

clean:
	$(RM) $(wildcard *.o) $(wildcard *.exe)
	$(RM) core $(wildcard core.*)
