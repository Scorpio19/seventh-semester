#include <stdio.h>
#include <stdint.h>
#include <limits.h>
#include <time.h>

#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"

#define NANOSEC_PER_SEC 1E9

double get_time(void) {
    struct timespec now;
    clock_gettime(CLOCK_MONOTONIC, &now);
    double t = now.tv_sec * NANOSEC_PER_SEC + now.tv_nsec;
    return t / NANOSEC_PER_SEC;
}

extern void simd_light(uint8_t *data, uint32_t size, uint8_t *light);

void sequential_light(
        uint8_t *data, uint32_t x, 
        uint32_t y, uint8_t light) {
    uint32_t i, size = x * y;
    for (i = 0; i < size; i++, data++) {
        uint16_t r = *data + light;
        if (r > UCHAR_MAX) {
            *data = UCHAR_MAX;
        } else {
            *data = r;
        }
    }
}

int main(void) {
    uint32_t x, y, n;
    uint8_t *data = stbi_load("scarlett.png", &x, &y,  &n, 0);
    printf("x = %d, y = %d, n = %d\n", x, y, n);

    double ts = get_time();
    sequential_light(data, x, y, 100);
    ts = get_time() - ts;

    stbi_write_png("output1.png", x, y, n, data, x * n);
    stbi_image_free(data);
    printf("Sequential Time: %f\n", ts);

    data = stbi_load("scarlett.png", &x, &y,  &n, 0);
    uint8_t light[16];
    uint32_t i;
    for (i = 0; i < 16; i++) light[i] = 100;

    double tp = get_time();
    simd_light(data, x*y, light);
    tp = get_time() - tp;

    stbi_write_png("output2.png", x, y, n, data, x * n);
    stbi_image_free(data);
    printf("SIMD Time: %f\n", tp);
    
    printf("Speedup = %f\n", ts / tp);
    return 0;
}
