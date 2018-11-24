program diffusion_serial
    implicit none
    integer :: n_x, n_y, t_max, t
    real, dimension(:, :), allocatable :: temp, temp_new
    character(len=80) :: buffer
    
    ! get command line arguments
    call get_command_argument(1, buffer)
    read (buffer, '(I10)') n_x
    call get_command_argument(2, buffer)
    read (buffer, '(I10)') n_y
    call get_command_argument(3, buffer)
    read (buffer, '(I10)') t_max

    call create_temp(temp, n_x, n_y)
    call create_temp(temp_new, n_x, n_y)
    call init_temp(temp)
    t = 0
    do t = 1, t_max
        if (mod(t, 2) == 1) then
            call update_temp(temp_new, temp)
        else
            call update_temp(temp, temp_new)
        end if
    end do
    if (mod(t, 2) == 0) then
        call print_temp(temp_new)
    else
        call print_temp(temp)
    end if

contains

    subroutine create_temp(temp, n_x, n_y)
        implicit none
        real, dimension(:, :), allocatable, intent(inout) :: temp
        integer, intent(in) :: n_x, n_y
        allocate(temp(n_x, n_y))
        temp = 0.0
    end subroutine create_temp

    subroutine init_temp(temp)
        implicit none
        real, dimension(:, :), intent(inout) :: temp
        integer :: c_x, c_y, n_heated_x, n_heated_y
        c_x = size(temp, 1)/2
        c_y = size(temp, 2)/2
        n_heated_x = size(temp, 1)/10
        n_heated_y = size(temp, 2)/10
        temp(c_x - n_heated_x:c_x + n_heated_x, &
             c_y - n_heated_y:c_y + n_heated_y) = 1.0
    end subroutine init_temp

    subroutine update_temp(T_new, T)
        ! inconsistency in parameter naming to make formula easier to
        ! read
        implicit none
        real, dimension(:, :), intent(inout) :: T_new
        real, dimension(:, :), intent(in) :: T
        real :: dx2, dy2, d
        integer :: i, j
        dx2 = 1.0/size(T, 1)**2
        dy2 = 1.0/size(T, 2)**2
        d = 1.0/(2*(dx2 + dy2))
        do j = 2, size(T, 2)
            do i = 2, size(T, 1)
                T_new(i, j) = T(i, j) + &
                    d*((T(i - 1, j) - 2*T(i, j) + T(i + 1, j))*dy2 + &
                       (T(i, j - 1) - 2*T(i, j) + T(i, j + 1))*dx2)
            end do
        end do
        T_new(:, 1) = 0.0
        T_new(:, n_y) = 0.0
        T_new(1, :) = 0.0
        T_new(n_x, :) = 0.0
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
