#include <stdio.h>
#include <stdlib.h>
#include <time.h>
//#include "timer.h"

#define NANOSECS_PER_SEC 1000000000

int main(void) {
	int sum = 0;
	int n = 100000000;
	double calc, x, y, h;
	unsigned int seed = time(NULL);

	// Start time
	for (int i = 0; i < n; i++) {
		// Generar dos números aleatorios entre -1 y 1.
		x = (rand_r(seed) % 1) * 2 - 1;
		y = (rand_r(seed) % 1) * 2 - 1;

		// Aplicar teorema de Pitágoras.
		h = x * x + y * y;

		// Verificar si el tiro cayó dentro del círculo.
		if (h <= 1) {
			sum++;
		}
	}

	calc = 4 * ((double)sum / n);
	/*
    long i;
    #pragma omp parallel for reduction(+:sum) num_threads(1)
    for (i = 0; i < num_rects; i++) {
        double mid = (i + 0.5) * width;
        double height = 4.0 / (1.0 + mid * mid);
        sum += height;
    }
    area = width * sum;
	*/

	//end time
    //double sec = (double) (end_time - start_time) / NANOSECS_PER_SEC;
    
    printf("Computed pi = %.16f\n", calc);
    //printf("Time = %.4f sec.\n", sec);
    return 0;
}