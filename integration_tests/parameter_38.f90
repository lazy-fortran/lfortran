! A module parameter array indexed by a variable inside a procedure that
! takes an assumed-shape array, so the procedure is copied to take it by data
! and the parameter is indexed as its value.
module parameter_38_mod
    implicit none
    integer, parameter :: ZIGZAG(0:3) = [0, 1, 3, 2]
    type :: dec_t
        integer :: quant(0:3, 0:1) = 0
    end type
contains
    logical function read_quant(d, seg) result(ok)
        type(dec_t), intent(inout) :: d
        integer, intent(in) :: seg(:)
        integer :: k
        ok = .false.
        do k = 0, 3
            if (size(seg) > 0) then
                d%quant(ZIGZAG(k), 1) = seg(1 + k)
            end if
        end do
        ok = .true.
    end function
end module parameter_38_mod
program parameter_38
    use parameter_38_mod
    implicit none
    type(dec_t) :: d
    if (.not. read_quant(d, [10, 20, 30, 40])) error stop
    if (any(d%quant(:, 1) /= [10, 20, 40, 30])) error stop
    print *, d%quant(:, 1)
end program parameter_38
