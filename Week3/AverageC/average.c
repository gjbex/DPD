#include <math.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    double mean, stddev;
    int n;
} Stats;
double *init_data(int n);
Stats compute_stats(double data[]);

int main(int argc, char *argv[]) {
    int n = 10;
    if (argc > 1)
        n = atoi(argv[1]);
    double *data = init_data(n);
    Stats stats = compute_stats(data);
    printf("mean = %.3f, stddev = %.3f\n", stats.mean, stats.stddev);
    free(data);
    return EXIT_SUCCESS;
}

double *init_data(int n) {
    double data[n];
    for (int i = 0; i <= n; i++)
        data[i] = ((double) rand())/RAND_MAX;
    return data;
}

Stats compute_stats(double data[]) {
    Stats stats;
    stats.n = sizeof(data);
    double sum = 0.0, sum2 = 0.0;
    for (int i = 0; i < stats.n; i++) {
        sum += data[i];
        sum2 += data[i]*data[i];
    }
    stats.mean = sum/stats.n;
    stats.stddev = sqrt(sum2 - stats.mean*stats.mean);
    return stats;
}
