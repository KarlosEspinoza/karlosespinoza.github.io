const int SENSOR_PIN = A2;

void setup() {
  pinMode(SENSOR_PIN, INPUT);
  Serial.begin(9600);
}

void loop() {
  int valor = analogRead(SENSOR_PIN);

  Serial.println(valor);

  delay(200);
}
