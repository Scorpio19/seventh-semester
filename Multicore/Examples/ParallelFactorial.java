/*--------------------------------------------------------------------
 * Práctica 0: Factoriales en Java versión paralela con threads
 * Fecha: 18-Ago-2015
 * Autores:
 *          A01166611 Pepper Pots  
 *          A01160611 Anthony Stark
 *--------------------------------------------------------------------*/

package mx.itesm.cem.pmultinucleo;

import java.math.BigInteger;

public class ParallelFactorial implements Runnable {

    private int start, end;
    private BigInteger result = BigInteger.ONE;

    public ParallelFactorial(int start, int end) {
        this.start = start;
        this.end = end;
    }

    @Override
    public void run() {
        for (int i = start; i <= end; i++) {
            result = result.multiply(BigInteger.valueOf(i));
        }
    }

    public static void main(String[] args) throws InterruptedException {
        final int n = 250000;
        
        long timeStart = System.currentTimeMillis();
        
        ParallelFactorial p1 = new ParallelFactorial(2, n / 2);
        ParallelFactorial p2 = new ParallelFactorial(n / 2 + 1, n);
        Thread t1 = new Thread(p1);
        Thread t2 = new Thread(p2);     
        t1.start();
        t2.start();
        t1.join();
        t2.join();      
        BigInteger total = p1.result.multiply(p2.result);
        
        long timeEnd = System.currentTimeMillis();
        
        System.out.printf("Resultado = %d, Tiempo = %.4f%n", total.bitCount(),
            (timeEnd - timeStart) / 1000.0);        
    }
}
