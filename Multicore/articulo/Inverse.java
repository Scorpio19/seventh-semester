/*
 * Authors:
 *  A01370815 Diego Galindez Barreda
 *  A01165988 Eduardo Azuri Gaytan Martinez 
 */
import java.util.Arrays;
import java.util.stream.*;

public class Inverse {
    public static int MAXN = 4;//1000;

    // Sequential code
    public static double[][] invert(double matrix[][]) {
        for (int i = 0; i < MAXN; i++) {
            matrix[i][MAXN + i] = 1;
        }

        return gaussJordan(matrix);
    }

    public static double[][] gaussJordan(double matrix[][]) {
        int i, j, k;
        double val, scale;
        double[] irow, jrow;

        for (i = 0; i < MAXN; i++) {
            irow = Arrays.copyOf(matrix[0], MAXN * 2);
            val = irow[i];
            for (j = 0; j < MAXN * 2; j++) {
                irow[j] /= val;
            }

            for (j = 1; j < MAXN; j++) {
                jrow = matrix[j];
                scale = matrix[j][i];
                for (k = 0; k < MAXN * 2; k++) {
                    jrow[k] -= (irow[k] * scale);
                }
            }
            for (j = 0; j < MAXN - 1; j++) {
                matrix[j] = matrix[j + 1];
            }
            matrix[MAXN - 1] = Arrays.copyOf(irow, MAXN * 2);
        }
        return matrix;
    }

    // Parallel code
    public static double[][] parallelInvert(double matrix[][]) {
        IntStream
            .range(0, MAXN)
            .parallel()
            .forEach(i -> {
                matrix[i][MAXN + i] = 1;
            });

        parallelGaussJordan(matrix);

        return matrix;
    }

    public static double[][] parallelGaussJordan(double matrix[][]) {
        double val, scale;
        double[] irow, jrow;

        IntStream.range(0, MAXN).forEach(i ->
            irow = Arrays.copyOf(matrix[0], MAXN * 2);
            val = irow[i];

            IntStream.range(0, MAXN * 2).forEach(j ->
                irow[j] /= val;
            );

            IntStream.range(1, MAXN).forEach(j -> {
                jrow = matrix[j];
                scale = matrix[j][i];
                for (int k = 0; k < MAXN * 2; k++) {
                    jrow[k] -= (irow[k] * scale);
                }
            });

            for (int j = 0; j < MAXN - 1; j++) {
                matrix[j] = matrix[j + 1];
            }

            matrix[MAXN - 1] = Arrays.copyOf(irow, MAXN * 2);
        });
        return matrix;
    }

    public static void printMatrix(double[][] matrix) {
        for (int i = 0; i < MAXN; i++) {
            for (int j = MAXN; j < MAXN * 2; j++) {
                System.out.print(matrix[i][j] + ", ");
            }
            System.out.println();
        }
        System.out.println();
    }

    public static void benchmark(String title, double[][] matrix, boolean sequential) {
        System.out.println(title);
        //printMatrix(matrix);

        long start = System.currentTimeMillis();
        if (sequential) {
            invert(matrix);
        } else {
            parallelInvert(matrix);
        }
        long end = System.currentTimeMillis();
        double time = (end - start) / 1000.0;

        printMatrix(matrix);
        System.out.printf("Time: %.2f%n", time);
    }

    public static void main(String... args) {
        /*
        double randomNum;
        double[][] sequential = new double[MAXN][MAXN * 2];
        double[][] parallel = new double[MAXN][MAXN * 2];
        for (int i = 0; i < MAXN; i++) {
            for (int j = 0; j < MAXN; j++) {
                randomNum = 1.0 + (Math.random() * MAXN);
                sequential[i][j] = randomNum;
                parallel[i][j] = randomNum;
            }
        }
        //*/
        //*
        double[][] sequential = {
            {1, 1, 2, 1, 0, 0, 0, 0},
            {1, 2, 1, 2, 0, 0, 0, 0},
            {1, 1, 1, 3, 0, 0, 0, 0},
            {2, 3, 1, 3, 0, 0, 0, 0}
        };

        double[][] parallel = {
            {1, 1, 2, 1, 0, 0, 0, 0},
            {1, 2, 1, 2, 0, 0, 0, 0},
            {1, 1, 1, 3, 0, 0, 0, 0},
            {2, 3, 1, 3, 0, 0, 0, 0}
        };
        //*/

        benchmark("Sequential", sequential, true);
        benchmark("Concurrent", parallel, false);
    }
}
