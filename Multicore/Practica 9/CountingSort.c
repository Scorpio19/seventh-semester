#include <omp.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

#define NANOSECS_PER_SEC 1000000000

const int MAXN = 100000;
const int NUM_THREADS = 4;

int isSorted(int* array) {
    int i = 0;
    for (i = 0; i < MAXN - 1; i++) {
        if (array[i] > array[i + 1]) {
            return 0;
        }
    }
    return 1;
}

void arrayIsSorted(int* array) {
    printf("Array is sorted: ");
    if (isSorted(array)) {
        printf("Yes");
    } else {
        printf("No");
    }
    printf("\n");
}

void sequentialCountSort(int* a) {
    int* temp = malloc(sizeof(int)* MAXN); 
    int i, j;

    for (i = 0; i < MAXN; i++) {
        int count = 0;
        for (j = 0; j < MAXN; j++) {
            if (a[j] < a[i]) {
                count++;
            } else if (a[i] == a[j] && j < i) {
                count++;
            }
        }
        temp[count] = a[i];
    }
    memcpy(a, temp, sizeof(int) * MAXN);
}

void parallelCountSort(int* a) {
   int* temp = malloc(sizeof(int) * MAXN);
   int i;

#pragma omp parallel for num_threads(NUM_THREADS)
   for (i = 0; i < MAXN; i++) {
       int count = 0;
       int j = 0;
       for (j = 0; j < MAXN; j++) {
           if (a[j] < a[i]) {
               count++;
           } else if (a[i] == a[j] && j < i) {
               count++;
           }
       }
       temp[count] = a[i];
   }
   memcpy(a, temp, sizeof(int) * MAXN);
}

int main(void) {
    int i, sorted;
    int *arrayS = malloc(sizeof(int) * MAXN);
    int *arrayP = malloc(sizeof(int) * MAXN);

    unsigned int seed = time(NULL);

    long start_sequential, end_sequential, start_parallel, end_parallel;

    double calc, sequential, parallel;

    for (i = 0; i < MAXN; i++) {
        arrayS[i] = rand_r(&seed);
        arrayP[i] = rand_r(&seed);
    }

    arrayIsSorted(arrayS);

    struct timespec start_sequential_time;
    clock_gettime(CLOCK_MONOTONIC, &start_sequential_time);
    start_sequential = start_sequential_time.tv_sec * NANOSECS_PER_SEC + 
        start_sequential_time.tv_nsec;

    sequentialCountSort(arrayS);

    struct timespec end_sequential_time;
    clock_gettime(CLOCK_MONOTONIC, &end_sequential_time);
    end_sequential = end_sequential_time.tv_sec * NANOSECS_PER_SEC + 
        end_sequential_time.tv_nsec;

    sequential = (double)(end_sequential - start_sequential) / NANOSECS_PER_SEC;

    arrayIsSorted(arrayS);
    printf("Sequential time = %.4f sec.\n", sequential);

    arrayIsSorted(arrayP);
    struct timespec start_parallel_time;
    clock_gettime(CLOCK_MONOTONIC, &start_parallel_time);
    start_parallel = start_parallel_time.tv_sec * NANOSECS_PER_SEC + 
        start_parallel_time.tv_nsec;

    parallelCountSort(arrayP);

    struct timespec end_parallel_time;
    clock_gettime(CLOCK_MONOTONIC, &end_parallel_time);
    end_parallel = end_parallel_time.tv_sec * NANOSECS_PER_SEC + 
        end_parallel_time.tv_nsec;

    parallel = (double)(end_parallel - start_parallel) / NANOSECS_PER_SEC;

    arrayIsSorted(arrayP);
    printf("Parallel time = %.4f sec.\n", parallel);

    return 0;
}
