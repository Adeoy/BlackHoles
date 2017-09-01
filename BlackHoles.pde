import java.util.Random;

private ArrayList<BlackHole> blackHoles;
private BlackHole jugador;
private int numBlackHoles = 20;
private Random rand;
private int ancho = 800, alto = 600;

private int n, sec;
private int comidos;
private int muertes = 0;

public void setup() {
  frameRate(60);
  size(800, 600);
  
  init();
}

public void init() {
  jugador = new BlackHole(50, width / 2, height / 2, true);
  blackHoles = new ArrayList();
  rand = new Random();
  
  n = 0; sec = 0;
  comidos = 0;
  
  for(int i = 0; i < numBlackHoles; i++) {
    blackHoles.add(new BlackHole(rand.nextInt((150 - 10) + 1) + 10, rand.nextInt((ancho - 0) + 1) + 0, rand.nextInt((alto - 0) + 1), false));
  }
}

public void draw() {
  background(192);
  
  jugador.dibujar();
  
  for(int i = 0; i < blackHoles.size(); i++) {
    blackHoles.get(i).mover();
    blackHoles.get(i).dibujar();
    
    int estado = blackHoles.get(i).colision(jugador.getPosicion().getX(), jugador.getPosicion().getY(), jugador.getDiametro());

    if(estado == 2) {
      jugador.setDiametro(jugador.getDiametro() + blackHoles.get(i).getDiametro() / 3);
      blackHoles.remove(i);
      comidos++;
    } else if(estado == 1) {
      muertes++;
      init();
    }
  }
  
  fill(255);
  timing();
  
  text("Reset: R", width - 120, 30);
  text("Comidos: " + comidos, width - 120, 60);
  text("Muertes: " + muertes, width - 120, 90);
}

public void timing() {
  n++;
  if(n >= 60) {
    n = 0;
    sec++;
    
    if(sec % 2 == 0) {
      for(int i = 0; i < blackHoles.size(); i++) {
        blackHoles.get(i).setArribaAbajo(rand.nextInt((2 - 0) + 1) + 0);
        blackHoles.get(i).setIzquierdaDerecha(rand.nextInt((2 - 0) + 1) + 0);
      }
      
      if(comidos >= 10 && blackHoles.size() <= 20) {
        jugador.setDiametro(jugador.getDiametro() / 1.2);
        blackHoles.add(new BlackHole(rand.nextInt((150 - 10) + 1) + 10, rand.nextInt((ancho - 0) + 1) + 0, rand.nextInt((alto - 0) + 1), false));
      }
    }
  }
  
  textSize(20);
  text("Segundos: " + sec, 10, 30);
}
/*
public void mouseDragged() {
  jugador.mover(mouseX, mouseY);
  for(int i = 0; i < blackHoles.size(); i++) {
    int estado = jugador.colision(blackHoles.get(i).getPosicion().getX(), blackHoles.get(i).getPosicion().getY(), blackHoles.get(i).getDiametro());

    if(estado == 1) {
      blackHoles.remove(i);
      comidos++;
    } else if(estado == 2) {
      muertes++;
      init();
    }
  }
}
*/
public void mousePressed() {
  jugador.softMove(mouseX, mouseY);
}

public void keyPressed() {
  if(keyCode == 'R') {
    init();
  }
}