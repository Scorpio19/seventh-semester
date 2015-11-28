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

extern void simd_alpha(uint8_t *fore, uint8_t *back, uint32_t size, uint16_t *alpha, uint16_t *bAlpha);

void sequential_alpha(
        uint8_t *fore, uint8_t *back,
        uint32_t size, uint16_t alpha) {
    uint32_t i;
    for (i = 0; i < size; i++, fore++, back++) {
        uint16_t r = (*fore * alpha) / 256 + (*back * (255-alpha)) / 256;
        if (r > UCHAR_MAX) {
            *fore = UCHAR_MAX;
        } else {
            *fore = r;
        }
    }
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: %s <alpha>", argv[0]);
        return -1;
    }

    uint32_t x, y, n;
    uint16_t alpha = atoi(argv[1]);
    uint8_t *fore = stbi_load("scarlett.png", &x, &y,  &n, 0);
    uint8_t *back = stbi_load("flores.png", &x, &y,  &n, 0);
    printf("Alpha used: %d\n", alpha);

    double ts = get_time();
    sequential_alpha(fore, back, x * y * n, alpha);
    ts = get_time() - ts;

    stbi_write_png("outputSequential.png", x, y, n, fore, x * n);
    stbi_image_free(fore);
    stbi_image_free(back);
    printf("Sequential Time: %f\n", ts);

    fore = stbi_load("scarlett.png", &x, &y,  &n, 0);
    back = stbi_load("flores.png", &x, &y,  &n, 0);

    uint16_t alphas[8], bAlphas[8];
    uint32_t i;
    for (i = 0; i < 8; i++) {
        alphas[i] = alpha;
        bAlphas[i] = 255 - alpha;
    }

    double tp = get_time();
    simd_alpha(fore, back, x * y * n, alphas, bAlphas);
    tp = get_time() - tp;

    stbi_write_png("outputSIMD.png", x, y, n, fore, x * n);
    stbi_image_free(fore);
    printf("SIMD Time: %f\n", tp);
    
    printf("Speedup = %f\n", ts / tp);
    return 0;
}
