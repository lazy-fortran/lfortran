module c_f_pointer_of_pointer_01_m
    use iso_c_binding
    implicit none
    type :: ctx_t
        integer :: kind = 0
    end type ctx_t
contains
    integer(c_int32_t) function make(kind, handle_arg) bind(C, name="make") result(code)
        integer(c_int32_t), value :: kind
        type(c_ptr), value :: handle_arg
        type(c_ptr), pointer :: handle
        type(ctx_t), pointer :: ctx
        call c_f_pointer(handle_arg, handle)
        allocate(ctx)
        ctx%kind = kind
        handle = c_loc(ctx)
        code = 0
    end function make

    integer(c_int32_t) function kind_of(handle_arg) bind(C, name="kind_of") result(k)
        type(c_ptr), value :: handle_arg
        type(c_ptr), pointer :: handle
        type(ctx_t), pointer :: ctx
        call c_f_pointer(handle_arg, handle)
        call c_f_pointer(handle, ctx)
        k = ctx%kind
        deallocate(ctx)
        handle = c_null_ptr
    end function kind_of
end module c_f_pointer_of_pointer_01_m

program c_f_pointer_of_pointer_01
    ! c_f_pointer of a c_ptr with the POINTER attribute converts the c_ptr
    ! that the pointer points to.
    use c_f_pointer_of_pointer_01_m
    implicit none
    type(c_ptr), target :: h
    h = c_null_ptr
    if (make(42_c_int32_t, c_loc(h)) /= 0) error stop 1
    if (kind_of(c_loc(h)) /= 42) error stop 2
    if (c_associated(h)) error stop 3
    print *, "ok"
end program c_f_pointer_of_pointer_01
