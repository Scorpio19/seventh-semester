import java.math.BigInteger;
import java.util.concurrent.*;

public class FactorialForkJoin extends RecursiveTask<BigInteger> {

    public static final int UMBRAL = 100;
    private final int start;
    private final int end;

    public FactorialForkJoin(int start, int end) {
        this.start = start;
        this.end = end;
    }

    protected BigInteger compute() {
        if (end - start < UMBRAL) {
            BigInteger result = BigInteger.ONE;
            for (int i =  start; i <= end; i++){
                result = result.multiply(BigInteger.valueOf(i));
            }
            return result;
        } else {
            int mid = (start + end) >>> 1;
            FactorialForkJoin t1 = new FactorialForkJoin(start, mid);
            FactorialForkJoin t2 = new FactorialForkJoin(mid, end);
            t1.fork();
            BigInteger r1 = t2.compute();
            BigInteger r2 = t1.join();
            return r1.multiply(r2);
        }
    }

    public static void main(String[] args) {
        final int n = 2_000_000;

        long timeStart = System.nanoTime();

        FactorialForkJoin t = new FactorialForkJoin(2, n + 1);
        ForkJoinPool pool = new ForkJoinPool();
        BigInteger r = pool.invoke(t);

        long timeEnd = System.nanoTime();

        System.out.println("Factorial: " + r.bitCount());
        System.out.println("Time: " + (timeEnd - timeStart) / 1E9);
    }
}
