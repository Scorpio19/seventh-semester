import java.util.Arrays;
import java.util.Random;
import java.util.stream.*;
import java.util.function.Consumer;

public class CountingSort {

    public static int[] createRandomArray(int size, long seed) {
        int[] array = new int[size];
        Random random = new Random(seed);
        for (int i = 0; i < size; i++) {
            array[i] = random.nextInt();
        }
        return array;
    }

    public static boolean isSorted(int[] array) {
        for (int i = 0, n = array.length - 1; i < n; i++) {
            if (array[i] > array[i + 1]) {
                return false;
            }
        }
        return true;
    }

    public static double benchmarkSort(String title, int[] array, Consumer<int[]> sorter) {
        System.out.println(title);
        System.out.printf("Sorted: %b%n", isSorted(array));
        long start = System.currentTimeMillis();
        sorter.accept(array);
        long end = System.currentTimeMillis();
        double time = (end - start) / 1000.0;
        System.out.printf("Sorted: %b%n", isSorted(array));
        System.out.printf("Time: %.2f%n", time);
        return time;
    }

    public static void sequentialCountSort(int a[]) {
        final int n = a.length;
        final int[] temp = new int[n];

        for (int i = 0; i < n; i++) {
            int count = 0;
            for (int j = 0; j < n; j++) {
                if (a[j] < a[i]) {
                    count++;
                } else if (a[i] == a[j] && j < i) {
                    count++;
                }
            }
            temp[count] = a[i];
        }

        System.arraycopy(temp, 0, a, 0, n);
    }

    public static void streamCountSort(int a[]) {
        final int n = a.length;
        final int[] temp = new int[n];

        IntStream
            .range(0, n)
            .parallel()
            .forEach(i -> {
                int count = 0;
                for (int j = 0; j < n; j++) {
                    if (a[j] < a[i]) {
                        count++;
                    } else if (a[i] == a[j] && j < i) {
                        count++;
                    }
                }
                temp[count] = a[i];
            });
        System.arraycopy(temp, 0, a, 0, n);
    }

    public static void main(String[] args) {
        final int N = 100_000;
        final long SEED = 42;
        int[] array = createRandomArray(N, SEED);
        benchmarkSort("Sequential Version", array, CountingSort::sequentialCountSort);

        array = createRandomArray(N, SEED);
        benchmarkSort("Stream Version", array, CountingSort::streamCountSort);
    }
}
