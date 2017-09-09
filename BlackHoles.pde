import ddf.minim.*;

private ArrayList<BlackHole> blackHoles;
private BlackHole jugador;
private int numBlackHoles = 20;
private Random rand;
private int ancho = 800, alto = 600;

private int INIT_MAX_DIAMETRO = 150;
private int INIT_MIN_DIAMETRO = 10;

private int n, sec;
private int comidos;
private int muertes = 0;
//private float masaTotal = 50.0;
private boolean inmortal;
private PImage bg;

private Minim minim;
private AudioPlayer song;
private AudioPlayer absorb;
private AudioPlayer enemyAbsorb;
private AudioPlayer gameover;

public void setup() {
    frameRate(60);
    size(800, 600);
    bg = loadImage("bg.png");
    
    minim = new Minim(this);
 
    song = minim.loadFile("space.mp3");
    //song.play();
    
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

        validarColision(i);
        
        if(blackHoles.get(i).isMuerto()) {
            removeBlackHole(i);
            i--;
        }
    }

    jugador.dibujar();
    
    if(jugador.isMuerto()) {
        muertes++;
        init();
    }
    
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
                blackHoles.get(i).setArribaAbajo(getRandom(0, 2));
                blackHoles.get(i).setIzquierdaDerecha(getRandom(0, 2));
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
    float diametro;
    boolean valido;
    float x, y;
    
    do {
        valido = true;
        diametro = getRandom(INIT_MIN_DIAMETRO, INIT_MAX_DIAMETRO);
        x = getRandom(INIT_MAX_DIAMETRO / 2, ancho - (INIT_MAX_DIAMETRO / 2));
        y = getRandom(INIT_MAX_DIAMETRO / 2, alto - (INIT_MAX_DIAMETRO / 2));
        
        if(jugador.colision(x, y, diametro) != 0) {
            valido = false;
            continue;
        }
        
        for(int i = 0; i < blackHoles.size(); i++) {
            if(blackHoles.get(i).colision(x, y, diametro) != 0) {
              valido = false;
            }
        }
    } while (!valido);
    
    //masaTotal += masa;
    blackHoles.add(new BlackHole(diametro, x, y, false));
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

public void validarColision(int i) {
    int estado = jugador.colision(blackHoles.get(i).getPosicion().getX(), blackHoles.get(i).getPosicion().getY(), blackHoles.get(i).getDiametro(), blackHoles.get(i).isMuriendo());

    if (estado == 1) {
        jugador.setCreciendo(true, blackHoles.get(i).getDiametro() / 4);
        //jugador.setDiametro(jugador.getDiametro() + (blackHoles.get(i).getDiametro() / 4));
        blackHoles.get(i).setMuriendo(true);
        comidos++;
        
        absorb = minim.loadFile("absorb0" + (getRandom(1, 4)) + ".mp3");
        //absorb = minim.loadFile("absorb05.mp3");
        absorb.play();
    } else if (estado == 2 && !inmortal) {
        jugador.setMuriendo(true);
        gameover = minim.loadFile("gameover.mp3");
        gameover.play();
    } else if (estado == 0) {
        for (int j = 0; j < blackHoles.size(); j++) {
            if(i != j) {
                int estado2 = blackHoles.get(i).colision(blackHoles.get(j).getPosicion().getX(), blackHoles.get(j).getPosicion().getY(), blackHoles.get(j).getDiametro(), blackHoles.get(j).isMuriendo());
    
                if (estado2 == 1) {
                    //blackHoles.get(i).setDiametro(blackHoles.get(i).getDiametro() + (blackHoles.get(j).getDiametro() / 4));
                    blackHoles.get(i).setCreciendo(true, blackHoles.get(j).getDiametro() / 4);
                    blackHoles.get(j).setMuriendo(true);
                    
                    enemyAbsorb = minim.loadFile("absorb06.mp3");
                    enemyAbsorb.play();
                    break;
                } else if (estado2 == 2) {
                    //blackHoles.get(j).setDiametro(blackHoles.get(j).getDiametro() + (blackHoles.get(i).getDiametro() / 4));                    
                    blackHoles.get(j).setCreciendo(true, blackHoles.get(i).getDiametro() / 4);
                    blackHoles.get(i).setMuriendo(true);
                    
                    enemyAbsorb = minim.loadFile("absorb06.mp3");
                    enemyAbsorb.play();
                    break;
                }
            }
        }
    }
}

public int getRandom(int min, int max) {
    return rand.nextInt(max - min + 1) + min;
}