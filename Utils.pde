import java.util.Random;

public class Utils {
    private Random rand;
    
    public Utils() {
        rand = new Random();
    }
    
    public int getRandom(int min, int max) {
        return rand.nextInt(max - min + 1) + min;
    }

    public boolean getPosibilidad(int porcentaje) {
        return porcentaje >= getRandom(1, 100);
    }
}