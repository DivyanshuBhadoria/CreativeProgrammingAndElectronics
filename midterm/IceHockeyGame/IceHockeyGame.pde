import processing.sound.*;
//is this the first game
boolean firstTry = true;
//number of balls ingame
int ballNumber = 1;
final int size = 7;
//Arrays holding the ball and box objects
Ball[] balls = new Ball[size];
Box[] boxes = new Box[6];
//Count frames since game started
int counter = 0;
//Holds if game has ended or not
boolean gameEnd = false;
//Game ending text
String text = "";
//Number of boxes
int boxNum = 6;
//Coordinates of boxes
int[] boxCoordinates = {0, 280, 67, 280, 134, 280, 201, 280, 268, 280, 335, 280};
color[] boxColors = {color(148, 0, 211), color(153, 51, 102), color(51, 204, 204), color(0, 255, 0), color(255, 127, 0), color(255, 0, 0)};
//Number of boxes the player has beaten
int boxesBeat = 0;
SoundFile bounceSound;
SoundFile swoosh;
//If the player clicked restart
boolean restart = false;
void setup() {
  size(400, 300);
  //Initialize variables in arrays
  for (int i = 0; i < balls.length; i++) {
    balls[i] = new Ball();
  }
  for (int i = 0; i < boxes.length; i++) {
    boxes[i] = new Box();
    boxes[i].x = boxCoordinates[i*2];
    boxes[i].y = boxCoordinates[i*2+1];
    boxes[i].z = boxColors[i];
  }
  //Initialize the soundfiles
  bounceSound = new SoundFile(this, "Spring-Boing.mp3");
  swoosh = new SoundFile(this, "Swoosh 1-SoundBible.com-231145780.wav");
}
void draw() {
  //Check if player has won or lost
  if (gameEnd) {
    textSize(32);
    fill(0, 0, 0);
    text(text, 130, 120);
    textSize(20);
    text("Click to Restart", 130, 180);
    if (mousePressed) {
      //Start the restart
      restart = true;
      gameEnd = false;
    }
    //Restart the game (Reinitialize all variables)
  } else if (restart) {
    for (int i = 0; i < boxNum; i++) {
      boxes[i].appears = true;
    }
    for (int i = 0; i < ballNumber; i++) {
      balls[i].ballx = 200;
      balls[i].bally = 150;
      balls[i].direcx = random(1, 4);
      balls[i].direcy = 5.0-balls[i].direcx;
      balls[i].gameEnd = false;
    }
    boxesBeat = 0;
    counter = 0;
    ballNumber = 1;
    restart = false;
  } else {
    //Create background and pucks
    fill(255, 208, 141);
    stroke(255, 208, 141);
    rect(0, 0, 400, 400);
    stroke(0, 0, 0);
    fill(237, 0, 38);
    //barrier player conrols
    rect(mouseX-40, 15, 80, 20, 5);
    //Print Bottom Rectangles
    for (int i = 0; i < boxNum; i++) {
      boxes[i].update();
    }
    //Give instructions if first try
    if (firstTry) {
      textSize(20);
      fill(0, 0, 0);
      text("Welcome to Bouncy Balls", 90, 60);
      text("Move your mouse to control the puck", 20, 90);
      text("Keep the ball from touching the roof", 20, 120);
      text("Remove all the blocks", 95, 150);
      text("Click to Start", 130, 180);
      if (mousePressed) {
        firstTry = false;
      }
    } else {
      for (int i = 0; i < ballNumber; i++) {
        //Check if player has removed all the boxes
        if (boxesBeat==boxNum) {
          textSize(32);
          fill(0, 0, 0);
          text("You Win!", 130, 120);
          gameEnd = true;
          text = "You Win!";
          continue;
        }
        //update and check if ball needs to bounce for all balls in-game
        balls[i].update();
        balls[i].checkBounce();
        //Check if game is over
        if (balls[i].gameEnd) {
          textSize(32);
          fill(0, 0, 0);
          text("You Lose", 130, 120);
          gameEnd = true;
          text = "You Lose";
          continue;
        }
        //bounce off of player barrier
        if (balls[i].bally-10 <= 35) {
          if (balls[i].ballx < mouseX+40 && balls[i].ballx > mouseX-40) {
            balls[i].bally = 46;
            balls[i].direcy*=-1;
            bounceSound.play();
          }
        }
        //Check if ball has hit a box (if it has remove the box)
        for (int j = 0; j < boxNum; j++) {
          if (boxes[j].appears && balls[i].bally+10 >= boxes[j].y) {
            if (balls[i].ballx-10 <= boxes[j].x+65 && balls[i].ballx+10 >= boxes[j].x) {
              balls[i].direcy*=-1;
              boxes[j].appears = false;
              swoosh.play();
              boxesBeat++;
            }
          }
        }
        //have a counter so I can increase the # of balls every 7 seconds
        counter++;
        if (counter > 400) {
          counter = 0;
          if (ballNumber < 4) {
            ballNumber++;
          }
        }
      }
    }
  }
}
