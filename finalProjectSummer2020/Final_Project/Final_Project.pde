import processing.serial.*;
import processing.sound.*;
Serial myPort;
//values holding the lighting and angle of tree growth
float lighting;
float angle;

//values holding the current x and y location of the tree
float xLocation = 250;
float yLocation = 800;
int prevLeaf = 800;
//current tree width
int currentWidth = 100;
//birds saved so far
int birdsSaved = 0;
int widthNum = 0;
//images of the leaf
PImage bambooLeafRight;
PImage bambooLeafLeft;
//array of the tree
treePart[] trees = new treePart[4000];
//number of rectangles making up tree
int treeNum = 0;

//bird and birdNest image
PImage[] bird = new PImage[2];
PImage birdNest;
//bird picture program is on rn (out of two)
int birdPicture = 0;
//bird location
int birdx = int(random(0, 350));
int birdy = 0;
int birdTimer = 0;
int delay = 0;

//grass and sun images
PImage grass;
PImage sun;
//background music
SoundFile background;
boolean reset = false;
boolean resetButton = false;
void setup() {
  size(500, 800);
  //connect to arduino
  myPort = new Serial(this, Serial.list()[3], 9600);
  myPort.bufferUntil('\n');
  //load images and soundfiles
  bambooLeafRight = loadImage("BambooLeaf.png");
  bambooLeafLeft = loadImage("BambooLeafLeft.png");
  background = new SoundFile(this, "Background.mp3");
  sun = loadImage("Sun.png");
  grass = loadImage("grass.png");
  bird[0] = loadImage("Bird1.png");
  bird[1] = loadImage("Bird2.png");
  birdNest = loadImage("BirdNest2.png");
  //create the tree objects for future use
  for (int i = 0; i < trees.length; i++) {
    trees[i] = new treePart();
  }
  delay(1000);
  background.play();
}
void draw() {
  //if reseting
  if (resetButton) {
    //print game ending text
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
    //check if restart button has been pressed
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
    //reset all variables
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
    //take in the input as a string
    if (myPort.available() > 0) {
      String inString = myPort.readStringUntil('\n');
      if (inString != null) {
        // trim off any whitespace:
        inString = trim(inString);
        //split the string into its 3 values
        int[] val = int(split(inString, ' '));
        lighting = float(val[0]);
        //map the photoresistor from 100 to 255 for color
        lighting = map(lighting, 0, 1023, 100, 255);
        angle = 0;
        //Stops an error where arduino only sends one value
        if (val.length > 1) {
          angle = int(val[1]);
          //map the potentiometer to -5 to 5
          angle = map(angle, 0, 1023, -5, 5);
        }
      }
    }
    //draw the background based on the photoresistor value
    background(0, 0, lighting);
    //draw the sun
    image(sun,25,25,100,100);
    //color for the tree
    stroke(74, 44, 42);
    fill(74, 44, 42);
    //map photoresistor to growth speed
    float growthSpeed = map(lighting, 100, 255, 0.5, 1.25);
    //move the tree based on sensors
    yLocation-=growthSpeed;
    xLocation+=angle;
    //used so the tree always ends on a point from starting width of 100
    trees[treeNum].currentWidth = 100*(yLocation/800);
    trees[treeNum].x = xLocation;
    trees[treeNum].y = yLocation;
    trees[treeNum].tall = growthSpeed;
    //stop tree from going over edge of screen
    if (trees[treeNum].x+trees[treeNum].currentWidth > 500) {
      trees[treeNum].x = 500-trees[treeNum].currentWidth;
      xLocation = int(trees[treeNum].x);
    }
    //stop tree from going over edge of screen
    if (trees[treeNum].x < 0) {
      trees[treeNum].x = 0;
      xLocation = int(trees[treeNum].x);
    }
    //every 50 add in a leaf on a random side
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
    //For each tree object...
    for (int i = 0; i < treeNum; i++) {
      //if they have a right leaf print it
      if (trees[i].hasleaf && trees[i].side) {
        image(bambooLeafRight, trees[i].x+trees[i].currentWidth, trees[i].y-55, 100, 55);
      //print tree left leaf print it
      } else if (trees[i].hasleaf && !trees[i].side) {
        image(bambooLeafLeft, trees[i].x-100, trees[i].y-55, 80, 55);
      }
      //print the actual tree
      trees[i].update();
    }
    //print the nest (added later so it would show on top of the tree
    for (int i = 0; i < treeNum; i++) {
      if (trees[i].hasNest) {
        //image(birdNest, trees[i].x+trees[i].currentWidth/2, trees[i].y-80, 100, 80);
        image(birdNest, trees[i].nestx, trees[i].nesty, 100, 80);
      }
    }
    //print the grass (so it would be on top of the tree)
    image(grass,0,720,500,80);
    //if reached top, reset game
    if (yLocation < 0) {
      resetButton = true;
    //if next bird delay is there subtract 1
    } else if (delay > 0) {
      delay--;
    //otherwise draw the bird
    } else {
      image(bird[birdPicture], birdx, birdy, 80, 80);
      birdy++;
      //every 20 frames change bird picture to show flapping
      if (birdTimer == 20) {
        if (birdPicture == 1) {
          birdPicture = 0;
        } else {
          birdPicture++;
        }
        birdTimer = 0;
      }
      //for every tree object...
      for (int i = 0; i < treeNum; i++) {
        //check if bird is touching a tree object
        if (birdx+80 > trees[i].x && birdx < trees[i].x + trees[i].currentWidth) {
          if (birdy+80 >= trees[i].y && birdy <= trees[i].y+trees[i].tall) {
            birdsSaved++;
            //add nest to tree
            trees[i].hasNest = true;
            trees[i].nestx = birdx;
            trees[i].nesty = birdy;
            //reset bird variables
            birdTimer = 0;
            birdPicture = 0;
            birdx = int(random(0, 350));
            birdy = 0;
            //add 100 milisecond delay for new bird
            delay = 100;
            break;
          }
        }
      }
      birdTimer++;
    }
  }
}
