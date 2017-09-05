public class BlackHole {
  private float diametro, radio;
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
  
  private boolean moviendose, detener;
  private int frameCont;
  
  public BlackHole(float diametro, float x, float y, boolean jugador) {
    this.diametro = diametro;
    this.radio = diametro / 2;
    this.posicion = new Posicion(x, y);
    this.jugador = jugador;
    this.dx = 1.0; this.dy = 1.0;
    this.rand = new Random();
    this.nombre = nombres[rand.nextInt(((nombres.length - 1) - 0) + 1) + 0] + "_" + (rand.nextInt((99 - 1) + 1) + 1);
    
    this.arribaAbajo = rand.nextInt((2 - 1) + 1) + 1; // Abajo
    this.izquierdaDerecha = rand.nextInt((2 - 1) + 1) + 1; // Derecha
    
    if(isJugador()) {
      this.colorC = color(0, 128, 192); // Azul
    } else {
      this.colorC = color(192, 0, 0); // Rojo
    }
    
    this.moviendose = false; this.detener = false;
    this.frameCont = 0;
  }
  
  public void dibujar() {
    if(isMoviendose()) {
      validarMovimiento(posicion.getX() + dx, posicion.getY() + dy);
      
      frameCont++;
      if(frameCont >= 60) {
        moviendose = false;
      }
    }
    
    fill(colorC);
    ellipse(posicion.getX(), posicion.getY(), diametro, diametro);
    
    textSize(12);
    fill(255);
    text(nombre, posicion.getX() - (diametro / 4), posicion.getY());
  }
  
  public void validarMovimiento(float x, float y) {
    if(y >= 0 && y < height && x < width && x >= 0) {
      posicion = new Posicion(x, y);
    } else if(x >= width) {
      posicion.setX(width);
    } else if(x <= 0) {
      posicion.setX(0);
    } else if(y >= height) {
      posicion.setY(height); 
    } else if(y <= 0) {
      posicion.setY(0);
    }
    
    if(x <= 0 || x > width) {
      if(y >= 0 && y < height) {
        posicion.setY(y);
      } else if(y >= height) {
        posicion.setY(height); 
      } else if(y <= 0) {
        posicion.setY(0);
      }
    }
    
    if(y <= 0 || y > height) {
      if(x < width && x >= 0) {
        posicion.setX(x);
      } else if(x >= width) {
        posicion.setX(width);
      } else if(x <= 0) {
        posicion.setX(0);
      }
    }
  }
  
  public int colision(float x, float y, float tamanio) {
    if (x >= posicion.getX() - (radio) && x <= posicion.getX() + (radio) && y >= posicion.getY() - (radio) && y <= posicion.getY() + (radio)) {
      if(diametro > tamanio) {
        setDiametro(diametro + (tamanio / 4));
        return 1;
      } else {
        return 2;
      }
    } else if (posicion.getX() >= x - (tamanio / 2) && posicion.getX() <= x + (tamanio / 2) && posicion.getY() >= y - (tamanio / 2) && posicion.getY() <= y + (tamanio / 2)) {
      if(diametro > tamanio) {
        setDiametro(diametro + (tamanio / 4));
        return 1;
      } else {
        return 2;
      }
    } else {
      return 0;
    }
  }
  
  public void mover() {
    if(isDetener()) {
      return;
    }
    
    int x = 0, y = 0;
    
    if(izquierdaDerecha == 2) {
      x = rand.nextInt((2 - 0) + 1) + 0;
    } else if(izquierdaDerecha == 1) {
      x = rand.nextInt((0 - (-2)) + 1) + (-2);
    }
    
    if(arribaAbajo == 2) {
      y = rand.nextInt((2 - 0) + 1) + 0;
    } else if(arribaAbajo == 1) {
      y = rand.nextInt((0 - (-2)) + 1) + (-2);
    }
    
    if(posicion.getY() + y >= 0 && posicion.getY() + y < height && posicion.getX() + x < width && posicion.getX() + x >= 0) {
      posicion.plusX(x);
      posicion.plusY(y);
    }
  }
  
  public void softMove(float x, float y) {
    moviendose = true;
    frameCont = 0;
    
    dx = (x - posicion.getX()) / 60;
    dy = (y - posicion.getY()) / 60;
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
}