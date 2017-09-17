import java.util.Random;

public class Jugador extends Hole {
        
    public Jugador(float diametro, float x, float y) {
        super(diametro, x, y);
        this.colorC = color(75, 0, 130);
        this.colorInterior = color(31, 31, 31);
        
        izquierdaDerecha = 0;
        arribaAbajo = 0;
        moviendose = true;
        velocidad = 4;
    }

    public void dibujar() {
        super.dibujar();
        
        stroke(255);
        
        fill(colorC);
        ellipse(posicion.getX(), posicion.getY(), diametro, diametro);
        
        noStroke();
        fill(colorInterior);
        ellipse(posicion.getX(), posicion.getY(), diametro * 0.66, diametro * 0.66);
    }
    
    public void softMove(float x, float y) {
        if(isMuriendo()) {
            return;
        }
      
        moviendose = true;
        frameCont = 0;

        dx = (x - posicion.getX()) / 60;
        dy = (y - posicion.getY()) / 60;
    }
    
    /*public void padMove(float x, float y) {
        if(isMuriendo()) {
            return;
        }
      
        //moviendose = true;
        
        izquierdaDerecha = 0;
        if(x > posicion.getX()) {
            izquierdaDerecha = 2;
        } else if(x < posicion.getX()) {
            izquierdaDerecha = 1;
        }
        
        arribaAbajo = 0;
        if(y > posicion.getY()) {
            arribaAbajo = 2;
        } else if(y < posicion.getY()) {
            arribaAbajo = 1;
        }
    }*/
    
    public int colision(float x, float y, float tamanio, boolean enemigoMuriendo) {
        if(enemigoMuriendo) {
            return 3;
        }
        
        if(isMuriendo()) {
          return 0;
        }
      
        float m = 0.0f;

        m = (float) Math.sqrt(pow(x - posicion.getX(), 2) + pow(y - posicion.getY(), 2));

        if (radio > m && tamanio / 2 < radio) {
            return 1;
        } else if (tamanio / 2 > m && radio < tamanio / 2) {
            return 2;
        } else {
            return 0;
        }
    }
}