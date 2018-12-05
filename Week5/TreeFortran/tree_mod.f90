module tree_mod

    type, public :: node_type
        type(node_type), dimension(:), allocatable :: children
        real :: value
    contains
        procedure, nopass, public :: new
        procedure, public :: get_value
        procedure, public :: set_value
        procedure, public :: get_nr_children
        procedure, public :: set_child
        procedure, public :: get_child
        procedure, public :: show
        procedure, public :: visit
    end type node_type

contains

    function new(value, nr_children) result(node)
        real :: value
        integer :: nr_children
        type(node_type), pointer :: node
        allocate(node)
        node%value = value
        allocate(node%children(nr_children))
    end function new

    real function get_value(this)
        class(node_type) :: this
        get_value = this%value
    end function get_value

    subroutine set_value(this, value)
        class(node_type) :: this
        real :: value
        this%value = value
    end subroutine set_value

    integer function get_nr_children(this)
        class(node_type) :: this
        get_nr_children = size(this%children)
    end function get_nr_children

    subroutine set_child(this, child_nr, child)
        class(node_type) :: this
        integer :: child_nr
        class(node_type) :: child
        this%children(child_nr)%value = child%value
    end subroutine set_child

    function get_child(this, child_nr) result(child)
        class(node_type) :: this
        integer :: child_nr
        type(node_type) :: child
        child%value = this%children(child_nr)%value
    end function get_child

    recursive subroutine show(this, indent)
        class(node_type) :: this
        integer, optional :: indent
        integer :: child_nr, indentation
        type(node_type) :: child
        character(len=32) :: fmt_str
        indentation = indent
        write (fmt_str, '(A, I0, A)') &
            '(A', indentation, ', ES15.3, A, I3)'
        print fmt_str, '', this%get_value(), &
            ', children: ', this%get_nr_children()
        do child_nr = 1, this%get_nr_children()
            child = this%get_child(child_nr)
            call child%show(indentation + 2)
        end do
    end subroutine show

    recursive subroutine visit(this, transformation)
        class(node_type) :: this
        interface
            real function transformation(value)
                implicit none
                real, intent(in) :: value
            end function transformation
        end interface
        integer :: child_nr
        type(node_type) :: child
        call this%set_value(transformation(this%get_value()))
        do child_nr = 1, this%get_nr_children()
            child = this%get_child(child_nr)
            call child%visit(transformation)
        end do
    end subroutine visit

end module tree_mod
