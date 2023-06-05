const uint8_t echoPin = 10;
const uint8_t trigPin = 11;

int32_t duration;
float distance, pdistance = 0;

void setup() {
  Serial.begin (115200);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
}

void loop() {

  digitalWrite(trigPin, LOW); 
  delayMicroseconds(2); 

  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10); 
  digitalWrite(trigPin, LOW);

  duration = pulseIn(echoPin, HIGH, 7000);
  distance = float(duration)/58.2 * 0.15 + pdistance * 0.85;
  pdistance = distance;
  if(distance > 50.0)
  {
    distance = 50.0;
  }
  Serial.println(distance);
}
