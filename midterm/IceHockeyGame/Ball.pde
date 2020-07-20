//Ball class
class Ball {
  //Initialize location and direction
  int ballx = 200;
  int bally = 150;
  float direcx = random(1, 4);
  float direcy = 5.0-direcx;
  boolean gameEnd = false;
  //create index color variable
  int colors = 0;
  int colorCounter = 0;
  color colorValue = color(148,0, 211);
  void update() {
    //Update location of ball
    ballx+=direcx;
    bally+=direcy;
    fill(colorValue);
    ellipse(ballx,bally,20,20);
  }
  void checkBounce() {
    //if at edge bounce
    if (ballx < 10) {
      ballx = 11;
      direcx*=-1;
    }
    if (ballx >= 390) {
      ballx = 389;
      direcx*=-1;
    }
    if (bally >= 290) {
      bally = 289;
      direcy*=-1;
    }
    //if at top edge end game
    if (bally <= 10) {
      bally = 11;
      gameEnd = true;
    }
  }
}
