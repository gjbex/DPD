program average
    implicit none
    integer, parameter :: n = 100, y = 27, z = 448, r = 3
    real, dimension(:, :, :), allocatable :: values
    real :: avg, stddev
    call create_values(values, n)
    call init_values(values)
    call compute_states(values, y, z, r, avg, stddev)
    print '("avg = ", F10.3, ", stddev = ", F10.3)', avg, stddev

contains

    subroutine create_values(values, n)
        implicit none
        real, dimension(:, :, :), allocatable, intent(inout) :: values
        integer, intent(in) :: n
        allocate(values(n, 2*n, 3*n))
    end subroutine create_values

    subroutine init_values(values)
        implicit none
        real, dimension(:, :, :), intent(inout) :: values
        real :: r
        integer :: i, j, k, n
        n = size(values, 1)
        do k = 1, size(values, 3)
            do j = 1, size(values, 2)
                do i = 1, size(values, 3)
                    call random_number(r)
                    values(i, j, k) = r
                end do
            end do
        end do
    end subroutine init_values

    subroutine compute_states(values, i1, i2, rank, avg, stddev)
        implicit none
        real, dimension(:, :, :), intent(in) :: values
        integer, intent(in) :: i1, i2, rank
        real, intent(out) :: avg, stddev
        real :: sum1, sum2
        integer :: i, n
        n = size(values, rank)
        sum1 = 0.0
        sum2 = 0.0
        do i = 1, n
            if (rank == 1) then
                sum1 = sum1 + values(i, i1, i2)
                sum2 = sum2 + values(i, i1, i2)**2
            else if (rank == 2) then
                sum1 = sum1 + values(i1, i, i2)
                sum2 = sum2 + values(i1, i, i2)**2
            else if (rank == 3) then
                sum1 = sum1 + values(i1, i2, i)
                sum2 = sum2 + values(i1, i2, i)**2
            end if
            avg = sum1/n
            stddev = sqrt(sum2 - sum1**2)
        end do
    end subroutine compute_states

end program average
