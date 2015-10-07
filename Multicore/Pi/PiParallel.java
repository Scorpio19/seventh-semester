/*--------------------------------------------------------------------
 * Práctica #1: Aproximación de PI con threads de Java
 * Fecha: 19-Ago-2015
 * Autores:
 *          A01370815 Diego Galindez Barreda 
 *          A01165988 Eduardo Yatziri Gaytan Martinez
 *--------------------------------------------------------------------*/
public class PiParallel implements Runnable {
    public double sum;
    private int id;
    private double mid, height, rects, width;

    public PiParallel(int id, int cores, double rects, double width) {
        this.id = id;
        this.rects = rects;
        this.width = width;
        this.rects /= cores;
        this.sum = 0.0;
    }

    public void run() {
        double start = this.rects * (this.id - 1);
        double end = this.rects * this.id;
        for (; start < end; start++) {
            this.mid = (start + 0.5) * this.width;
            this.height = 4.0 / (1.0 + this.mid * this.mid);
            this.sum += this.height;
        }
    }

    public static void main(String[] args) throws Exception {
        double totalRects = 100000.0;
        double totalWidth = 1.0 / totalRects;
        double totalSum = 0.0;
        double area;
        int cores = 4;

        long timeStart = System.currentTimeMillis();

        PiParallel[] sums = new PiParallel[cores];
        Thread[] threads = new Thread[cores];

        for (int i = 0; i < cores; i++) {
            sums[i] = new PiParallel(i+1, cores, totalRects, totalWidth);
            threads[i] = new Thread(sums[i]);
        }

        for (int i = 0; i < cores; i++) {
            threads[i].start();
        }

        for (int i = 0; i < cores; i++) {
            threads[i].join();
            totalSum += sums[i].sum;
        }

        area = totalWidth * totalSum;

        long timeEnd = System.currentTimeMillis();

        System.out.println("Computed pi = " + area); 
        System.out.println("Time: " + (timeEnd - timeStart) / 1000.0);
    }
}
