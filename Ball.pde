class Ball {
  float x, y;
  float xSpeed, ySpeed;
  int radius = 40;
  PImage ballImage;

  String[] imageFiles = {"stuff1.png", "stuff2.png", "stuff3.png", "stuff4.png", "stuff5.png", "stuff6.png", "stuff7.png", "stuff8.png", "stuff9.png"};
  
  Ball(float startX, float startY) {
    x = startX;
    y = startY;
    xSpeed = random(-1, 4);
    ySpeed = random(-1, 4);
    
    int randomIndex = (int) random(imageFiles.length);
    ballImage = loadImage(imageFiles[randomIndex]);
  }
  
  void move() {
    x += xSpeed;
    y += ySpeed;

    if (x < 0 || x > width) {
      xSpeed *= -1;
    }
    if (y < 0 || y > height) {
      ySpeed *= -1;
    }
  }
  
  void display() {
    tint(255, 255);
    imageMode(CENTER);
    image(ballImage, x, y, radius * 2, radius * 2);
  }
}
