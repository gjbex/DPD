#include <complex.h>
#include <stdio.h>
#include <stdlib.h>

typedef float complex Complex;

float *coordinates(float min_coord, float max_coord, int steps);
Complex *z_values(float *x_coords, int n_x, float *y_coords, int n_y);
int *iterate_zs(Complex *zs, int n_x, int n_y,
         Complex c, int max_iters);
void print_results(int *ns, int n_x, int n_y);

int main(int argc, char *argv[]) {
    const Complex c = -0.62772 - 0.42193*I;
    const float x1 = -1.8;
    const float x2 = 1.8;
    const float y1 = -1.8;
    const float y2 = 1.8;
    const int max_iters = 255;
    size_t steps = 100;
    if (argc > 1)
        steps = atoi(argv[1]);
    float *x_coords = coordinates(x1, x2, steps);
    float *y_coords = coordinates(y1, y2, steps);
    Complex *zs = z_values(x_coords, steps, y_coords, steps);
    int *ns = iterate_zs(zs, steps, steps, c, max_iters);
    print_results(ns, steps, steps);
    return 0;
}

float *coordinates(float min_coord, float max_coord, int steps) {
    float *coords = (float *) malloc(steps*sizeof(float));
    const float step = (max_coord - min_coord)/steps;
    float value = min_coord;
    for (int i = 0; i < steps; i++) {
        coords[i] = value;
        value += step;
    }
}

Complex *z_values(float *x_coords, int n_x, float *y_coords, int n_y) {
    Complex *zs = (Complex *) malloc(n_x*n_y*sizeof(Complex));
    int idx = 0;
    for (int i = 0; i < n_y; i++)
        for (int j = 0; j < n_x; j++)
            zs[i++] = x_coords[j] + y_coords[i]*I;
    return zs;
}

int iterate_z(Complex z, Complex c, int max_iters) {
    int n = 0;
    Complex z_in = z;
    while (cabs(z) < 2.0 && n++ < max_iters)
        z = z*z + c;
    return n;
}

int *iterate_zs(Complex *zs, int n_x, int n_y,
         Complex c, int max_iters) {
    int *ns = (int *) malloc(n_x*n_y*sizeof(int));
    for (int i = 0; i < n_x*n_y; i++)
        ns[i] = iterate_z(zs[i], c, max_iters);
    return ns;
}

void print_results(int *ns, int n_x, int n_y) {
    int idx = 0;
    for (int j = 0; j < n_y; j++)
        for (int i = 0; i < n_x; i++)
            printf("%d%c", ns[idx++], i =  n_x - 1 ? '\n' : ' ');
}
