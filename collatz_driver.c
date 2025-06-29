#include <stdint.h>
#include <stdio.h>

uint32_t inputs[] = {2, 4, 6, 8, 10};
extern uint32_t collatz(uint32_t n, int d);

int main() {
  uint32_t i;

  for (i = 0; inputs[i]; i++) {
    printf("%d -> %d\n", inputs[i], collatz(inputs[i], 0));
  }
}
