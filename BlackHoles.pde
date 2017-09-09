import ddf.minim.*;

private ArrayList<BlackHole> blackHoles;
private BlackHole jugador;
private int numBlackHoles = 25;
private Random rand;
private int ancho = 800, alto = 600;

private int n, sec;
private int comidos;
private int muertes = 0;
//private float masaTotal = 50.0;
private boolean inmortal;
private PImage bg;

Minim minim;
AudioPlayer song;
AudioPlayer absorb;
AudioPlayer enemyAbsorb;

public void setup() {
    frameRate(60);
    size(800, 600);
    bg = loadImage("bg.png");
    
    minim = new Minim(this);
 
    song = minim.loadFile("space.mp3");
    song.play();
    
    init();
}

public void init() {
    jugador = new BlackHole(50, width / 2, height / 2, true);
    blackHoles = new ArrayList();
    rand = new Random();
    inmortal = false;
    
    n = 0;
    sec = 0;
    comidos = 0;

    for (int i = 0; i < numBlackHoles; i++) {
        addBlackHole();
    }
}

public void draw() {
    background(bg);

    for (int i = 0; i < blackHoles.size(); i++) {
        blackHoles.get(i).mover();
        blackHoles.get(i).dibujar();

        if(validarColision(i)) {
          i--;
        }
    }

    jugador.dibujar();
    fill(255);
    
    timing();
    printScreen();
}

public void timing() {
    n++;
    if (n >= 60) {
        n = 0;
        sec++;

        if (sec % 2 == 0) {
            for (int i = 0; i < blackHoles.size(); i++) {
                blackHoles.get(i).setArribaAbajo(rand.nextInt((2 - 0) + 1) + 0);
                blackHoles.get(i).setIzquierdaDerecha(rand.nextInt((2 - 0) + 1) + 0);
            }
            
            if(rand.nextInt((2 - 1) + 1) + 1 == 1) {
                addBlackHole();
            }
        }
    }
}

public void mouseDragged() {
    jugador.softMove(mouseX, mouseY);
}

public void keyPressed() {
    if (keyCode == 'R') {
        init();
    } else if (keyCode == 'N') {
        addBlackHole();
    } else if (keyCode == 'D') {
        detener();
    } else if (keyCode == 'C') {
        continuar();
    } else if (keyCode == 'I') {
        inmortal = !inmortal;
    }
}

public void printScreen() {
    textSize(20);
    text("Segundos: " + sec, 10, 30);
    text("Reset: R", width - 160, 30);
    text("BlackHole: N", width - 160, 60);
    text("Detener: D", width - 160, 90);
    text("Continuar: C", width - 160, 120);
    text("Inmortal: I", width - 160, 150);
    text("BlackHoles: " + blackHoles.size(), width - 160, 180);
    text("Comidos: " + comidos, width - 160, 210);
    text("Muertes: " + muertes, width - 160, 240);
    //text("Masa Total: " + masaTotal, width - 160, 270); Recalcular mejor..
}

public void addBlackHole() {
    float masa = rand.nextInt((150 - 10) + 1) + 10;
    //masaTotal += masa;
    blackHoles.add(new BlackHole(masa, rand.nextInt((ancho - 0) + 1) + 0, rand.nextInt((alto - 0) + 1), false));
}

public void removeBlackHole(int index) {
    //masaTotal -= blackHoles.get(index).getDiametro();
    blackHoles.remove(index);
}

public void detener() {
    for (int i = 0; i < blackHoles.size(); i++) {
        blackHoles.get(i).setDetener(true);
    }
}

public void continuar() {
    for (int i = 0; i < blackHoles.size(); i++) {
        blackHoles.get(i).setDetener(false);
    }
}

public boolean validarColision(int i) {
    boolean colision = false;
    int estado = jugador.colision(blackHoles.get(i).getPosicion().getX(), blackHoles.get(i).getPosicion().getY(), blackHoles.get(i).getDiametro());

    if (estado == 1) {
        removeBlackHole(i);
        colision = true;
        comidos++;
        
        absorb = minim.loadFile("absorb0" + (rand.nextInt((4 - 1) + 1) + 1) + ".mp3");
        //absorb = minim.loadFile("absorb05.mp3");
        absorb.play();
    } else if (estado == 2 && !inmortal) {
        muertes++;
        init();
    } else {
        for (int j = 0; j < blackHoles.size(); j++) {
            if(i != j) {
                int estado2 = blackHoles.get(i).colision(blackHoles.get(j).getPosicion().getX(), blackHoles.get(j).getPosicion().getY(), blackHoles.get(j).getDiametro());
    
                if (estado2 == 1) {
                    removeBlackHole(j);
                    colision = true;
                    
                    enemyAbsorb = minim.loadFile("absorb06.mp3");
                    enemyAbsorb.play();
                    
                    break;
                } else if (estado2 == 2) {
                    blackHoles.get(j).setDiametro(blackHoles.get(j).getDiametro() + (blackHoles.get(i).getDiametro() / 4));                    
                    removeBlackHole(i);
                    colision = true;
                    
                    enemyAbsorb = minim.loadFile("absorb06.mp3");
                    enemyAbsorb.play();
                    
                    break;
                }
            }
        }
    }
    return colision;
}