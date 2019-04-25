INTEGER FUNCTION factorial(n)
IMPLICIT NONE
INTEGER, INTENT(IN) :: n
INTEGER :: i
factorial = 1
DO i = 2, n
factorial = factorial*i
END DO
END FUNCTION factorial
