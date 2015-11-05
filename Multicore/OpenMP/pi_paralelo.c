/*
#include <stdio.h>
#include <time.h>

#define NANOSECS_PER_SEC 1000000000

int main(void) {
    long num_rects = 1000000000;
    double width, area;
    double sum = 0.0;
    
    struct timespec start;
    clock_gettime(CLOCK_MONOTONIC, &start);
    long start_time = start.tv_sec * NANOSECS_PER_SEC + start.tv_nsec;

    width = 1.0 / (double) num_rects;
    long i;
    #pragma omp parallel for reduction(+:sum) num_threads(1)
    for (i = 0; i < num_rects; i++) {
        double mid = (i + 0.5) * width;
        double height = 4.0 / (1.0 + mid * mid);
        sum += height;
    }
    area = width * sum;
    
    struct timespec end;
    clock_gettime(CLOCK_MONOTONIC, &end);
    long end_time = end.tv_sec * NANOSECS_PER_SEC + end.tv_nsec;
    double sec = (double) (end_time - start_time) / NANOSECS_PER_SEC;
    
    printf("Computed pi = %.16f\n", area);
    printf("Time = %.4f sec.\n", sec);
    return 0;
}
//*/