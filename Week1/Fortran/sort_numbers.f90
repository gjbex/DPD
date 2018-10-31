program sort_numbers

integer :: x(10), n, i, c = 0, ierr
do
    c = c + 1
    read (5, '(I2)', iostat=ierr) x(c)
    if (ierr /= 0) exit
end do
call process(x, c)
do i = 1, c
    print '(I2)', x(i)
end do

contains

subroutine process(x, n)
    integer :: x(:), i, j, y
    do i = 1, n
        do j = i + 1, n
            if (x(j) < x(i)) then
                y = x(i)
                x(i) = x(j)
                x(j) = y
            end if
        end do
    end do
end subroutine

end program
