CC = gcc
CFLAGS = -O2 -g -Wall -Wextra

all: tree.exe

tree.exe: tree.o main.o
	$(CC) $(CFLAGS) -o $@ $^

clean:
	$(RM) $(wildcard *.o) $(wildcard *.exe)
	$(RM) core $(wildcard core.*)
