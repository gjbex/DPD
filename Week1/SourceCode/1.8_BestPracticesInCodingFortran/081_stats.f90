program stats
    use, intrinsic :: iso_fortran_env, only : f8 => REAL64
    use :: stats_mod
    implicit none
    type(stats_type) :: statistics
    integer :: i
    statistics = new_stats()
    do i = 1, 10
        call statistics%add(5.0_f8)
    end do
    statistics%n = 5
    print '(F5.1)', statistics%avg()
end program stats
