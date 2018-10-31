#include <stdio.h>
#include <string.h>

int pal(char a[]);

int main(int argc, char *argv[]) {
    printf("%s is %s palindrome\n",
           argv[1], pal(argv[1]) ? "a" : "not a");
    return 0;
}

int pal(char a[]) {
    if (strlen(a))
        if (a[0] != a[strlen(a)])
            return 0;
        else {
            a[strlen(a)] = "\0";
            return pal(a[1]);
        }
    else
        return 1;
}
