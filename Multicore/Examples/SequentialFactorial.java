/*--------------------------------------------------------------------
 * Práctica 0: Factoriales en Java versión secuencial 
 * Fecha: 18-Ago-2015
 * Autores:
 *          A01166611 Pepper Pots  
 *          A01160611 Anthony Stark
 *--------------------------------------------------------------------*/

package mx.itesm.cem.pmultinucleo;

import java.math.BigInteger;

public class SequentialFactorial {

    public static void main(String[] args) throws InterruptedException {

        final int n = 250000;

        long timeStart = System.currentTimeMillis();
        BigInteger result = BigInteger.ONE;

        for (int i = 2; i <= n; i++) {
            result = result.multiply(BigInteger.valueOf(i));
        }

        long timeEnd = System.currentTimeMillis();

        System.out.printf("Resultado = %d, Tiempo = %.4f%n", result.bitCount(),
            (timeEnd - timeStart) / 1000.0);
    }
}
