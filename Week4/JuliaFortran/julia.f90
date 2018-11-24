program pi
    implicit none
    complex, parameter :: c = (-0.62772, -0.42193)
      real, parameter :: x1 = -1.8, x2 = 1.8, y1 = -1.8, y2 = 1.8
      integer, parameter :: max_iters = 255;
      integer :: steps = 100
      character(len=20) :: buffer
      real, dimension(:), allocatable :: x_coords, y_coords
      complex, dimension(:, :), allocatable :: zs
      integer, dimension(:, :), allocatable :: ns
      if (command_argument_count() == 1) then
          call get_command_argument(1, buffer)
          read (buffer, '(I10)') steps
      end if
      call coordinates(x_coords, steps, x1, x2)
      call coordinates(y_coords, steps, y1, y2)
      call z_values(zs, x_coords, y_coords)
      call iterate_zs(zs, ns, c, max_iters)
      call print_results(ns)
contains

    subroutine coordinates(coords, steps, min_coord, max_coord)
        implicit none
        real, dimension(:), allocatable, intent(out) :: coords
        integer, intent(in) :: steps
        real, intent(in) :: min_coord, max_coord
        real :: value, step
        integer :: i
        allocate(coords(steps))
        step = (max_coord - min_coord)/steps
        value = min_coord
        do i = 1, steps
            coords(i) = value
            value = value + step
        end do
    end subroutine coordinates

    subroutine z_values(zs, x_coords, y_coords)
        implicit none
        complex, dimension(:, :), allocatable, intent(inout) :: zs
        real, dimension(:), intent(in) :: x_coords, y_coords
        integer :: i, j
        allocate(zs(size(x_coords), size(y_coords)))
        !$omp parallel do private(i)
        do j = 1, size(y_coords)
            do i = 1, size(x_coords)
                zs(i, j) = cmplx(x_coords(i), y_coords(j))
            end do
        end do
        !$omp end parallel do
    end subroutine z_values

    function iterate_z(z, c, max_iters) result(n)
        implicit none
        complex, intent(inout) :: z
        complex, intent(in) :: c
        integer, intent(in) :: max_iters
        integer :: n
        n = 0
        do while (abs(z) < 2.0 .and. n < max_iters)
            z = z**2 + c
            n = n + 1
        end do
    end function iterate_z

    subroutine iterate_zs(zs, ns, c, max_iters)
        implicit none
        complex, dimension(:, :), intent(inout) :: zs
        integer, dimension(:, :), allocatable, intent(inout) :: ns
        complex, intent(in) :: c
        integer, intent(in) :: max_iters
        integer :: i, j
        allocate(ns(size(zs, 1), size(zs, 2)))
        !$omp parallel do private(i) schedule(guided)
        do j = 1, size(zs, 2)
            do i = 1, size(zs, 1)
                ns(i, j) = iterate_z(zs(i, j), c, max_iters)
            end do
        end do
        !$omp end parallel do
    end subroutine iterate_zs

    subroutine print_results(ns)
        implicit none
        integer, dimension(:, :), intent(in) :: ns
        integer :: i
        character(len=20) :: fmt_str
        write (fmt_str, '(A, I0, A)') '(', size(ns, 2), 'I4)'
        do i = 1, size(ns, 1)
            print fmt_str, ns(i, :)
        end do
    end subroutine print_results

end program pi
