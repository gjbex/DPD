#include <stdio.h>

int main() {
    int a[] = {1, 2, 3, 4, 5};
    for (int i = 0; i < 5; i++)
        printf("%d: %d\n", i, i[a]);
    return 0;
}
