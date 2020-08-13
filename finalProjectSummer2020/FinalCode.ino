int lightSensor = 0;
int potSensor = 0;
int resetButton = 0;

void setup() {
  // start serial port
  Serial.begin(9600);
  pinMode(4, INPUT);
}
void loop() {
  lightSensor = analogRead(A0);
  potSensor = analogRead(A1);
  resetButton = digitalRead(4);
  Serial.println(String(lightSensor) + " " + String(potSensor) + " " + String(resetButton));
  delay(100);
}
