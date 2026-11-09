program bindc_63
    ! The kinds of c_long, c_size_t, c_intptr_t and c_ptrdiff_t follow the
    ! target C ABI, so C functions taking or returning them are called with
    ! matching signatures, also on 32-bit targets such as wasm32.
    use iso_c_binding, only: c_long, c_size_t, c_intptr_t, c_ptrdiff_t, &
        c_char, c_null_char, c_ptr, c_null_ptr, c_sizeof
    implicit none
    interface
        integer(c_size_t) function strlen(s) bind(C, name="strlen")
            import :: c_size_t, c_char
            character(kind=c_char), intent(in) :: s(*)
        end function
        integer(c_long) function labs(x) bind(C, name="labs")
            import :: c_long
            integer(c_long), value :: x
        end function
    end interface
    type(c_ptr) :: p

    p = c_null_ptr
    if (strlen("hello" // c_null_char) /= 5_c_size_t) error stop 1
    if (labs(-7_c_long) /= 7_c_long) error stop 2
    if (c_sizeof(0_c_size_t) /= c_sizeof(p)) error stop 3
    if (c_sizeof(0_c_intptr_t) /= c_sizeof(p)) error stop 4
    if (c_sizeof(0_c_ptrdiff_t) /= c_sizeof(p)) error stop 5
    if (c_sizeof([p, p]) /= 2 * c_sizeof(p)) error stop 6
    print *, c_sizeof(p), c_sizeof(0_c_long)
end program
