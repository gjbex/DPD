#include <stdio.h>
#include <stdlib.h>

double *create_temp(int n_x, int n_y);
void init_temp(double *temp, int n_x, int n_y);
void update_temp(double *temp_new, double *temp, int n_x, int n_y);
void print_temp(double *temp, int n_x, int n_y);

int main(int argc, char *argv[]) {
    int n_x = atoi(argv[1]);
    int n_y = atoi(argv[2]);
    int t_max = atoi(argv[3]);
    double *temp = create_temp(n_x, n_y);
    double *temp_new = create_temp(n_x, n_y);
    init_temp(temp, n_x, n_y);
    for (int t = 1; t <= t_max; t++) {
        update_temp(temp_new, temp, n_x, n_y);
        double *tmp = temp;
        temp = temp_new;
        temp_new = tmp;
    }
    print_temp(temp, n_x, n_y);
    free(temp);
    free(temp_new);
    return EXIT_SUCCESS;
}

double *create_temp(int n_x, int n_y) {
    double *temp = (double *) malloc(n_x*n_y*sizeof(double));
    for (int i = 0; i < n_x*n_y; i++)
        temp[i] = 0.0;
    return temp;
}

#define T(X, Y) (temp[((X)*n_y + (Y))])

void init_temp(double *temp, int n_x, int n_y) {
    int n_heated_x = n_x/10;
    int n_heated_y = n_y/10;
    int c_x = n_x/2;
    int c_y = n_y/2;
    for (int i = c_x - n_heated_x; i <= c_x + n_heated_x; i++)
        for (int j = c_y - n_heated_y; j <= c_y + n_heated_y; j++)
            T(i, j) = 1.0;
}

#define T_new(X, Y) (temp_new[((X)*n_y + (Y))])

void update_temp(double *temp_new, double *temp, int n_x, int n_y) {
    double dx2 = 1.0/(n_x*n_x);
    double dy2 = 1.0/(n_y*n_y);
    double d = 1/(2*(dx2 + dy2));
    for (int i = 1; i < n_x - 1; i++)
        for (int j = 1; j < n_y - 1; j++)
            T_new(i, j) = T(i, j) +
                d*((T(i - 1, j) - 2*T(i, j) + T(i + 1, j))*dy2 +
                   (T(i, j - 1) - 2*T(i, j) + T(i, j + 1))*dx2);
    for (int i = 0; i < n_x; i++)
        T_new(i, 0) = T_new(i, n_y - 1) = 0.0;
    for (int j = 1; j < n_y - 1; j++)
        T_new(0, j) = T_new(n_x - 1, j) = 0.0;
}

#undef T_new

void print_temp(double *temp, int n_x, int n_y) {
    for (int i = 0; i < n_x; i++)
        for (int j = 0; j < n_y; j++)
            printf("%.4e%c", T(i, j), j == n_y - 1 ? '\n' : ' ');
}

#undef T
