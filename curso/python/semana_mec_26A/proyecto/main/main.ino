const int pinLuz = A0;
const int pinLM35 = A1;
const int pinPot = A2;
const int pinLED = 13;

void setup() {
  Serial.begin(9600);
  pinMode(pinLED, OUTPUT);
}

int leerTemperatura() {
  int adc = analogRead(pinLM35);
  return (adc * 500L) / 1023 - 32;
}

void loop() {
  int luz = analogRead(pinLuz);
  int temp = leerTemperatura();
  int ref = analogRead(pinPot);

  Serial.print("LUZ:");
  Serial.print(luz);
  Serial.print(",TEMP:");
  Serial.print(temp);
  Serial.print(",REF:");
  Serial.println(ref);

  if (Serial.available()) {
    String comando = Serial.readStringUntil('\n');
    comando.trim();

    if (comando == "LED_ON") {
      digitalWrite(pinLED, HIGH);
    } else {
      digitalWrite(pinLED, LOW);
    }
  }

  delay(500);
}
