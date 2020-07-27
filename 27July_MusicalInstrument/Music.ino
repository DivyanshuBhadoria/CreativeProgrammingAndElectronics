#include <Servo.h>
//Servo Motor
Servo myServo;
//if currently spinning servo
bool spin = false;
//if currently spinning servo back
bool fallBack = false;
//if music is playing
bool playing = false;
//how long the music has been playing
long timePlaying = 0;
int pos = 0;
void setup() {
  //Set up input and output
  pinMode(9, OUTPUT);
  pinMode(A1, INPUT);
  pinMode(A2, INPUT);
  pinMode(A3, INPUT);
  pinMode(A4, INPUT);
  myServo.attach(11);
  myServo.write(0);
  delay(1000);
  Serial.begin(9600);
}
void loop() {
  int servoControl = digitalRead(A2);
  int noteOne = digitalRead(A3);
  int noteTwo = digitalRead(A4);
  int frequency = analogRead(A1);
  int angle = 90;
  if (playing == true) {
    //Check if 500 milliseconds have passed
    if(millis() - timePlaying >= 500) {
      //stop playing music
      playing = false;
      noTone(9);
    }
  }
  //Check if button one is pressed
  else if (noteOne == HIGH) {
    //play music based on potentiometer value
    int toneValue = map(frequency, 0, 1023, 150,250);
    tone(9,toneValue,500);
    timePlaying = millis();
    playing = true;
  }
  //Check if button two is pressed
  else if (noteTwo == HIGH) {
    //play music based on potentiometer value
    int toneValue = map(frequency, 0, 1023, 850,1050);
    tone(9,toneValue,500);
    timePlaying = millis();
    playing = true;
  }
  //Check if button to spin pressed
  if(servoControl == HIGH) {
    spin = true;
  }
  //Check if spinning
  if (spin == true) {
    //move servo by 1 degree
    pos++;
    myServo.write(pos);
    if (pos >= 90) {
      spin = false;
      fallBack = true;
    }
  }
  //Check if moving servo back
  if (fallBack == true) {
    //move servo back by 1 degree
    pos--;
    myServo.write(pos);
    if (pos <= 0) {
      fallBack = false;
    }
  }
}
