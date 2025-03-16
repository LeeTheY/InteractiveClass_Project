class Bruise {
  int x, y;
  int opacity;
  int size;
  
  Bruise(int tmpX, int tmpY, int bruiseCircle) {
    x = tmpX;
    y = tmpY;
    size = bruiseCircle;
    opacity = 90;
  }
  
  void display() {
    noStroke();
    fill(#C6A617, opacity);
    ellipse(x, y, size, size);
    ellipse(x-15, y-15, size, size);
    ellipse(x+5, y-10, size, size);
    ellipse(x+25, y+10, size, size);
    ellipse(x-10, y+15, size, size);
  }
  
  void update() {
    opacity -= fadeSpeed;
  }
}
