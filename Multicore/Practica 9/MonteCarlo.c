#include <omp.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define NANOSECS_PER_SEC 1000000000

const int MAXN = 100000000;
const int NUM_THREADS = 4;

int main(void) {
    int i, sum = 0;
    long start_sequential, end_sequential, start_parallel, end_parallel;
    double calc, sequential, parallel, x, y, h;
    unsigned int seed = time(NULL);

    // Start time
    struct timespec start_sequential_time;
    clock_gettime(CLOCK_MONOTONIC, &start_sequential_time);
    start_sequential = start_sequential_time.tv_sec * NANOSECS_PER_SEC + 
        start_sequential_time.tv_nsec;

    for (i = 0; i < MAXN; i++) {
        x = (rand_r(&seed) / (double)RAND_MAX) * 2 - 1;
        y = (rand_r(&seed) / (double)RAND_MAX) * 2 - 1;

        h = x * x + y * y;

        if (h <= 1) {
            sum++;
        }
    }
    calc = 4 * ((double)sum / MAXN);

    //end time
    struct timespec end_sequential_time;
    clock_gettime(CLOCK_MONOTONIC, &end_sequential_time);
    end_sequential = end_sequential_time.tv_sec * NANOSECS_PER_SEC + 
        end_sequential_time.tv_nsec;

    sequential = (double)(end_sequential - start_sequential) / NANOSECS_PER_SEC;

    printf("Sequential pi = %.16f\n", calc);
    printf("Sequential time = %.4f sec.\n", sequential);

    sum = 0;

    struct timespec start_parallel_time;
    clock_gettime(CLOCK_MONOTONIC, &start_parallel_time);
    start_parallel = start_parallel_time.tv_sec * NANOSECS_PER_SEC + 
        start_parallel_time.tv_nsec;

#pragma omp parallel for reduction(+:sum) num_threads(NUM_THREADS) private(x, y)
    for (i = 0; i < MAXN; i++) {
        x = (rand_r(&seed) / (double)RAND_MAX) * 2 - 1;
        y = (rand_r(&seed) / (double)RAND_MAX) * 2 - 1;

        h = x * x + y * y;

        if (h <= 1) {
            sum++;
        }
    }
    calc = 4 * ((double)sum / MAXN);

    struct timespec end_parallel_time;
    clock_gettime(CLOCK_MONOTONIC, &end_parallel_time);
    end_parallel = end_parallel_time.tv_sec * NANOSECS_PER_SEC + 
        end_parallel_time.tv_nsec;

    parallel = (double)(end_parallel - start_parallel) / NANOSECS_PER_SEC;

    printf("Parallel pi = %.16f\n", calc);
    printf("Parallel time = %.4f sec.\n", parallel);
    return 0;
}
