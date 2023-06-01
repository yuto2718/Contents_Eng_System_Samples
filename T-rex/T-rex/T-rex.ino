#include <Servo.h>

Servo servo;

const uint8_t servoPin = 12;
const uint8_t obstacleSensorPin = 0;
const uint8_t backgroundSensorPin = 1;

const uint32_t baudRate = 115200;

uint16_t uObstacleSensorValue = 0;
uint16_t uBackgroundSensorValue = 0;

uint16_t uDaytimeObstacleThrethold = 25;
uint16_t uNigthObstacleThrethold = 10;
uint16_t uDaytimeThrethold = 400;

void setup() 
{
  servo.attach(servoPin);
  servo.writeMicroseconds(2000);

  Serial.begin(baudRate);
}

void loop() 
{
  uObstacleSensorValue = analogRead(obstacleSensorPin);
  uBackgroundSensorValue = analogRead(backgroundSensorPin);
  Serial.print(uObstacleSensorValue);
  Serial.print(" ");
  Serial.println(uBackgroundSensorValue);

  if(uObstacleSensorValue < uDaytimeObstacleThrethold && uBackgroundSensorValue > uDaytimeThrethold )
  {
    pushSpaceBar();
  }
  if(uObstacleSensorValue > uNigthObstacleThrethold && uBackgroundSensorValue < uDaytimeThrethold )
  {
    pushSpaceBar();
  }
}

inline void pushSpaceBar(void)
{ 
  servo.writeMicroseconds(1100);
  delay(200);
  servo.writeMicroseconds(1300);
}