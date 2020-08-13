import processing.serial.*;
import processing.sound.*;
Serial myPort;
float lighting;
float angle;

float xLocation = 250;
float yLocation = 800;
int prevLeaf = 800;
int currentWidth = 100;
int birdsSaved = 0;
int widthNum = 0;
PImage bambooLeafRight;
PImage bambooLeafLeft;
treePart[] trees = new treePart[4000];
int treeNum = 0;

PImage[] bird = new PImage[2];
PImage birdNest;
int birdPicture = 0;
int birdx = int(random(0, 350));
int birdy = 0;
int birdTimer = 0;
int delay = 0;

PImage grass;
PImage sun;
SoundFile background;
boolean reset = false;
boolean resetButton = false;
void setup() {
  size(500, 800);
  myPort = new Serial(this, Serial.list()[3], 9600);
  myPort.bufferUntil('\n');
  bambooLeafRight = loadImage("BambooLeaf.png");
  bambooLeafLeft = loadImage("BambooLeafLeft.png");
  background = new SoundFile(this, "Background.mp3");
  sun = loadImage("Sun.png");
  grass = loadImage("grass.png");
  bird[0] = loadImage("Bird1.png");
  bird[1] = loadImage("Bird2.png");
  birdNest = loadImage("BirdNest2.png");
  for (int i = 0; i < trees.length; i++) {
    trees[i] = new treePart();
  }
  delay(1000);
  background.play();
}
void draw() {
  if (resetButton) {
    fill(255, 255, 255);
    textSize(30);
    text("Click to Restart", 150, 380);
    String savedBirds = "";
    if (birdsSaved > 1) {
      savedBirds = "You Saved " + str(birdsSaved) + " Birds!";
    }
    else if(birdsSaved == 1) { 
      savedBirds = "You Saved 1 Bird!";
    }
    else {
      savedBirds = "You Saved 0 Birds :(";
    }
    text(savedBirds, 120,320);
    if (myPort.available() > 0) {
      String inString = myPort.readStringUntil('\n');
      if (inString != null) {
        // trim off any whitespace:
        inString = trim(inString);
        println(inString);
        int[] val = int(split(inString, ' '));
        if (val[2] == 1) {
          reset = true;
          resetButton = false;
        }
      }
    }
  }
  else if (reset) {
    xLocation = 250;
    yLocation = 800;
    prevLeaf = 800;
    currentWidth = 100;
    widthNum = 0;
    treeNum = 0;
    birdsSaved = 0;
    for (int i = 0; i < trees.length; i++) {
      trees[i] = new treePart();
    }
    birdPicture = 0;
    birdx = int(random(0, 350));
    birdy = 0;
    birdTimer = 0;
    delay = 0;
    reset = false;
  } else {
    if (myPort.available() > 0) {
      String inString = myPort.readStringUntil('\n');
      if (inString != null) {
        // trim off any whitespace:
        inString = trim(inString);
        int[] val = int(split(inString, ' '));
        lighting = float(val[0]);
        lighting = map(lighting, 0, 1023, 100, 255);
        angle = 0;
        println(inString);
        println(val[0]);
        //println(val[1]);
        //println(val[2]);
        if (val.length > 1) {
          angle = int(val[1]);
          angle = map(angle, 0, 1023, -5, 5);
          println(val[1]);
        //println(val[2]);
        }
        //println(angle);
        //println(lighting);
      }
    }
    background(0, 0, lighting);
    image(sun,25,25,100,100);
    //image(grass,0,720,500,80);
    stroke(74, 44, 42);
    fill(74, 44, 42);
    float growthSpeed = map(lighting, 100, 255, 0.5, 1.25);
    yLocation-=growthSpeed;
    xLocation+=angle;
    trees[treeNum].currentWidth = 100*(yLocation/800);
    trees[treeNum].x = xLocation;
    trees[treeNum].y = yLocation;
    trees[treeNum].tall = growthSpeed;
    if (trees[treeNum].x+trees[treeNum].currentWidth > 500) {
      trees[treeNum].x = 500-trees[treeNum].currentWidth;
      xLocation = int(trees[treeNum].x);
    }
    if (trees[treeNum].x < 0) {
      trees[treeNum].x = 0;
      xLocation = int(trees[treeNum].x);
    }
    //if (prevLeaf-yLocation >= 80 && yLocation < 500) {
    if(widthNum >= 50 && yLocation < 500) {
      trees[treeNum].hasleaf = true;
      int side = int(random(2));
      if (side == 0) {
        trees[treeNum].side = false;
      }
      if (side == 1) {
        trees[treeNum].side = true;
      }
      prevLeaf = int(yLocation);
      widthNum = 0;
    }
    widthNum++;
    treeNum++;
    for (int i = 0; i < treeNum; i++) {
      if (trees[i].hasleaf && trees[i].side) {
        image(bambooLeafRight, trees[i].x+trees[i].currentWidth, trees[i].y-55, 100, 55);
      } else if (trees[i].hasleaf && !trees[i].side) {
        image(bambooLeafLeft, trees[i].x-100, trees[i].y-55, 80, 55);
      }
      //if (trees[i].hasNest) {
      //  image(birdNest, trees[i].x+trees[i].currentWidth/2, trees[i].y-80, 100, 80);
      //}
      trees[i].update();
      //if (trees[i].hasNest) {
      //  //image(birdNest, trees[i].x+trees[i].currentWidth/2, trees[i].y-80, 100, 80);
      //  image(birdNest, trees[i].nestx, trees[i].nesty, 100, 80);
      //}
    }
    for (int i = 0; i < treeNum; i++) {
      if (trees[i].hasNest) {
        //image(birdNest, trees[i].x+trees[i].currentWidth/2, trees[i].y-80, 100, 80);
        image(birdNest, trees[i].nestx, trees[i].nesty, 100, 80);
      }
    }
    image(grass,0,720,500,80);
    if (yLocation < 0) {
      resetButton = true;
    } else if (delay > 0) {
      delay--;
    } else {
      image(bird[birdPicture], birdx, birdy, 80, 80);
      birdy++;
      if (birdTimer == 20) {
        if (birdPicture == 1) {
          birdPicture = 0;
        } else {
          birdPicture++;
        }
        birdTimer = 0;
      }
      for (int i = 0; i < treeNum; i++) {
        if (birdx+80 > trees[i].x && birdx < trees[i].x + trees[i].currentWidth) {
          if (birdy+80 >= trees[i].y && birdy <= trees[i].y+trees[i].tall) {
            print("hi");
            birdsSaved++;
            trees[i].hasNest = true;
            trees[i].nestx = birdx;
            trees[i].nesty = birdy;
            birdTimer = 0;
            birdPicture = 0;
            birdx = int(random(0, 350));
            birdy = 0;
            delay = 100;
            break;
          }
        }
      }
      birdTimer++;
    }
  }
}
