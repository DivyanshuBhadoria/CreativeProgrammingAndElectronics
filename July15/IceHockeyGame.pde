//number of balls ingame
int ballNumber = 1;
final int size = 4;
Ball[] balls = new Ball[size];
int counter = 0;
boolean gameEnd = false;
void setup() {
  size(400, 300);
  for (int i = 0; i < balls.length; i++) {
    balls[i] = new Ball();
  }
}
void draw() {
  //Check if player has lost
  if (gameEnd) {
    textSize(32);
    fill(0, 0, 0);
    text("You Lose", 130, 150);
  } else {
    fill(255, 208, 141);
    stroke(255, 208, 141);
    rect(0, 0, 400, 400);
    stroke(0,0,0);
    fill(237, 0, 38);
    //barrier player conrols
    rect(mouseX-40, 15, 80, 20, 5);
    for (int i = 0; i < ballNumber; i++) {
      //update and check if ball needs to bounce for all balls in-game
      balls[i].update();
      balls[i].checkBounce();
      if (balls[i].gameEnd) {
        textSize(32);
        fill(0, 0, 0);
        text("You Lose", 130, 150);
        gameEnd = true;
        continue;
      }
      //bounce off of player barrier
      if (balls[i].bally <= 53) {
        if (balls[i].ballx < mouseX+40 && balls[i].ballx > mouseX-40) {
          balls[i].bally = 55;
          balls[i].direcy*=-1;
        }
      }
      //have a counter so I can increase the # of balls every 10 seconds
      counter++;
      if (counter > 600) {
        counter = 0;
        if (ballNumber < 4) {
          ballNumber++;
        }
      }
    }
  }
}



//Ball class
class Ball {
  int ballx = 200;
  int bally = 150;
  int speed = 1;
  float direcx = random(1, 4);
  float direcy = 5.0-direcx;
  boolean gameEnd = false;
  void update() {
    ballx+=direcx*speed;
    bally+=direcy*speed;
    fill(0,148,158);
    ellipse(ballx,bally,20,20);
  }
  void checkBounce() {
    //if at edge bounce and increase speed slightly
    if (ballx < 0) {
      direcx*=-1;
      speed+=0.02;
    }
    if (ballx >= 400) {
      direcx*=-1;
      speed+=0.02;
    }
    if (bally >= 300) {
      direcy*=-1;
      speed+=0.02;
    }
    //if at top edge end game
    if (bally <= 0) {
      gameEnd = true;
    }
  }
}
