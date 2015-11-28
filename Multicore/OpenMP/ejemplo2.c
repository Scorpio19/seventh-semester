/*
#include <stdio.h>
#include <omp.h>

int main(void) {
    #pragma omp parallel num_threads(8)
    {
        int num_threads = omp_get_num_threads();
        int thread_num  = omp_get_thread_num();
        printf("Hola desde thread ID = %d de un total de %d threads\n",
            thread_num, num_threads);
    }
    return 0;
}
*/