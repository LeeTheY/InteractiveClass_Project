//라이브러리
import processing.opengl.*;
import processing.video.*;
import controlP5.*;
import ddf.minim.*;

ControlP5 cp5;
Movie video;
Capture webcam;
Minim minim;
AudioPlayer player;

//초기 화면의 볼륨 조절 및 파형을 담당하는 변수
float volume = 0.5;
int volBarX = 600;
int volBarY = 900;
int volBarWidth = 400; 
int volBarHeight = 20;

int waveBoxX = 600;
int waveBoxY = 750;
int waveBoxWidth = 400;
int waveBoxHeight = 100;

boolean toggleValue = false;


//게임시작, 게임 종료, 종료 후 점수 페이지를 담당하는 변수
boolean welcomeIntro = true;
boolean gameStarted = false;
boolean gameOver = false;
boolean showScorePage = false;

//폰트 변수
PFont myfont;

//포인트와 생명 초기값 변수
int points = 0;
int lives = 10;

//심슨의 얼굴 크기 변수
int leftEyeX = 600;
int leftEyeY = 300;
int rightEyeX = 1000; 
int rightEyeY = 300;
int noseX = 800;
int noseY = 430;

//왼쪽, 오른쪽 동공의 위치 값 계산 변수
float leftPupilX, leftPupilY;
float rightPupilX, rightPupilY;

//동공의 크기 변수
int pupilRadius = 25;

//멍이 사라지는 속도 설정 변수
float fadeSpeed = 1;

//공이 마지막으로 생성된 시간을 담는 변수
int lastBallTime = 0;

//게임 진행에 있어 필요한 공과 멍의 개수를 동적으로 관리하기 위한 배열
ArrayList<Ball> balls = new ArrayList<Ball>(); 
ArrayList<Bruise> bruises = new ArrayList<Bruise>();

//data 폴더에 저장된 비디오를 불러옴 
void movieEvent(Movie video) {
  video.read();
}


void setup() {
  size(1600, 1000, OPENGL);
  background(#fed41d);
  
  video = new Movie(this, "Welcome_intro.mov");
  video.loop();
  
  
  minim = new Minim(this);
  player = minim.loadFile("simpsonsTheme.mp3");
  
  cp5 = new ControlP5(this);
  // 재생 및 일시정지 버튼 추가
  cp5.addToggle("play")
     .setLabel("Play")
     .setPosition(550, 890)
     .setSize(40, 40)
     .setValue(toggleValue)
     .setColorBackground(color(150))
     .setColorActive(color(#6E00FF))
     .setColorLabel(color(0));

  // 볼륨 조절 슬라이더 추가
  cp5.addSlider("volume")
     .setRange(0, 1)
     .setValue(volume)
     .setPosition(600, 900)
     .setSize(400, 20)
     .setLabelVisible(false)
     .setColorBackground(color(255))
     .setColorForeground(color(#6E00FF))
     .setColorActive(color(#6E00FF));
  
  
  //게임에 알맞는 폰트 설정
  myfont = loadFont("STYuanti-TC-Regular-32.vlw"); 
  textFont(myfont);
  textSize(32);
  
  //종료 화면에 사용할 웹캠 사이즈 설정
  webcam = new Capture(this, 500, 300);
  
}

void draw() {
  background(#fed41d);
  
  // 상태에 따라 ControlP5 요소를 보이거나 숨기기
  if (welcomeIntro) {
    cp5.getController("play").show();
    cp5.getController("volume").show();
  } else {
    cp5.getController("play").hide();
    cp5.getController("volume").hide();
  }
  
  
  if(welcomeIntro){
    
    fill(0);
    textSize(50);
    textAlign(CENTER);
    text("Press the Enter to Start", 800, 200);
    
    //초기화면에서 WELCOME 문구를 그림
    noStroke();
    beginShape();
    texture(video);
    vertex(160, 372, 160, 372);
    vertex(128, 372, 128, 372);
    vertex(128, 596, 128, 596);
    vertex(160, 596, 160, 596);
    vertex(192, 532, 192, 532);
    vertex(224, 532, 224, 532);
    vertex(256, 596, 256, 596);
    vertex(288, 596, 288, 596);
    vertex(288, 372, 288, 372);
    vertex(256, 372, 256, 372);
    vertex(256, 532, 256, 532);
    vertex(224, 468, 224, 468);
    vertex(192, 468, 192, 468);
    vertex(160, 532, 160, 532);
    endShape();
    
    beginShape();
    texture(video);
    vertex(480, 372, 480, 372);
    vertex(352, 372, 352, 372);
    vertex(352, 596, 352, 596);
    vertex(480, 596, 480, 596);
    vertex(480, 564, 480, 564);
    vertex(384, 564, 384, 564);
    vertex(384, 500, 384, 500);
    vertex(480, 500, 480, 500);
    vertex(480, 468, 480, 468);
    vertex(384, 468, 384, 468);
    vertex(384, 404, 384, 404);
    vertex(480, 404, 480, 404);
    endShape();
    
    beginShape();
    texture(video);
    vertex(576, 372, 576, 372);
    vertex(544, 372, 544, 372);
    vertex(544, 596, 544, 596);
    vertex(672, 596, 672, 596);
    vertex(672, 564, 672, 564);
    vertex(576, 564, 576, 564);
    endShape();
    
    beginShape();
    texture(video);
    vertex(864, 372, 864, 372);
    vertex(736, 372, 736, 372);
    vertex(736, 596, 736, 596);
    vertex(864, 596, 864, 596);
    vertex(864, 564, 864, 564);
    vertex(768, 564, 768, 564);
    vertex(768, 404, 768, 404);
    vertex(864, 404, 864, 404);
    endShape();
    
    beginShape();
    texture(video);
    vertex(1056, 372, 1056, 372);
    vertex(928, 372, 928, 372);
    vertex(928, 596, 928, 596);
    vertex(1056, 596, 1056, 596);
    vertex(1056, 404, 1056, 404);
    vertex(1024, 404, 1024, 404);
    vertex(1024, 564, 1024, 564);
    vertex(960, 564, 960, 564);
    vertex(960, 404, 960, 404);
    vertex(1056, 404, 1056, 404);
    endShape();
    
    beginShape();
    texture(video);
    vertex(1152, 596, 1152, 596);
    vertex(1120, 596, 1120, 596);
    vertex(1120, 372, 1120, 372);
    vertex(1152, 372, 1152, 372);
    vertex(1184, 436, 1184, 436);
    vertex(1216, 436, 1216, 436);
    vertex(1248, 372, 1248, 372);
    vertex(1280, 372, 1280, 372);
    vertex(1280, 596, 1280, 596);
    vertex(1248, 596, 1248, 596);
    vertex(1248, 436, 1248, 436);
    vertex(1216, 500, 1216, 500);
    vertex(1184, 500, 1184, 500);
    vertex(1152, 436, 1152, 436);
    endShape();
    
    beginShape();
    texture(video);
    vertex(1472, 372, 1472, 372);
    vertex(1344, 372, 1344, 372);
    vertex(1344, 596, 1344, 596);
    vertex(1472, 596, 1472, 596);
    vertex(1472, 564, 1472, 564);
    vertex(1376, 564, 1376, 564);
    vertex(1376, 500, 1376, 500);
    vertex(1472, 500, 1472, 500);
    vertex(1472, 468, 1472, 468);
    vertex(1376, 468, 1376, 468);
    vertex(1376, 404, 1376, 404);
    vertex(1472, 404, 1472, 404);
    endShape();
        
    
    //볼륨 크기 설정
    player.setGain(map(volume, 0, 1, -60, 0));
    
    fill(0);
    textSize(30);
    textAlign(CENTER);
    text("Volume: " + int(volume * 100), 800, 880);
    
    fill(#ff0000);
    textSize(20);
    text("(Click the button to play a song)", 800, volBarY + 45);
    text("(Drag to adjust volume)", 800, volBarY + 65);
    
    
    //배경음악의 파형을 출력
    pushMatrix();
    translate(waveBoxX, waveBoxY);
    noStroke();
    fill(#fed41d);
    rect(0, 0, waveBoxWidth, waveBoxHeight);
    
   
    stroke(#6E00FF);
    noFill();
    beginShape();
    for (int i = 0; i < player.bufferSize(); i++) {
      float x = map(i, 0, player.bufferSize(), 0, waveBoxWidth);
      
      
      float y = waveBoxHeight / 2 + player.left.get(i) * 50 * volume;
      vertex(x, y);
    }
    endShape();
    popMatrix();
     
    return;
  }
 
  
  //게임 오버 시
  if(gameOver){
    fill(0);
    textSize(64);
    textAlign(CENTER);
    text("Game Over!", 800, 130);
    text("Final Points: " + points, 800, 200);
    
    
    textSize(32);
    text("[ CAMERA ]", 800, 335);
    
    //게임 오버되면 웹캠이 실행됨
    webcam.start();
    if (webcam.available()) {
      webcam.read();
    }
    
    image(webcam, 800, 495, 500, 300); 
    
    fill(#ff0000);
    textSize(24);
    text("(Press the S key to ScreenShot Game Score)", 800, 670);
    
    
    fill(255);
    stroke(0);
    strokeWeight(3);
    rectMode(CENTER);
    rect(800, 760, 500, 50);
    
    fill(0);
    textSize(32);
    text("Press the Backspace to Start Again", 800, 770);
    
    return;
  }
  
  //게임 시작 전
  if(!gameStarted){
      fill(0);
      textAlign(CENTER);
      textSize(50);
      text("Press the Space to Game Start", 800, 50);
  }
  //게임 시작 후
  else{
    fill(0);
    textAlign(LEFT);
    text("Points: " + points, 20, 50);
    text("Lives: " + lives, 20, 90);
  }
 
  //마우스 위치에 따라 얼굴이 이동
  float faceMoveX = (mouseX - 800) * 0.05; 
  float faceMoveY = (mouseY - 500) * 0.05;
  
  //왼쪽 눈
  fill(255);
  noStroke();
  ellipseMode(CENTER);
  ellipse(leftEyeX + faceMoveX, leftEyeY + faceMoveY, 300, 300);
  noFill();
  stroke(0);
  strokeWeight(5);
  arc(leftEyeX + faceMoveX, leftEyeY + faceMoveY, 300, 300, radians(47), radians(380));
  
  
  //왼쪽 동공 좌표 계산 
  leftPupilX = mouseX;
  leftPupilY = mouseY;
  if (dist(leftPupilX, leftPupilY, leftEyeX, leftEyeY) > 100) {
    float angle = atan2(mouseY - leftEyeY, mouseX - leftEyeX);
    leftPupilX = leftEyeX + cos(angle) * 100;
    leftPupilY = leftEyeY + sin(angle) * 100;
  }
  
  //왼쪽 동공
  noStroke();
  fill(0);
  ellipseMode(CENTER);
  ellipse(leftPupilX + faceMoveX, leftPupilY + faceMoveY, pupilRadius * 2, pupilRadius * 2);
  
  //오른쪽 눈
  fill(255);
  noStroke();
  ellipseMode(CENTER);
  ellipse(rightEyeX + faceMoveX, rightEyeY + faceMoveY, 300, 300);
  noFill();
  stroke(0);
  strokeWeight(5);
  arc(rightEyeX + faceMoveX, rightEyeY + faceMoveY, 300, 300, radians(-199), radians(133));
  
  
  //오른쪽 동공 좌표 계산 
  rightPupilX = mouseX;
  rightPupilY = mouseY;
  if (dist(rightPupilX, rightPupilY, rightEyeX, rightEyeY) > 100) {
    float angle = atan2(mouseY - rightEyeY, mouseX - rightEyeX);
    rightPupilX = rightEyeX + cos(angle) * 100;
    rightPupilY = rightEyeY + sin(angle) * 100;
  }
  
  //오른쪽 동공
  noStroke();
  fill(0);
  ellipseMode(CENTER);
  ellipse(rightPupilX + faceMoveX, rightPupilY + faceMoveY, 50,  50);
  
  //코 그림자
  fill(0, 50);
  noStroke();
  arc(noseX + 8 + faceMoveX, noseY + 13 + faceMoveY, 200, 200, radians(-15), radians(140));
  
  //코
  fill(#fed41d);
  stroke(0);
  arc(noseX + faceMoveX, noseY + faceMoveY, 200, 200, radians(-55), radians(235));
 
  
  //입
  noFill();
  stroke(0);
  strokeWeight(8); 
  curve(700 + faceMoveX, 500 + faceMoveY, 545 + faceMoveX, 700 + faceMoveY, 1055 + faceMoveX, 700 + faceMoveY, 1200 + faceMoveX, 500 + faceMoveY); 
   
  //입 그림자
  noFill();
  stroke(0, 50);
  strokeWeight(10);
  curve(700 + faceMoveX, 507 + faceMoveY, 545 + faceMoveX, 707 + faceMoveY, 1055 + faceMoveX, 707 + faceMoveY, 1200 + faceMoveX, 507 + faceMoveY); 

  
  //입꼬리
  noFill();
  stroke(0);
  strokeWeight(5);
  curve(600 + faceMoveX, 675 + faceMoveY, 550 + faceMoveX, 675 + faceMoveY, 550 + faceMoveX, 725 + faceMoveY, 600 + faceMoveX, 725 + faceMoveY); 
  curve(1000 + faceMoveX, 675 + faceMoveY, 1050 + faceMoveX, 675 + faceMoveY, 1050 + faceMoveX, 725 + faceMoveY, 1000 + faceMoveX, 725 + faceMoveY);
  
  // 0.7초에 한 번씩 공 생성
  if (gameStarted && millis() - lastBallTime > 700) {
      balls.add(new Ball(random(width), random(height)));
      lastBallTime = millis();
  }

  // 공 생성
  for (Ball b : balls) {
    b.move();
    b.display();
  }

  //멍 그리기
  for (int i = bruises.size() - 1; i >= 0; i--) {
    Bruise c = bruises.get(i);
    c.display();
    c.update();

    if (c.opacity <= 0) {
      bruises.remove(i);
    }
  }
}
  
void mousePressed() {  
  boolean hitBall = false;
  
  //공을 클릭 시 포인트 획득
  for (int i = balls.size() - 1; i >= 0; i--) {
    Ball b = balls.get(i);
    
    if (dist(mouseX, mouseY, b.x, b.y) < b.radius) {
      balls.remove(i);
      points++;
      hitBall = true;
      break;
    }
  }
      
  // 공을 잡지 못한 경우 멍 생성
  if (gameStarted) {
    if (!hitBall) {
      lives--;
      bruises.add(new Bruise(mouseX, mouseY, 100));
      
      if (lives == 0) {
        gameOver = true;
        showScorePage = true;
      }
    }
  }
}

//게임 시작 및 다시 시작, 스크린샷 저장을 제어
void keyPressed() {
  
  
  if (keyCode == ENTER){
    if (welcomeIntro){ 
      welcomeIntro = false;
    }
  }
  else if (key == ' ' && !welcomeIntro){
    if (!gameStarted) {
      gameStarted = true;
    }
  }
  
  else if (keyCode == BACKSPACE){
    if (gameOver) {
      resetGame();
      webcam.stop(); 
      welcomeIntro = true;
      return;
    }
  }
  
  else if (key == 'S' || key == 's'){
    //saveFrame("screenshot/Mypoint-####.tif");
    saveFrame("screenshot_point" + points + ".png");
  }
  
}

//게임 포인트 초기화
void resetGame() {
  points = 0;
  lives = 10;
  balls.clear();
  bruises.clear();
  gameStarted = false;
  gameOver = false;
  showScorePage = false;
}



// 토글 버튼 클릭 시 동작
void play(boolean theState) {
  toggleValue = theState;

  Toggle toggle = (Toggle) cp5.getController("play");
  if (toggleValue) {
    player.play();
    toggle.setLabel("Pause");
  } else {
    player.pause();
    toggle.setLabel("Play");
  }
}

//노래 재생 및 일시정지를 제어
void stop() {
  player.close();
  minim.stop();
  super.stop();
}
