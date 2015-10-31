/*
 * Authors:
 *  A01370815 Diego Galindez Barreda
 *  A01165988 Eduardo Azuri Gaytan Martinez 
 */
import java.util.ArrayList;
import java.util.Arrays;

public class Inverse {
    public static int MAXN = 1000;

    // Sequential code
    public static double[][] invert(double matrix[][]) {
        for (int i = 0; i < MAXN; i++) {
            matrix[i][MAXN + i] = 1;
        }

        gaussJordan(matrix, 0);

        return matrix;
    }

    public static double[][] gaussJordan(double matrix[][], int i) {
        if (i == matrix.length) {
            return matrix;
        }

        double[] irow = new double[MAXN * 2];
        irow = Arrays.copyOf(matrix[0], MAXN * 2);
        double val = irow[i];
        for (int j = 0; j < MAXN * 2; j++) {
            irow[j] /= val;
        }

        for (int j = 1; j < MAXN; j++) {
            double[] jrow = matrix[j];
            double scale = matrix[j][i];
            for (int k = 0; k < MAXN * 2; k++) {
                jrow[k] -= (irow[k] * scale);
            }
        }
        for (int j = 0; j < MAXN - 1; j++) {
            matrix[j] = matrix[j + 1];
        }
        matrix[MAXN - 1] = new double[MAXN * 2];
        matrix[MAXN - 1] = Arrays.copyOf(irow, MAXN * 2);

        return gaussJordan(matrix, i + 1);
    }

    // Parallel code
    public static double[][] parallelInvert(double matrix[][]) {
        for (int i = 0; i < MAXN; i++) {
            matrix[i][MAXN + i] = 1;
        }

        parallelGaussJordan(matrix, 0);

        return matrix;
    }

    public static double[][] parallelGaussJordan(double matrix[][], int i) {
        if (i == matrix.length) {
            return matrix;
        }

        double[] irow = new double[MAXN * 2];
        irow = Arrays.copyOf(matrix[0], MAXN * 2);
        double val = irow[i];
        for (int j = 0; j < MAXN * 2; j++) {
            irow[j] /= val;
        }

        for (int j = 1; j < MAXN; j++) {
            double[] jrow = matrix[j];
            double scale = matrix[j][i];
            for (int k = 0; k < MAXN * 2; k++) {
                jrow[k] -= (irow[k] * scale);
            }
        }
        for (int j = 0; j < MAXN - 1; j++) {
            matrix[j] = matrix[j + 1];
        }
        matrix[MAXN - 1] = new double[MAXN * 2];
        matrix[MAXN - 1] = Arrays.copyOf(irow, MAXN * 2);

        return parallelGaussJordan(matrix, i + 1);
    }

    public static void printMatrix(double[][] matrix) {
        for (int i = 0; i < matrix.length; i++) {
            for (int j = MAXN; j < matrix[0].length; j++) {
                System.out.print(matrix[i][j] + ", ");
            }
            System.out.println();
        }
        System.out.println();
    }

    public static void benchmark(String title, double[][] matrix, boolean sequential) {
        double[][] inverse;

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

        //printMatrix(matrix);
        System.out.printf("Time: %.2f%n", time);
    }

    public static void main(String... args) {
        //*
           double randomNum;
           double[][] matrix = new double[MAXN][MAXN * 2];
           for (int i = 0; i < MAXN; i++) {
               for (int j = 0; j < MAXN; j++) {
                   randomNum = 1.0 + (Math.random() * MAXN);
                   matrix[i][j] = randomNum;
               }
           }
           //*/
           /*
        double[][] matrix = {
            {1, 1, 2, 1, 0, 0, 0, 0},
            {1, 2, 1, 2, 0, 0, 0, 0},
            {1, 1, 1, 3, 0, 0, 0, 0},
            {2, 3, 1, 3, 0, 0, 0, 0}
        };
           */

        benchmark("Sequential", Arrays.copyOf(matrix, MAXN), true);
        benchmark("Concurrent", matrix, false);
    }
}
