! Variables of a main program implicitly have the SAVE attribute, so an
! internal procedure reached through a procedure pointer may still use them
! after the main program has returned, as a callback does under emscripten.
! Here it runs from an exit handler after deep calls reused the stack.
! (GFortran calls internal procedures through a trampoline on the host's
! stack, so it cannot run this test.)
module save_32_mod
use iso_c_binding, only: c_int, c_funptr, c_funloc
implicit none
abstract interface
    subroutine frame_i()
    end subroutine
end interface
procedure(frame_i), pointer :: frame => null()
interface
    integer(c_int) function atexit(f) bind(C, name="atexit")
    import :: c_int, c_funptr
    type(c_funptr), value :: f
    end function
    subroutine abort() bind(C, name="abort")
    end subroutine
end interface
contains
subroutine run(f)
    procedure(frame_i) :: f
    frame => f
    if (atexit(c_funloc(hook)) /= 0) error stop
end subroutine
recursive subroutine clobber(n)
    integer, intent(in) :: n
    integer :: pad(1000)
    pad = -1
    if (n > 0) call clobber(n - 1)
    if (pad(n + 1) /= -1) call abort()
end subroutine
subroutine hook() bind(C)
    call clobber(200)
    call frame()
end subroutine
end module

program save_32
use save_32_mod, only: run, abort
implicit none
type :: point
    integer :: x, y
end type
character(len=:), allocatable :: name
integer :: big(1000)
integer :: count
type(point) :: p
name = "start"
big = 7
count = 5
p = point(3, 4)
call run(compose)
print *, "main done"
contains
subroutine compose()
    name = name // "+"
    print *, name, sum(big), count, p%x + p%y
    if (name /= "start+") call abort()
    if (sum(big) /= 7000) call abort()
    if (count /= 5) call abort()
    if (p%x + p%y /= 7) call abort()
end subroutine
end program
