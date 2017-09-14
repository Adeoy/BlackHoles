import ddf.minim.*;

private int VERSION = 11;

private ArrayList<BlackHole> blackHoles;
private Jugador jugador;
private int numBlackHoles = 5;
private Utils utils;
private int ancho = 800, alto = 600;
private int fdx = 0, fdy = 0, direccionFondo;
private float diametroJugador = alto / 10;

private int INIT_MAX_DIAMETRO = (alto / 10) * 3;
private int INIT_MIN_DIAMETRO = alto / 30;

private String texto;
private int duracionTexto;
private boolean visibleComando;

private int n, sec, nt;
private int comidos;
private int muertes = 0;
//private float masaTotal = 50.0;
private int nivel = 1;
private int posNuevoBlackHole = 25;

private boolean inmortal;
private PImage bg, ft1, ft2;

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
    song.play();
    
    init();
}

public void init() {
    jugador = new Jugador(diametroJugador, width / 2, height / 2);
    blackHoles = new ArrayList();
    utils = new Utils();
    inmortal = false;
    visibleComando = false;
    
    n = 0; nt = -1; duracionTexto = 3;
    fdx = 0; fdy = 0; direccionFondo = 1;
    sec = 0;
    comidos = 0;
    nivel = 1;

    for (int i = 0; i < numBlackHoles; i++) {
        addBlackHole();
    }
    
    mostrarTexto("Nivel 1", 3);
}

public void draw() {
    background(0);
  
    animarFondo();
  
    for (int i = 0; i < blackHoles.size(); i++) {
        if(i == -1) {
            break;
        }
      
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
    
    
    if(nt >= 0 && nt < duracionTexto * 60) {
        mostrarTexto();
        nt++;
    } else if(nt >= duracionTexto * 60) {
        nt = -1;    
    }
}

public void animarFondo() {
    if(direccionFondo == 1) {
        ft1 = bg.get(fdx, 0, width - fdx, height);
        ft2 = bg.get(0, 0, fdx, height);
      
        image(ft1, 0, 0);
        image(ft2, width - fdx, 0);
        
        fdx += 2;
        if (width - fdx < 0) {
            fdx = 0;
        }
    }
}

public void timing() {
    n++;
    if (n >= 60) {
        n = 0;
        sec++;

        if(utils.getPosibilidad(posNuevoBlackHole)) {
            addBlackHole();
        }

        if (sec % 2 == 0) {
            for (int i = 0; i < blackHoles.size(); i++) {
                blackHoles.get(i).setArribaAbajo(utils.getRandom(0, 2));
                blackHoles.get(i).setIzquierdaDerecha(utils.getRandom(0, 2));
            }
        }
    }
}

public void leveling() {
    switch(comidos) {
        case 10:
            nivel = 2;
            jugador.setDecreciendo(jugador.getDiametro() * 0.2);
            posNuevoBlackHole = 40;
            INIT_MAX_DIAMETRO += 20;
            INIT_MIN_DIAMETRO += 20;
            mostrarTexto("Nivel 2", 3);
            break;
        case 20:
            nivel = 3;
            jugador.setDecreciendo(jugador.getDiametro() * 0.35);
            posNuevoBlackHole = 55;
            INIT_MAX_DIAMETRO += 20;
            INIT_MIN_DIAMETRO += 20;
            mostrarTexto("Nivel 3", 3);
            break;
        case 30:
            nivel = 4;
            jugador.setDecreciendo(jugador.getDiametro() * 0.50);
            posNuevoBlackHole = 70;
            INIT_MAX_DIAMETRO += 20;
            INIT_MIN_DIAMETRO += 20;
            mostrarTexto("Nivel 4", 3);
            break;
        case 40:
            nivel = 5;
            jugador.setDecreciendo(jugador.getDiametro() * 0.7);
            posNuevoBlackHole = 85;
            INIT_MAX_DIAMETRO += 20;
            INIT_MIN_DIAMETRO += 20;
            mostrarTexto("Nivel 5", 3);
            break;
        case 50:
            nivel = 6;
            jugador.setDecreciendo(jugador.getDiametro() * 0.85);
            posNuevoBlackHole = 100;
            INIT_MAX_DIAMETRO += 20;
            INIT_MIN_DIAMETRO += 20;
            mostrarTexto("Nivel 6", 3);
            break;
    }
}

public void mostrarTexto() {
    textSize(50);
    textAlign(CENTER);
    text(texto, width / 2, height / 2);
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
    } else if (keyCode == 'H') {
        visibleComando = !visibleComando;
    }
}

public void printScreen() {
    textSize(20);
    
    textAlign(CENTER);
    text("Segundos: " + sec, width / 2, 30);
    textAlign(LEFT);
    text("Nivel: " + nivel, 10, 30);
    text("Comidos: " + comidos, width - 140, 30);
    text("a0." + VERSION, width - 60, height - 10);
    
    if(visibleComando) {
        textSize(16);
        text("Reset: R", width - 130, height / 2);
        text("BlackHole: N", width - 130, height / 2 + 20);
        text("Detener: D", width - 130, height / 2 + 40);
        text("Continuar: C", width - 130, height / 2 + 60);
        text("Inmortal: I", width - 130, height / 2 + 80);
        text("BlackHoles: " + blackHoles.size(), width - 130, height / 2 + 100);
        text("Muertes: " + muertes, width - 130, height / 2 + 120);
        //text("Masa Total: " + masaTotal, width - 130, 190); Recalcular mejor..
    }
}

public void addBlackHole() {
    float diametro;
    boolean valido;
    float x, y;
    float intento = 0;
    
    do {
        valido = true;
        intento++;
        
        diametro = utils.getRandom(INIT_MIN_DIAMETRO, INIT_MAX_DIAMETRO);
        x = utils.getRandom(INIT_MAX_DIAMETRO / 2, ancho - (INIT_MAX_DIAMETRO / 2));
        y = utils.getRandom(INIT_MAX_DIAMETRO / 2, alto - (INIT_MAX_DIAMETRO / 2));
        
        if(jugador.posicionOcupada(x, y, diametro)) {
            valido = false;
            continue;
        }
        
        for(int i = 0; i < blackHoles.size(); i++) {
            if(blackHoles.get(i).posicionOcupada(x, y, diametro)) {
              valido = false;
            }
        }
    } while (intento < 100 && !valido);
    
    //masaTotal += masa;
    if(intento < 10) {
        blackHoles.add(new BlackHole(0, x, y));
        blackHoles.get(blackHoles.size() - 1).setCreciendo(diametro);
    }
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
        jugador.setCreciendo(blackHoles.get(i).getDiametro() / 4);
        blackHoles.get(i).setMuriendo(true);
        comidos++;
        
        //absorb = minim.loadFile("absorb0" + (getRandom(1, 4)) + ".mp3");
        absorb = minim.loadFile("absorb05.mp3");
        absorb.play();
        
        leveling();
    } else if (estado == 2 && !inmortal) {
        jugador.setMuriendo(true);
        gameover = minim.loadFile("gameover.mp3");
        gameover.play();
        
        mostrarTexto("Has morido :c", 3);
    } else if (estado == 0) {
        for (int j = 0; j < blackHoles.size(); j++) {
            if(i != j) {
                int estado2 = blackHoles.get(i).colision(blackHoles.get(j).getPosicion().getX(), blackHoles.get(j).getPosicion().getY(), blackHoles.get(j).getDiametro(), blackHoles.get(j).isMuriendo());
    
                if (estado2 == 1) {
                    blackHoles.get(i).setCreciendo(blackHoles.get(j).getDiametro() / 4);
                    blackHoles.get(j).setMuriendo(true);
                    
                    enemyAbsorb = minim.loadFile("absorb06.mp3");
                    enemyAbsorb.play();
                    break;
                } else if (estado2 == 2) {
                    blackHoles.get(j).setCreciendo(blackHoles.get(i).getDiametro() / 4);
                    blackHoles.get(i).setMuriendo(true);
                    
                    enemyAbsorb = minim.loadFile("absorb06.mp3");
                    enemyAbsorb.play();
                    break;
                }
            }
        }
    }
}

public void mostrarTexto(String texto, int duracionTexto) {
    this.texto = texto;
    this.duracionTexto = duracionTexto;
    this.nt = 0;
}