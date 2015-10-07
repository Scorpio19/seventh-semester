/*--------------------------------------------------------------------
 * Práctica #3: Aproximación de PI con fork y join en Java
 * Fecha: 1-Sep-2015
 * Autores:
 *          A01370815 Diego Galindez Barreda 
 *          A01165988 Eduardo Vatzuri Gaytan Martinez
 *--------------------------------------------------------------------*/

import java.util.concurrent.*;

public class ForkPi extends RecursiveTask<Double> {

    public static final int LIMIT = 1_000_000;
    public static final double RECTS = 1_000_000_000;
    public static final double WIDTH = 1.0 / RECTS;

    private double start, end;

    public ForkPi(double start, double end) {
        this.start = start;
        this.end = end; 
    }

    public Double compute() {
        if (end - start < LIMIT) {
            double sum, mid, height;
            sum = 0;
            for (; start < end; start++) {
                mid = (start + 0.5) * WIDTH;
                height = 4.0 / (1.0 + mid * mid);
                sum += height;
            }
            return sum;
        } else {
            double mid = (start + end) / 2;
            ForkPi t1 = new ForkPi(start, mid);
            ForkPi t2 = new ForkPi(mid, end);
            t1.fork();
            double r1 = t2.compute();
            double r2 = t1.join();
            return (r1 + r2);
        }
    }

    public static void main(String[] args) throws Exception {
        double area;

        long timeStart = System.nanoTime();

        ForkPi t = new ForkPi(0, RECTS);
        ForkJoinPool pool = new ForkJoinPool();
        double sum = pool.invoke(t);

        area = WIDTH * sum;

        long timeEnd = System.nanoTime();

        System.out.println("Computed pi = " + area); 
        System.out.println("Time: " + (timeEnd - timeStart) / 1E9);
    }
}
