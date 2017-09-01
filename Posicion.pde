public class Posicion {
  private float x;
  private float y;

  public Posicion(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  public void plusX(float pX) {
    this.x += pX;
  }

  public void plusY(float pY) {
    this.y += pY;
  }
  
  public void setX(float x) {
    this.x = x;
  }

  public void setY(float y) {
    this.y = y;
  }

  public float getX() {
    return x;
  }

  public float getY() {
    return y;
  }
}