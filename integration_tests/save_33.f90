! A saved array of characters of kind 4 holds four bytes per character,
! also when initialized with shorter literals that are padded with blanks.
module save_33_mod
    implicit none
    character(kind=4, len=3) :: m(2) = [4_"ab", 4_"cd"]
end module save_33_mod

program save_33
    use save_33_mod, only: m
    implicit none
    character(kind=4, len=2) :: u(2)
    character(kind=4, len=3), save :: w(2) = [4_"xy", 4_"zw"]
    integer(4) :: k(4), k6(6)

    u = [4_"wx", 4_"yz"]
    k = transfer(u, k)
    if (any(k /= [119, 120, 121, 122])) error stop 1
    if (u(2) /= 4_"yz") error stop 2

    k6 = transfer(w, k6)
    if (any(k6 /= [120, 121, 32, 122, 119, 32])) error stop 3
    if (w(1) /= 4_"xy ") error stop 4

    k6 = transfer(m, k6)
    if (any(k6 /= [97, 98, 32, 99, 100, 32])) error stop 5
    m(2) = 4_"efg"
    if (m(1) /= 4_"ab " .or. m(2) /= 4_"efg") error stop 6
    print *, "OK"
end program save_33
