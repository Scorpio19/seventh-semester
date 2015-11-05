/*#include <stdio.h>

int main(void) {
    long num_rects = 100000;
    double mid, height, width, area;
    double sum = 0.0;

    width = 1.0 / (double) num_rects;
    for (long i = 0; i < num_rects; i++) {
        mid = (i + 0.5) * width;
        height = 4.0 / (1.0 + mid * mid);
        sum += height;
    }
    area = width * sum;
    printf("Computed pi = %.16f\n", area);
	getchar();
    return 0;
}*/