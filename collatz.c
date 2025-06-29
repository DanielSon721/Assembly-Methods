#include <stdint.h>
#include <stdio.h>

/*
https://en.wikipedia.org/wiki/Collatz_conjecture
*/

uint32_t collatz(uint32_t n, int d) {
  /*   printf("%d\n", n);*/
  if (n != 1) {
    if (n % 2)
      return collatz(3 * n + 1, d + 1);
    else {
      return collatz(n / 2, d + 1);
    }
  }

  return d;
}
