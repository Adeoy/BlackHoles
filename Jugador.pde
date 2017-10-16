import java.util.Random;

public class Jugador extends Hole {
  
    private float velocidad;
    private float distancia;
    private PVector direccion;
    private PVector inicio, target;
    private float frak;
        
    public Jugador(float diametro, float x, float y) {
        super(diametro, x, y);
        this.colorC = color(75, 0, 130);
        this.colorInterior = color(31, 31, 31);
        
        izquierdaDerecha = 0;
        arribaAbajo = 0;
        moviendose = false;
        velocidad = 4.0f * 10;
        
        distancia = 0.0f;
        direccion = new PVector(0, 0);
        inicio = new PVector(0, 0); target = new PVector(0, 0); 
        frak = 0.0f;
    }

    public void dibujar() {
        super.dibujar();
        
        if (isMoviendose()) {
            animarMovimiento();
        }
        
        stroke(255);
        
        fill(colorC);
        ellipse(posicion.x, posicion.y, diametro, diametro);
        
        noStroke();
        fill(colorInterior);
        ellipse(posicion.x, posicion.y, diametro * 0.66, diametro * 0.66);
    }
    
    /* Mouse */
    /*public void animarMovimiento() {
        validarMovimiento(posicion.x + dx, posicion.y + dy);

        frameCont++;
        if (frameCont >= 60) {
            moviendose = false;
        }
    }*/
    
    public void animarMovimiento() {
        float movX = direccion.x * velocidad * 0.1666f; //<>//
        float movY = direccion.y * velocidad * 0.1666f; //<>//
      
        validarMovimiento(posicion.x + movX, posicion.y + movY);
        
        if(PVector.dist(inicio, posicion) >= distancia) {
            validarMovimiento(target.x, target.y);
            moviendose = false;
        }
    }
    
    /* Teclado
    public void animarMovimiento() {
        int x = 0, y = 0;
        
        if (izquierdaDerecha == 2) {
            x = velocidad;
        } else if (izquierdaDerecha == 1) {
            x = -velocidad;
        }

        if (arribaAbajo == 2) {
            y = velocidad;
        } else if (arribaAbajo == 1) {
            y = -velocidad;
        }
        
        validarMovimiento(posicion.x + x, posicion.y + y);
    }*/
    
    /*public void softMove(float x, float y) {
        if(isMuriendo()) {
            return;
        }
      
        moviendose = true;
        frameCont = 0;

        dx = (x - posicion.x) / 60;
        dy = (y - posicion.y) / 60;
    }*/
    
    public void softMove(float x, float y) {
        if(isMuriendo()) {
            return;
        }
      
        moviendose = true;
        
        inicio = new PVector(posicion.x, posicion.y);
        target = new PVector(x, y);
        
        PVector resta = new PVector(x, y);
        
        distancia = PVector.dist(posicion, target);
        direccion = resta.sub(posicion).normalize();
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

        m = PVector.dist(posicion, new PVector(x, y));

        if (radio > m && tamanio / 2 < radio) {
            return 1;
        } else if (tamanio / 2 > m && radio < tamanio / 2) {
            return 2;
        } else {
            return 0;
        }
    }
    
    public void setVelocidad(float velocidad) {
        this.velocidad = velocidad;
    }
    
    public float getVelocidad() {
        return velocidad;
    }
}