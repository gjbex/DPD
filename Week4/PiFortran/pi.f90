program pi
    use :: mpi
    implicit none
    integer, parameter :: tag = 17, n = 10000
    real :: a, b, delta, partial_pi, buffer
    integer :: my_rank, my_size, other_rank, ierr
    call MPI_Init(ierr)
    call MPI_Comm_rank(MPI_COMM_WORLD, my_rank, ierr) 
    call MPI_Comm_size(MPI_COMM_WORLD, my_size, ierr) 
    delta = 1.0/my_size
    a = my_rank*delta
    b = a + delta
    partial_pi = compute_partial_pi(a, b, n)
    if (my_rank == 0) then
        do other_rank = 0, my_size - 1
            call MPI_Recv(buffer, 1, MPI_REAL, other_rank, tag, &
                          MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)
            partial_pi = partial_pi + buffer
        end do
        print '(A, ES20.6)', 'pi = ', partial_pi
    else
        call MPI_Send(partial_pi, 1, MPI_REAL, 0, tag, &
                      MPI_COMM_WORLD, ierr)
    end if
    call MPI_Finalize(ierr)

contains

      function compute_partial_pi(a, b, n) result(partial_pi)
          implicit none
          real, intent(in) :: a, b
          integer, intent(in) :: n
          integer :: i
          real :: partial_pi, x, delta
          partial_pi = 0.0
          x = a
          delta = (b - a)/n
          do i = 1, n
              partial_pi = partial_pi + 4.0/(1.0 + x**2)
              x = x + delta
          end do
          partial_pi = partial_pi*delta
      end function compute_partial_pi

end program pi
