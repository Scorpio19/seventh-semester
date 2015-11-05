/*
import java.util.concurrent.*;

public class MonteCarloSequential {

    public static void main(String... args) {
        int sum = 0;
        int n = 100_000_000;
        double calc, x, y, h;

        long timeStart = System.nanoTime();

        for (int i = 0; i < n; i++) {
            // Generar dos números aleatorios entre -1 y 1.
            x = ThreadLocalRandom.current().nextDouble() * 2 - 1;
            y = ThreadLocalRandom.current().nextDouble() * 2 - 1;

            // Aplicar teorema de Pitágoras.
            h = x * x + y * y;

            // Verificar si el tiro cayó dentro del círculo.
            if (h <= 1) {
                sum++;
            }
        }

        calc = 4 * ((double) sum / n);
        long timeEnd = System.nanoTime();

        System.out.println("Calculated value: " + calc);
        System.out.println("Time: " + (timeEnd - timeStart) / 1E9);
    }
}
*/