/*
import java.util.concurrent.*;
import java.util.stream.*;

public class MonteCarloStreams {

    public static double body(long i) {
        double x = ThreadLocalRandom.current().nextDouble() * 2 - 1;
        double y = ThreadLocalRandom.current().nextDouble() * 2 - 1;
        
        // Aplicar teorema de Pitágoras.
        double h = x * x + y * y;

        // Verificar si el tiro cayó dentro del círculo.
        if (h <= 1) {
            return 1.0;
        }
        return 0.0;
    }

    public static void main(String... args) {
        int n = 100_000_000;
        double calc;

        long timeStart = System.nanoTime();

        calc = LongStream
            .range(0, n)
            .parallel()
            .mapToDouble(MonteCarloStreams::body)
            .sum() / n * 4;

        long timeEnd = System.nanoTime();

        System.out.println("Calculated value: " + calc);
        System.out.println("Time: " + (timeEnd - timeStart) / 1E9);
    }
}
*/
