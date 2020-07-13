void setup() {
  size(400, 400);
}
int x = 0;
int y = 0;
boolean raining = false;
boolean rippling = false;
int down = 0;
int rippleSize = 1;
void draw() {
  //Draw the Background
  stroke(0, 128, 255);
  fill(0, 128, 255);
  rect(0, 250, 400, 150);
  fill(0, 0, 128);
  stroke(0, 0, 128);
  rect(0, 0, 400, 250);
  stroke(255, 255, 255);
  fill(255, 255, 255);
  ellipse(350,50,50,50);
  //Draw the stars
  int move = 0; //How much each new row moves to the right
  for(int i = -105; i < 150; i+=20) {
    for(int j = -177+move; j < 800; j+=20) {
      rect(j,i,1,1);
    }
    move+=10;
  }
  //Draw the cloud and keep it at mouse location
  ellipse(mouseX+5, 70, 30, 30);
  ellipse(mouseX, 90, 80, 45);
  ellipse(mouseX-30, 105, 40, 30);
  ellipse(mouseX+30, 105, 40, 30);
  ellipse(mouseX-5, 105, 30, 30);
  //Start the rain
  if (mousePressed) {
    raining = true;
    x = mouseX;
  }
  //rain
  if (raining == true) {
    waterDrop();
    down+=2;
  }
  //End the rain
  if (down == 170) {
    down = 0;
    raining = false;
    rippling = true;
  }
  //Start the ripple
  if (rippling == true) {
    rippleSize+=1;
    ripple();
  }
  //End the ripple
  if (rippleSize == 33) {
    rippleSize = 1;
    rippling = false;
  }
}
//Create a Drop Function
void waterDrop() {
  stroke(126,249,255);
  fill(126,249,255);
  translate(0,down);
  triangle(x-5,140,x+5,140,x,130);
  arc(x, 140, 10, 10, 0, radians(180));
}
//Create a Ripple Function
void ripple() {
  stroke(126,249,255);
  fill(126,249,255);
  ellipse(x,310,10+rippleSize,10+rippleSize);
  stroke(0, 128, 255);
  fill(0, 128, 255);
  ellipse(x,310,3+rippleSize,3+rippleSize);
}
