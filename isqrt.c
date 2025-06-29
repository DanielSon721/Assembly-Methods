#include <stdint.h>

/* The integer square root of n is the largest integer whose square
   does not exceeed n.
   From wikipedia: https://en.wikipedia.org/wiki/Integer_square_root
*/

uint32_t isqrt(uint32_t n) {
  uint32_t small, large;

  if (n < 2)
    return n;

  small = isqrt(n >> 2) << 1;
  large = small + 1;
  
  if (large * large > n)
    return small;
  else
    return large;
}
