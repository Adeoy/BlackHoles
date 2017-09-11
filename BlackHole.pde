import java.util.Random;

public class BlackHole {

    private float diametro, radio, diametroFinal, masDiametro, menosDiametro;
    private Posicion posicion;
    private color colorC;
    private boolean jugador;
    private float dx, dy;
    private Random rand;
    private String[] nombres = {"Juanito", "Pedro", "Furcio",
        "Michael", "Hugo", "Karen",
        "Hector", "Ana", "Roberto",
        "Stinger", "Flippy", "Stomper",
        "Max", "Vittro", "Ankor",
        "Adeoy", "Mr.Awesome", "Mr.Pants"};
    private String nombre;

    private int arribaAbajo, izquierdaDerecha;

    private boolean moviendose, detener, muriendo, muerto, creciendo, decreciendo;
    private int frameCont, frameCrece, frameDecrece;

    public BlackHole(float diametro, float x, float y, boolean jugador) {
        this.diametro = diametro;
        this.radio = diametro / 2;
        this.posicion = new Posicion(x, y);
        this.jugador = jugador;
        this.dx = 1.0f;
        this.dy = 1.0f;
        this.rand = new Random();
        this.nombre = nombres[rand.nextInt(((nombres.length - 1) - 0) + 1) + 0] + "_" + (rand.nextInt((99 - 1) + 1) + 1);

        this.arribaAbajo = rand.nextInt((2 - 1) + 1) + 1; // Abajo
        this.izquierdaDerecha = rand.nextInt((2 - 1) + 1) + 1; // Derecha

        if (isJugador()) {
          this.nombre = "Omega";
            //this.colorC = color(0, 128, 192); // Azul
            this.colorC = color(75, 0, 130);
        } else {
            //this.colorC = color(192, 0, 0); // Rojo
            this.colorC = color(rand.nextInt(255), rand.nextInt(255), rand.nextInt(255));
        }

        this.moviendose = false;
        this.detener = false;
        this.muriendo = false;
        this.muerto = false;
        this.creciendo = false; this.decreciendo = false;
        this.frameCont = 0; this.frameCrece = 0; this.frameDecrece = 0;
        this.diametroFinal = 0.0f; this.masDiametro = 0.0f; this.menosDiametro = 0.0f;
    }

    public void dibujar() {
        if(isMuriendo()) {
            animarMuerte();
        }
      
        if (isMoviendose()) {
            animarMovimiento();
        }
        
        if(isCreciendo()) {
            animarCrecimiento();
        }
        
        if(isDecreciendo()) {
            animarDecrecimiento();
        }
        
        if (isJugador()) {
            //fill(color(255, 255, 255, 128));
            //ellipse(posicion.getX(), posicion.getY(), diametro * 1.1, diametro * 1.1);
            stroke(255);
        } else {
            noStroke();
        }
        
        fill(colorC);
        ellipse(posicion.getX(), posicion.getY(), diametro, diametro);
        
        noStroke();
        fill(color(31, 31, 31));
        ellipse(posicion.getX(), posicion.getY(), diametro * 0.66, diametro * 0.66);
        
        textSize(12);
        fill(255);
        //text(nombre, posicion.getX() - (diametro / 4), posicion.getY());
        //text(diametro, posicion.getX() - (diametro / 4), posicion.getY() + 10);
    }

    public void validarMovimiento(float x, float y) {
        if (y >= 0 && y < height && x < width && x >= 0) {
            posicion = new Posicion(x, y);
        } else if (x >= width) {
            posicion.setX(width);
        } else if (x <= 0) {
            posicion.setX(0);
        } else if (y >= height) {
            posicion.setY(height);
        } else if (y <= 0) {
            posicion.setY(0);
        }

        if (x <= 0 || x > width) {
            if (y >= 0 && y < height) {
                posicion.setY(y);
            } else if (y >= height) {
                posicion.setY(height);
            } else if (y <= 0) {
                posicion.setY(0);
            }
        }

        if (y <= 0 || y > height) {
            if (x < width && x >= 0) {
                posicion.setX(x);
            } else if (x >= width) {
                posicion.setX(width);
            } else if (x <= 0) {
                posicion.setX(0);
            }
        }
    }

    public int colision(float x, float y, float tamanio, boolean enemigoMuriendo) {
        if(enemigoMuriendo) {
            return 3;
        }
        
        if(isJugador() && isMuriendo()) {
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
    
    public int colision(float x, float y, float tamanio) {
        float m = 0.0f;

        m = (float) Math.sqrt(pow(x - posicion.getX(), 2) + pow(y - posicion.getY(), 2));

        if (diametro > m && tamanio < diametro) {
            return 1;
        } else if (tamanio > m && diametro < tamanio) {
            return 2;
        } else {
            return 0;
        }
    }

    public void mover() {
        if (isDetener()) {
            return;
        }

        int x = 0, y = 0;

        if (izquierdaDerecha == 2) {
            x = rand.nextInt((2 - 0) + 1) + 0;
        } else if (izquierdaDerecha == 1) {
            x = rand.nextInt((0 - (-2)) + 1) + (-2);
        }

        if (arribaAbajo == 2) {
            y = rand.nextInt((2 - 0) + 1) + 0;
        } else if (arribaAbajo == 1) {
            y = rand.nextInt((0 - (-2)) + 1) + (-2);
        }

        if (posicion.getY() + y >= 0 && posicion.getY() + y < height && posicion.getX() + x < width && posicion.getX() + x >= 0) {
            posicion.plusX(x);
            posicion.plusY(y);
        }
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
    
    public void animarMovimiento() {
        validarMovimiento(posicion.getX() + dx, posicion.getY() + dy);

        frameCont++;
        if (frameCont >= 60) {
            moviendose = false;
        }
    }
    
    public void animarMuerte() {
        setDiametro(diametro - diametroFinal / 60);
        frameCont++;
        if(frameCont >= 60) {
            muerto = true;
        }
    }
    
    public void animarCrecimiento() {
        setDiametro(diametro + masDiametro / 60);
        frameCrece++;
        if(frameCrece >= 60) {
            creciendo = false;
        }
    }
    
    public void animarDecrecimiento() {
        setDiametro(diametro - menosDiametro / 60);
        frameDecrece++;
        if(frameDecrece >= 60) {
            decreciendo = false;
        }
    }

    public void setDiametro(float diametro) {
        this.diametro = diametro;
        this.radio = diametro / 2;
    }

    public void setPosicion(float x, float y) {
        this.posicion = new Posicion(x, y);
    }

    public void setJugador(boolean jugador) {
        this.jugador = jugador;
    }

    public void setArribaAbajo(int arribaAbajo) {
        this.arribaAbajo = arribaAbajo;
    }

    public void setIzquierdaDerecha(int izquierdaDerecha) {
        this.izquierdaDerecha = izquierdaDerecha;
    }

    public void setMoviendose(boolean moviendose) {
        this.moviendose = moviendose;
    }

    public void setDetener(boolean detener) {
        this.detener = detener;
    }
    
    public void setMuriendo(boolean muriendo) {
        this.frameCont = 0;
        this.moviendose = false;
        this.detener = true;
        this.diametroFinal = diametro;
        this.muriendo = muriendo;
    }
    
    public void setMuerto(boolean muerto) {
        this.muerto = muerto;
    }
    
    public void setCreciendo(float masDiametro) {
        this.frameCrece = 0;
        this.masDiametro = masDiametro;
        this.creciendo = true;
    }
    
    public void setDecreciendo(float menosDiametro) {
        this.frameDecrece = 0;
        this.menosDiametro = menosDiametro;
        this.decreciendo = true;
    }

    public float getDiametro() {
        return diametro;
    }

    public Posicion getPosicion() {
        return posicion;
    }

    public boolean isJugador() {
        return jugador;
    }

    public int getArribaAbajo() {
        return arribaAbajo;
    }

    public int getIzquierdaDerecha() {
        return izquierdaDerecha;
    }

    public boolean isMoviendose() {
        return moviendose;
    }

    public boolean isDetener() {
        return detener;
    }
    
    public boolean isMuriendo() {
        return muriendo;
    }
    
    public boolean isMuerto() {
        return muerto;
    }
    
    public boolean isCreciendo() {
        return creciendo;
    }
    
    public boolean isDecreciendo() {
        return decreciendo;
    }
}