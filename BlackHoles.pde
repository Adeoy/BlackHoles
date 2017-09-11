import ddf.minim.*;

private ArrayList<BlackHole> blackHoles;
private BlackHole jugador;
private int numBlackHoles = 15;
private Random rand;
private int ancho = 800, alto = 600;
private int dx = 0;

private int INIT_MAX_DIAMETRO = (alto / 10) * 3;
private int INIT_MIN_DIAMETRO = alto / 60;

private String texto;

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
    jugador = new BlackHole(alto / 10, width / 2, height / 2, true);
    blackHoles = new ArrayList();
    rand = new Random();
    inmortal = false;
    
    n = 0; nt = -1;
    sec = 0;
    comidos = 0;
    nivel = 1;

    for (int i = 0; i < numBlackHoles; i++) {
        addBlackHole();
    }
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
    
    
    if(nt >= 0 && nt < 180) {
        mostrarTexto();
        nt++;
    } else if(nt >= 180) {
        nt = -1;    
    }
}

public void animarFondo() {
    ft1 = bg.get(dx, 0, width - dx, height);
    ft2 = bg.get(0, 0, dx, height);
  
    image(ft1, 0, 0);
    image(ft2, width - dx, 0);
    
    dx += 2;
    if (width - dx < 0) {
        dx = 0;
    }
}

public void timing() {
    n++;
    if (n >= 60) {
        n = 0;
        sec++;

        if(getPosibilidad(posNuevoBlackHole)) {
            addBlackHole();
        }

        if (sec % 2 == 0) {
            for (int i = 0; i < blackHoles.size(); i++) {
                blackHoles.get(i).setArribaAbajo(getRandom(0, 2));
                blackHoles.get(i).setIzquierdaDerecha(getRandom(0, 2));
            }
        }
    }
}

public void leveling() {
    switch(comidos) {
        case 10:
            nivel = 2;
            jugador.setDecreciendo(jugador.getDiametro() * 0.15);
            posNuevoBlackHole = 40;
            nt = 0;
            texto = "Nivel 2";
            break;
        case 20:
            nivel = 3;
            jugador.setDecreciendo(jugador.getDiametro() * 0.25);
            posNuevoBlackHole = 60;
            nt = 0;
            texto = "Nivel 3";
            break;
        case 30:
            nivel = 4;
            jugador.setDecreciendo(jugador.getDiametro() * 0.5);
            posNuevoBlackHole = 85;
            nt = 0;
            texto = "Nivel 4";
            break;
        case 40:
            nivel = 5;
            jugador.setDecreciendo(jugador.getDiametro() * 0.75);
            posNuevoBlackHole = 100;
            nt = 0;
            texto = "Nivel 5";
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
    }
}

public void printScreen() {
    textSize(20);
    textAlign(LEFT);
    text("Nivel: " + nivel, 10, 30);
    text("Segundos: " + sec, 10, 60);
    
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
    blackHoles.add(new BlackHole(0, x, y, false));
    blackHoles.get(blackHoles.size() - 1).setCreciendo(diametro);
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
        //jugador.setDiametro(jugador.getDiametro() + (blackHoles.get(i).getDiametro() / 4));
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
        
        nt = 0;
        texto = "Has morido :c";
    } else if (estado == 0) {
        for (int j = 0; j < blackHoles.size(); j++) {
            if(i != j) {
                int estado2 = blackHoles.get(i).colision(blackHoles.get(j).getPosicion().getX(), blackHoles.get(j).getPosicion().getY(), blackHoles.get(j).getDiametro(), blackHoles.get(j).isMuriendo());
    
                if (estado2 == 1) {
                    //blackHoles.get(i).setDiametro(blackHoles.get(i).getDiametro() + (blackHoles.get(j).getDiametro() / 4));
                    blackHoles.get(i).setCreciendo(blackHoles.get(j).getDiametro() / 4);
                    blackHoles.get(j).setMuriendo(true);
                    
                    enemyAbsorb = minim.loadFile("absorb06.mp3");
                    enemyAbsorb.play();
                    break;
                } else if (estado2 == 2) {
                    //blackHoles.get(j).setDiametro(blackHoles.get(j).getDiametro() + (blackHoles.get(i).getDiametro() / 4));                    
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

public int getRandom(int min, int max) {
    return rand.nextInt(max - min + 1) + min;
}

public boolean getPosibilidad(int porcentaje) {
    if(porcentaje >= getRandom(1, 100)) {
        return true;
    } else {
        return false;
    }
}