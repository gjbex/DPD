module palindrome_mod
    implicit none

    public :: is_palindrome

  contains

    logical function is_palindrome(my_str)
        implicit none
        character(len=*), intent(in) :: my_str
        integer :: i, n
        n = len(my_str)
        is_palindrome = .true.
        do i = 1, n/2
            if (my_str(i:i) .ne. my_str(n - i + 1:n - i + 1)) then
                is_palindrome = .false.
                exit
            end if
        end do
    end function is_palindrome

end module palindrome_mod

program palindrome
        use, intrinsic :: iso_fortran_env, only : error_unit
        use :: palindrome_mod, only : is_palindrome
        implicit none
        integer, parameter :: ARGUMENT_ERROR = 1
        character(len=80) :: buffer
        if (command_argument_count() /= 1) then
            write (unit=error_unit, fmt='(A)') &
                '### usage: ./palindrome.exe <string>'
            stop ARGUMENT_ERROR
        end if
        call get_command_argument(1, buffer)
        if (is_palindrome(trim(buffer))) then
            print '(A, " is a palindrome")', trim(buffer)
        else
            print '(A, " is not a palindrome")', trim(buffer)
        end if
end program palindrome
