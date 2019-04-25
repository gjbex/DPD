CC = gcc
CFLAGS = -g -O0
LDLIBS = -lm

all: fib_okay.exe fib_not_okay.exe

fib_not_okay.exe: fib_not_okay.o fib_main.o
	$(CC) $(CFLAGS) -o $@ $^ $(LDLIBS)

fib_okay.exe: fib_okay.o fib_main.o
	$(CC) $(CFLAGS) -o $@ $^ $(LDLIBS)

clean:
	$(RM) $(wildcard *.o) $(wildcard *.exe)
	$(RM) core $(wildcard core.*)
