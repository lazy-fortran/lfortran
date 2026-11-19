program transfer_42
    ! transfer of an allocatable array to a character scalar mold
    use iso_fortran_env, only: int8
    implicit none
    integer(int8), allocatable :: b(:)
    character(4) :: tag
    allocate(b(6))
    b = [73_int8, 69_int8, 78_int8, 68_int8, 0_int8, 0_int8]
    tag = transfer(b, tag)
    if (tag /= 'IEND') error stop
    tag = transfer(b(3:6), tag)
    if (tag(1:2) /= 'ND') error stop
    print *, tag(1:2)
end program
