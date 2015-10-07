/*--------------------------------------------------------------------
 * Práctica #3: Aproximación de PI con fork y join en Java
 * Fecha: 1-Sep-2015
 * Autores:
 *          A01370815 Diego Galindez Barreda 
 *          A01165988 Eduardo Vatzuri Gaytan Martinez
 *--------------------------------------------------------------------*/
public class PiSequential {
    public static void main(String[] args) throws Exception {
        double totalRects = 1_000_000_000;
        double totalWidth = 1.0 / totalRects;
        double area, mid, height, sum = 0;

        long timeStart = System.currentTimeMillis();

        for (int i = 0; i < totalRects; i++) {
            mid = (i + 0.5) * totalWidth;
            height = 4.0 / (1.0 + mid * mid);
            sum += height;
        }

        area = totalWidth * sum;

        long timeEnd = System.currentTimeMillis();

        System.out.println("Computed pi = " + area); 
        System.out.println("Time: " + (timeEnd - timeStart) / 1000.0);
    }
}
