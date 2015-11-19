#include <stdio.h>
#include <stdint.h>

extern int64_t suma(int64_t, int64_t);

int main(void) {
    int64_t a = 10;
    int64_t b = 25;
    int64_t c;

    c = suma(a, b);

    printf("%ld + %ld = %ld\n", a, b, c);
    return 0;
}
