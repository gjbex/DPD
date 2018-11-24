! Note: this code is intentionally very badly written, it has a
! a number of issues, both conceptually and in the implementation.
! Do not use this for any other purpose than an exercise in bug
! fixing.

program diffusion_serial
    use :: mpi_f08
    implicit none
    integer, parameter :: nr_dims = 2
    integer :: n_x_global, n_y_global, &
               t_max, t, my_rank, my_size
    integer, dimension(nr_dims) :: dims = [ 0, 0], coords
    logical, dimension(nr_dims) :: periods = [ .false., .false. ]
    type(MPI_Comm) :: comm
    real, dimension(:, :), allocatable :: temp
    character(len=80) :: buffer
    
    call MPI_Init()

    ! get command line arguments
    call get_command_argument(1, buffer)
    read (buffer, '(I10)') n_x_global
    call get_command_argument(2, buffer)
    read (buffer, '(I10)') n_y_global
    call get_command_argument(3, buffer)
    read (buffer, '(I10)') t_max

    call MPI_Comm_size(MPI_COMM_WORLD, my_size)
    call MPI_Dims_create(my_size, nr_dims, dims)
    call MPI_Cart_create(MPI_COMM_WORLD, nr_dims, dims, periods, &
                         .true., comm)
    call MPI_Comm_rank(MPI_COMM_WORLD, my_rank)
    call MPI_Cart_coords(comm, my_rank, nr_dims, coords)

    call create_temp(temp, n_x_global/dims(1), n_y_global/dims(2))
    call init_temp(temp, coords, n_x_global, n_y_global)
    t = 0
    do t = 1, t_max
        call update_temp(comm, temp)
    end do
    call print_temp(temp)

    call MPI_Finalize()

contains

    subroutine create_temp(temp, n_x, n_y)
        implicit none
        real, dimension(:, :), allocatable, intent(inout) :: temp
        integer, intent(in) :: n_x, n_y
        allocate(temp(n_x, n_y))
        temp = 0.0
    end subroutine create_temp

    subroutine init_temp(temp, coords, n_x_global, n_y_global)
        implicit none
        real, dimension(:, :), intent(inout) :: temp
        integer, dimension(:), intent(in) :: coords
        integer, intent(in) :: n_x_global, n_y_global
        integer :: c_x, c_y, n_heated_x, n_heated_y, &
                   offset_x, offset_y, ll_x, ll_y, ur_x, ur_y
        c_x = n_x_global/2
        c_y = n_y_global/2
        n_heated_x = n_x_global/10
        n_heated_y = n_y_global/10
        offset_x = (coords(1) - 1)*size(temp, 1)
        offset_y = (coords(2) - 1)*size(temp, 2)
        ll_x = c_x - n_heated_x
        ll_y = c_y - n_heated_y
        ur_x = c_x + n_heated_x
        ur_y = c_y + n_heated_y
        if (ll_x <= offset_x .and. offset_x <= ur_x .and. &
            ll_y <= offset_y .and. offset_y <= ur_y) then
            temp(offset_x:min(size(temp, 1), ur_x - offset_x), &
                 offset_y:min(size(temp, 2), ur_y - offset_y)) = 1.0
        end if
    end subroutine init_temp

    subroutine halo_temp(comm, temp)
        implicit none
        type(MPI_Comm), intent(in) :: comm
        real, dimension(:, :), intent(inout) :: temp
        type(MPI_Datatype) :: row_type, col_type
        integer :: col_source, col_dest, row_source, row_dest
        type(MPI_Request) :: left_req, right_req, up_req, down_req
        integer, parameter :: tag = 17

        call MPI_Type_vector(size(temp, 2), 1, size(temp, 1), &
                             MPI_REAL, row_type)
        call MPI_Type_commit(row_type)
        call MPI_Type_contiguous(size(temp, 1), MPI_REAL, col_type)
        call MPI_Type_commit(col_type)

        call MPI_Cart_shift(comm, 0, 1, row_source, row_dest)
        call MPI_Cart_shift(comm, 1, 1, col_source, col_dest)

        call MPI_Irecv(temp, 1, col_type, col_source, tag, comm, &
                       left_req)
        call MPI_Irecv(temp(1, size(temp, 2)), 1, col_type, &
                      col_dest, tag, comm, right_req)
        call MPI_Irecv(temp, 1, row_type, row_dest, tag, comm, &
                       up_req)
        call MPI_Irecv(temp(size(temp, 1), 1), 1, row_type, &
                       row_dest, tag, comm, down_req)

        call MPI_Send(temp, 1, col_type, col_dest, tag, comm)
        call MPI_Send(temp(1, size(temp, 2)), 1, col_type, &
                      col_source, tag, comm) 
        call MPI_Send(temp, 1, row_type, row_dest, tag, comm)
        call MPI_Send(temp(size(temp, 1), 1), 1, row_type, &
                           row_dest, tag, comm)

        call MPI_Wait(left_req, MPI_STATUS_IGNORE)
        call MPI_Wait(right_req, MPI_STATUS_IGNORE)
        call MPI_Wait(up_req, MPI_STATUS_IGNORE)
        call MPI_Wait(down_req, MPI_STATUS_IGNORE)
    end subroutine halo_temp

    subroutine update_temp(comm, T)
        ! inconsistency in parameter naming to make formula easier to
        ! read
        implicit none
        type(MPI_Comm), intent(in) :: comm
        real, dimension(:, :), intent(inout) :: T
        real :: dx2, dy2, d
        integer :: i, j
        call halo_temp(comm, T)
        dx2 = 1.0/size(T, 1)**2
        dy2 = 1.0/size(T, 2)**2
        d = 1.0/(2*(dx2 + dy2))
        do j = 2, size(T, 2)
            do i = 2, size(T, 1)
                T(i, j) = T(i, j) + &
                    d*((T(i - 1, j) - 2*T(i, j) + T(i + 1, j))*dy2 + &
                       (T(i, j - 1) - 2*T(i, j) + T(i, j + 1))*dx2)
            end do
        end do
    end subroutine update_temp

    subroutine print_temp(temp)
        implicit none
        real, dimension(:, :), intent(in) :: temp
        character(len=20) :: str_fmt
        integer :: i
        write (str_fmt, '("(", I0, "E15.4)")') size(temp, 2)
        do i = 1, size(temp, 1)
            print str_fmt, temp(i, :)
        end do
    end subroutine print_temp

end program diffusion_serial

