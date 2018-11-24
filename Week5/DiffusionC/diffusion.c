/*
 * Note: this code is intentionally very badly written, it has a
 * a number of issues, both conceptually and in the implementation.
 * Do not use this for any other purpose than an exercise in bug
 * fixing.
 */

#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

double *create_temp(int n[]);
void init_temp(double *temp, int coords[],
               int n_global[], int n_local[]);
void update_temp(MPI_Comm comm, double *temp, int n_local[],
                 int n_global[]);

int main(int argc, char *argv[]) {
    const int nr_dims = 2;
    MPI_Init(NULL, NULL);
    int n_global[] = {atoi(argv[1]), atoi(argv[2])};
    int t_max = atoi(argv[3]);
    int my_size;
    MPI_Comm_size(MPI_COMM_WORLD, &my_size);
    /* potentially mess up further by initializing to
     * {1, my_size} */
    int dims[] = {0, 0};
    MPI_Dims_create(my_size, nr_dims, dims);
    int n_local[] = {
        n_global[0]/dims[0], n_global[1]/dims[1]
    };
    /* potentially mess up further by not using a Carthesian
     * communicator */
    MPI_Comm comm;
    int periods[] = {0, 0};
    MPI_Cart_create(MPI_COMM_WORLD, nr_dims, dims, periods,
                    1, &comm);
    int my_rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);
    int coords[nr_dims];
    /* potentially mess up further by reusing rank in
     * MPI_COMM_WORLD */
    MPI_Cart_coords(comm, my_rank, nr_dims, coords);
    double *temp = create_temp(n_local);
    init_temp(temp, coords, n_global, n_local);
    for (int t = 1; t < t_max; t++) {
        update_temp(comm, temp, n_local, n_global);
    }
    /* remove to create a memory leak */
    free(temp);
    MPI_Finalize();
    return EXIT_SUCCESS;
}

double *create_temp(int n[]) {
    double *temp = (double *) malloc(n[0]*n[1]*sizeof(double));
    for (int i = 0; i < n[0]; i++)
        for (int j = 0; j < n[0]; j++)
            temp[i*n[1] + j] = 0.0;
    return temp;
}

#define MIN(X, Y) ((X) < (Y) ? (X) : (Y))

void init_temp(double *temp, int coords[],
               int n_global[], int n_local[]) {
    int n_heated[] = {n_global[0]/10, n_global[1]/10};
    int center[] = {n_global[0]/2, n_global[1]/2};
    int offset[] = {
        coords[0]*n_local[0], coords[1]*n_local[1]
    };
    int lower_left[] = {
        center[0] - n_heated[0]/2, center[1] - n_heated[1]/2
    };
    int upper_right[] = {
        center[0] + n_heated[0]/2, center[1] + n_heated[1]/2
    };
    if (lower_left[0] <= offset[0] &&
            offset[0] <= upper_right[0] &&
        lower_left[1] <= offset[1] &&
            offset[1] <= upper_right[1]) {
        int i_min = lower_left[0] - offset[0];
        int i_max = MIN(n_local[0],
                        upper_right[0] - offset[0]);
        int j_min = lower_left[1] - offset[1];
        int j_max = MIN(n_local[1],
                        upper_right[1] - offset[1]);
        for (int i = i_min; i < i_max; i++)
            for (int j = j_min; j < j_max; j++)
                temp[i*n_local[1] + j] = 1.0;
    }
}

void halo_temp(MPI_Comm comm, double *temp, int n_local[]) {
    const int tag = 17;
    MPI_Datatype row_type, col_type;
    MPI_Type_contiguous(n_local[0], MPI_DOUBLE, &row_type);
    MPI_Type_commit(&row_type);
    MPI_Type_vector(n_local[1], 1, n_local[0], MPI_DOUBLE,
                    &col_type);
    MPI_Type_commit(&col_type);
    int row_source, row_dest;
    MPI_Cart_shift(comm, 0, 1, &row_source, &row_dest);
    int col_source, col_dest;
    MPI_Cart_shift(comm, 1, 1, &col_source, &col_dest);
    MPI_Request left_req, right_req, up_req, down_req;
    MPI_Irecv(temp, 1, col_type, col_source, tag, comm, 
              &left_req);
    MPI_Irecv(temp + n_local[1], 1, col_type, col_dest,
              tag, comm, &right_req);
    MPI_Irecv(temp, 1, row_type, row_source, tag, comm,
              &up_req);
    MPI_Irecv(temp + (n_local[0] - 1)*n_local[1], 1,
              row_type, row_dest, tag, comm, &down_req);
    MPI_Send(temp, 1, col_type, col_dest, tag, comm);
    MPI_Send(temp + n_local[1], 1, col_type, col_source,
             tag, comm);
    MPI_Send(temp, 1, row_type, row_dest, tag, comm);
    MPI_Send(temp + (n_local[0] - 1)*n_local[1], 1,
             row_type, row_source, tag, comm);
    MPI_Wait(&left_req, MPI_STATUS_IGNORE);
    MPI_Wait(&right_req, MPI_STATUS_IGNORE);
    MPI_Wait(&up_req, MPI_STATUS_IGNORE);
    MPI_Wait(&down_req, MPI_STATUS_IGNORE);
}

void update_temp(MPI_Comm comm, double *temp, int n_local[],
                 int n_global[]) {
    halo_temp(comm, temp, n_local);
    double dx = 0.25/n_global[0];
    double dy = 0.25/n_global[1];
    for (int i = 0; i < n_local[0]; i++)
        for (int j = 0; j < n_local[1]; j++) {
            int idx = i*n_local[1] + j;
            int up = (i - 1)*n_local[1] + j;
            int down = (i + 1)*n_local[1] + j;
            int left = i*n_local[1] + j - 1;
            int right = i*n_local[1] + j + 1;
            temp[idx] += (temp[left] - 2*temp[idx] +
                          temp[right])/dx +
                         (temp[up] - 2*temp[idx] +
                          temp[down])/dy;
        }
}
