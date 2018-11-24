#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

double compute_partial_pi(double a, double b, int n);

int main() {
    const int tag = 17;
    const int n = 10000;
    int my_rank, my_size;
    MPI_Init(NULL, NULL);
    MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);
    MPI_Comm_size(MPI_COMM_WORLD, &my_size);
    double delta = 1.0/my_size;
    double a = my_rank*delta;
    double b = a + delta;
    double partial_pi = compute_partial_pi(a, b, n);
    if (my_rank == 0) {
        double buffer;
        for (int other_rank = 0; other_rank < my_size; other_rank++) {
            MPI_Recv(&buffer, 1, MPI_DOUBLE, other_rank, tag,
                     MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            partial_pi += buffer;
        }
        printf("pi = %.6f\n", partial_pi);
    } else {
        MPI_Ssend(&partial_pi, 1, MPI_DOUBLE, 0, tag, MPI_COMM_WORLD);
    }
    MPI_Finalize();
    return 0;
}

double compute_partial_pi(double a, double b, int n) {
    double partial_pi = 0.0;
    double x = a;
    double delta = (b - a)/n;
    for (int i = 0; i < n; i++) {
        partial_pi += 4.0/(1.0 + x*x);
        x += delta;
    }
    return partial_pi*delta;
}
