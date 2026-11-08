! With --fast, a*b + c becomes llvm.fmuladd: fused only where the target
! has the instruction, not an exactly rounded llvm.fma computed in software.
module fma_contract_m
    implicit none
contains
    real(8) function muladd(a, b, c) result(r)
        real(8), intent(in) :: a, b, c
        r = a * b + c
    end function muladd
end module fma_contract_m

program fma_contract
    use fma_contract_m, only: muladd
    implicit none
    print *, muladd(1.5d0, 2.0d0, 0.25d0)
end program fma_contract
