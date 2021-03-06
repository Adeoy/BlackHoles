public class BlackHole extends Hole {

    public BlackHole(float diametro, float x, float y) {
        super(diametro, x, y);
        this.colorC = color(utils.getRandom(0, 255), utils.getRandom(0, 255), utils.getRandom(0, 255));
        this.colorInterior = color(31, 31, 31);
    }

    public void dibujar() {
        super.dibujar();
        
        noStroke();
        
        fill(colorC);
        ellipse(posicion.x, posicion.y, diametro, diametro);
        
        noStroke();
        fill(colorInterior);
        ellipse(posicion.x, posicion.y, diametro * 0.66, diametro * 0.66);
    }
}