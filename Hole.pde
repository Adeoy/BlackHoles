import java.util.Random;

public class Hole {

    protected float diametro, radio, diametroFinal, masDiametro, menosDiametro;
    protected Posicion posicion;
    protected int velocidad;
    protected color colorC, colorInterior;
    protected float dx, dy;
    protected Utils utils;

    protected int arribaAbajo, izquierdaDerecha;

    protected boolean moviendose, detener, muriendo, muerto, creciendo, decreciendo;
    protected int frameCont, frameCrece, frameDecrece;

    public Hole(float diametro, float x, float y) {
        this.diametro = diametro;
        this.radio = diametro / 2;
        this.posicion = new Posicion(x, y);
        this.dx = 1.0f;
        this.dy = 1.0f;
        this.utils = new Utils();

        this.arribaAbajo = utils.getRandom(0, 2);
        this.izquierdaDerecha = utils.getRandom(0, 2);
        
        this.moviendose = false;
        this.detener = false;
        this.muriendo = false;
        this.muerto = false;
        this.creciendo = false; this.decreciendo = false;
        this.frameCont = 0; this.frameCrece = 0; this.frameDecrece = 0;
        this.diametroFinal = 0.0f; this.masDiametro = 0.0f; this.menosDiametro = 0.0f;
    }

    public void dibujar() {
        if (isMuriendo()) {
            animarMuerte();
        }
      
        if (isMoviendose()) {
            animarMovimiento();
        }
        
        if (isCreciendo()) {
            animarCrecimiento();
        }
        
        if (isDecreciendo()) {
            animarDecrecimiento();
        }
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

        if (x <= 0 || x >= width) {
            if (y >= 0 && y < height) {
                posicion.setY(y);
            } else if (y >= height) {
                posicion.setY(height);
            } else if (y <= 0) {
                posicion.setY(0);
            }
        }

        if (y <= 0 || y >= height) {
            if (x < width && x >= 0) {
                posicion.setX(x);
            } else if (x >= width) {
                posicion.setX(width);
            } else if (x <= 0) {
                posicion.setX(0);
            }
        }
    }
    
    public void mover() {
        if (isDetener()) {
            return;
        }

        int x = 0, y = 0;

        if (izquierdaDerecha == 2) {
            x = 1;
        } else if (izquierdaDerecha == 1) {
            x = -1;
        }

        if (arribaAbajo == 2) {
            y = 1;
        } else if (arribaAbajo == 1) {
            y = -1;
        }

        if (posicion.getY() + y >= 0 && posicion.getY() + y < height && posicion.getX() + x < width && posicion.getX() + x >= 0) {
            posicion.plusX(x);
            posicion.plusY(y);
        }
    }
    
    public int colision(float x, float y, float tamanio, boolean enemigoMuriendo) {
        if(enemigoMuriendo) {
            return 3;
        }
      
        float m = 0.0f;
        float tempX = x - posicion.getX();
        float tempY = y - posicion.getY();
        float tempR = radio + (tamanio / 2);
        
        m = (tempX * tempX) + (tempY * tempY);

        if ((radio * radio) > m && tamanio / 2 < radio) {
            return 1;
        } else if (((tamanio / 2) * (tamanio / 2)) > m && radio < tamanio / 2) {
            return 2;
        } else {
            return 0;
        }
    }
    
    public boolean posicionOcupada(float x, float y, float tamanio) {
        float m = 0.0f;

        float tempX = x - posicion.getX();
        float tempY = y - posicion.getY();
        float tempR = radio + (tamanio / 2);
        
        m = (tempX * tempX) + (tempY * tempY);        

        return tempR * tempR > m;
    }
    
    /*public void animarMovimiento() {
        validarMovimiento(posicion.getX() + dx, posicion.getY() + dy);

        frameCont++;
        if (frameCont >= 60) {
            moviendose = false;
        }
    }*/
    
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
        
        validarMovimiento(posicion.getX() + x, posicion.getY() + y);
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
    
    public void setVelocidad(int velocidad) {
        this.velocidad = velocidad;
    }

    public float getDiametro() {
        return diametro;
    }

    public Posicion getPosicion() {
        return posicion;
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
    
    public int getVelocidad() {
        return velocidad;
    }
}