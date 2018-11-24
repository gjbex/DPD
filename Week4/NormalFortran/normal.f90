program normal
    implicit none
    integer, parameter :: n = 100000, nr_samples = 10
    real, dimension(n) :: values
    real :: avg, stddev
    integer :: i
    do i = 1, nr_samples
        call init_values(values)
        call stats(values, avg, stddev)
        print '(2F15.6)', avg, stddev
    end do

contains

    subroutine init_values(values)
        implicit none
        real, dimension(:), intent(inout) :: values
        integer :: i
        !$omp parallel do
        do i = 1, size(values)
            values(i) = box_muller()
        end do
    end subroutine init_values

    function box_muller() result(r)
        implicit none
        real :: r
        real :: s, u, v
        real :: next_value = 0.0
        logical :: has_next = .false.
        if (has_next) then
            has_next = .false.
            r = next_value
        else
            s = 2.0
            do while (abs(s) < 1.0e-6 .or. s >= 1.0)
                call random_number(u)
                call random_number(v)
                u = 2.0*u - 1.0
                v = 2.0*v - 1.0
                s = u**2 + v**2
            end do
            r = u*sqrt(-2.0*log(s)/s)
            next_value = v*sqrt(-2.0*log(s)/s)
        end if
    end function box_muller

    subroutine stats(values, avg, stddev)
        implicit none
        real, dimension(:), intent(in) :: values
        real, intent(out) :: avg, stddev
        integer :: i, n
        real :: total, total2
        n = size(values)
        total = 0.0
        total2 = 0.0
        !$omp parallel do
        do i = 1, n
            total = total + values(i)
            total2 = total2 + values(i)**2
        end do
        avg = total/n
        stddev = sqrt(total2/n - avg**2)
    end subroutine stats

end program normal
