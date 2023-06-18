#include <Servo.h>

Servo servo;

const uint8_t servoPin = 12;          //サーボモータを接続したピン番号
const uint8_t obstacleSensorPin = 0;  //障害物検出用の光センサを接続したピン番号
const uint8_t backgroundSensorPin = 1;//背景の明るさを検出する光センサを接続したピン番号

const uint32_t baudRate = 115200;     //ボーレート Arduinoとそろえる

uint16_t uObstacleSensorValue = 0;    //障害物検出するセンサの値
uint16_t uBackgroundSensorValue = 0;  //背景のセンサの値

uint16_t uDaytimeObstacleThrethold = 25;//昼間，明るい状態の障害物検出の閾値
uint16_t uNigthObstacleThrethold = 10;  //夜間，暗い状態の障害物検出の閾値
uint16_t uDaytimeThrethold = 400;       //昼夜を判定する閾値

void setup() 
{
  servo.attach(servoPin);               //サーボモータのピンを設定
  servo.writeMicroseconds(2000);        //サーボモータにパルス幅20 msのPWMを出力 バーは上がった状態

  Serial.begin(baudRate);
}

void loop() 
{
  uObstacleSensorValue = analogRead(obstacleSensorPin);    //障害物検出するセンサの値を取得
  uBackgroundSensorValue = analogRead(backgroundSensorPin);//拝啓のセンサの値を取得
  
  //シリアル通信でデバッグ用
  Serial.print(uObstacleSensorValue);
  Serial.print(" ");
  Serial.println(uBackgroundSensorValue);

  if(uObstacleSensorValue < uDaytimeObstacleThrethold && uBackgroundSensorValue > uDaytimeThrethold )
  //昼間に障害物が前に存在するか
  {
    pushSpaceBar(); //スペースバーを押す
  }
  if(uObstacleSensorValue > uNigthObstacleThrethold && uBackgroundSensorValue < uDaytimeThrethold )
  //夜間に障害物が前に存在するか
  {
    pushSpaceBar(); //スペースバーを押す
  }
}

inline void pushSpaceBar(void)  //スペースバーを押す関数
{ 
  servo.writeMicroseconds(1100);  //押し下げる
  delay(200);                     //維持
  servo.writeMicroseconds(1300);  //戻す
}