!> @file
!> @brief Sort integers given via standard input
!> @author Geert Jan Bex (geertjan.bex@uhasselt.be)
!> @mainpage
!>
!> Application that reads integers from standard input and
!> implements a slow alogirthm, writing the result to standard output.
!> Terminate the input on the command line using `ctrl-d`.
!>
!> ~~~~
!>     $ ./sort_numbers.exe
!>     5 9 17 3
!>     3 5 9 17
!> ~~~~
!>
!> *Note:* this program can sort at most 10 integers.
!>
!> If the integers can not be sorted, the application will exit with
!> exit code 1.
!>
program sort_numbers
    use, intrinsic :: iso_fortran_env, only : input_unit, error_unit
    implicit none
    integer, parameter :: nr_numbers = 10
    integer, parameter :: EXIT_FAILURE = 1 !< exit status if sort fails.
    integer, dimension(nr_numbers) :: numbers
    integer :: i, counter = 0, ierr

    do
        counter = counter + 1
        read (input_unit, '(I2)', iostat=ierr) numbers(counter)
        if (ierr /= 0) exit
        if (counter == nr_numbers) then
            write (unit=error_unit, fmt='(A, I0, A)') &
                '### warning: maximum data capacity reached, ', &
                nr_numbers, ' numbers'
        end if
    end do

    call sort_array(numbers, 10, ierr)
    if (ierr /= 0) then
        write (unit=error_unit, fmt='(A)') &
            '### error: sorting failed'
        stop EXIT_FAILURE
    end if

    do i = 1, counter
        print '(I2)', numbers(i)
    end do

contains

    !> @brief sort an integer array of given length
    !> 
    !> Example usage:
    !> 
    !>     integer :: i, ierr
    !>     integer, dimension(5) :: a = [ 3 - i**2, i = 1, 5 ]
    !>     call sort_array(a, size(a), ierr)
    !>     if (ierr /= 0) then
    !>         ! error handling
    !>     end if
    !>
    !> @param[inout] numbers array of integers to sort.
    !> @param[in] n number of values in the array to sort.
    !> @param[out] ierr exit status, non-zero if sorting fails.
    !>
    subroutine sort_array(numbers, n, ierr)
        implicit none
        integer, dimension(:) :: numbers
        integer, intent(out) :: ierr
        integer :: n, i, j, tmp
        if (n > size(numbers)) then
            ierr = 1
        else
            ierr = 0
            do i = 1, n
                do j = i + 1, n
                    if (numbers(j) < numbers(i)) then
                        tmp = numbers(i)
                        numbers(i) = numbers(j)
                        numbers(j) = tmp
                    end if
                end do
            end do
        end if
    end subroutine sort_array

end program sort_numbers
