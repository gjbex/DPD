PROGRAM implicit_typing
    implicit none
    real :: total
    integer :: i
    total = 0.0
    DO i = 1, 10
        total = total + 10.0
    END DO
    PRINT *, total
END PROGRAM implicit_typing
