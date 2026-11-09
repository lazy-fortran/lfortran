program test_iso_c_binding_constants_02
   ! On wasm32 (ILP32), `long` and the pointer-sized integer types are 4 bytes;
   ! `long long` and the 64-bit types stay 8.
   use iso_c_binding

   print *, c_long, c_size_t, c_intptr_t, c_ptrdiff_t
   if (c_long /= 4) error stop
   if (c_size_t /= 4) error stop
   if (c_intptr_t /= 4) error stop
   if (c_ptrdiff_t /= 4) error stop

   print *, c_long_long, c_int64_t, c_intmax_t, c_int
   if (c_long_long /= 8) error stop
   if (c_int64_t /= 8) error stop
   if (c_intmax_t /= 8) error stop
   if (c_int /= 4) error stop
end program
