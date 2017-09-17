public class Boton {

    private Posicion posicion;
    private color colorBorde;
    private color colorFondo;
    private String texto;
    private float ancho, alto;
    private float redondeado;
    private boolean encima, cliqueado;

    public Boton(float x, float y, float ancho, float alto, float redondeado, String texto, color colorBorde, color colorFondo) {
        this.posicion = new Posicion(x, y);
        this.colorBorde = colorBorde;
        this.colorFondo = colorFondo;
        this.texto = texto;
        this.ancho = ancho;
        this.alto = alto;
        this.redondeado = redondeado;
        encima = false;
        cliqueado = false;
    }

    public void dibujar() {
        stroke(colorBorde);
        rectMode(CENTER);
        fill(colorFondo);
        rect(posicion.getX(), posicion.getY(), ancho, alto, redondeado);
        
        if(isEncima()) {
            rectMode(CENTER);
            fill(color(0, 0, 0, 31));
            rect(posicion.getX(), posicion.getY(), ancho, alto, redondeado);
        }
        
        textSize(40);
        textAlign(CENTER, CENTER);
        fill(223);
        text(texto, posicion.getX(), posicion.getY());
    }
    
    public void validarColision(float x, float y, int estado) {
        float tempX = posicion.getX() - (ancho / 2);
        float tempY = posicion.getY() - (alto / 2);
        
        if(x >= tempX && x < tempX + ancho && y >= tempY && y <= tempY + alto) {
            if(estado == 1) {
                encima = true;
            } else {
                cliqueado = true;
            }
        } else {
            if(estado == 1) {
                encima = false;
            } else {
                cliqueado = false;
            }
        }
    }

    public Posicion getPosicion() {
        return posicion;
    }

    public void setPosicion(Posicion posicion) {
        this.posicion = posicion;
    }

    public color getColorBorde() {
        return colorBorde;
    }

    public void setColorBorde(color colorBorde) {
        this.colorBorde = colorBorde;
    }

    public color getColorFondo() {
        return colorFondo;
    }

    public void setColorFondo(color colorFondo) {
        this.colorFondo = colorFondo;
    }

    public String getTexto() {
        return texto;
    }

    public void setTexto(String texto) {
        this.texto = texto;
    }

    public float getAncho() {
        return ancho;
    }

    public void setAncho(float ancho) {
        this.ancho = ancho;
    }

    public float getAlto() {
        return alto;
    }

    public void setAlto(float alto) {
        this.alto = alto;
    }

    public float getRedondeado() {
        return redondeado;
    }

    public void setRedondeado(float redondeado) {
        this.redondeado = redondeado;
    }

    public boolean isEncima() {
        return encima;
    }

    public void setEncima(boolean encima) {
        this.encima = encima;
    }

    public boolean isCliqueado() {
        return cliqueado;
    }

    public void setCliqueado(boolean cliqueado) {
        this.cliqueado = cliqueado;
    }
}