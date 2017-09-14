import java.util.Random;

public class WhiteHole extends Hole {

    public WhiteHole(float diametro, float x, float y) {
        super(diametro, x, y);
        this.colorC = color(utils.getRandom(0, 255), utils.getRandom(0, 255), utils.getRandom(0, 255));
        this.colorInterior = color(223, 223, 223);
    }

    public void dibujar() {
        super.dibujar();
        
        noStroke();
        
        fill(colorC);
        ellipse(posicion.getX(), posicion.getY(), diametro, diametro);
        
        fill(colorInterior);
        ellipse(posicion.getX(), posicion.getY(), diametro * 0.66, diametro * 0.66);
    }
}