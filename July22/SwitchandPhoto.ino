void setup() {
  pinMode(8, OUTPUT);
  pinMode(13, OUTPUT);
  pinMode(A2, INPUT);
  pinMode(A3, INPUT);
  Serial.begin(9600);
}
boolean blinking = false;
unsigned long startTime = 0;
int len = 500;
int blinkNum = 0;
int currentLight = 1;
unsigned long currentTime;
void loop() {
  int switchPosition = digitalRead(A2);
  int photoPosition = analogRead(A3);
  if (blinking == true) {
    if(currentLight == 1) {
      digitalWrite(8,HIGH);
    }
    else {
      digitalWrite(8,LOW);
    }
    currentTime = millis();
    Serial.println(currentTime);
    Serial.println(currentLight);
    if (currentTime-startTime >= len) {
      if(currentLight == 0) {
        currentLight = 1;
        startTime = currentTime;
        blinkNum++;
      }
      else {
        startTime = currentTime;
        currentLight = 0;
      }
    }
    if (blinkNum == 3) {
      blinkNum = 0;
      blinking = false;
    }
  }
  else if (switchPosition == HIGH) {
    blinking = true;
    startTime = millis();
  }
  int y = map(photoPosition,200,1100,255,0);
  Serial.println(y);
  analogWrite(11, y);
}
