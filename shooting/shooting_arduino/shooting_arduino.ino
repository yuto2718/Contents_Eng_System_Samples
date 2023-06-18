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

  //送信トリガ信号を生成
  digitalWrite(trigPin, LOW); 
  delayMicroseconds(2); 
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10); 
  digitalWrite(trigPin, LOW);

  //センサから戻ってくるパルス幅を計測
  duration = pulseIn(echoPin, HIGH, 7000);

  //パルス幅から距離に変換し，ローパスフィルタを適用（2点のFIRフィルタ，特性は適当）
  distance = float(duration)/58.2 * 0.15 + pdistance * 0.85;
  pdistance = distance;

  //Processing側には0-50の値を送りたいのでクリッピング
  if(distance > 50.0)
  {
    distance = 50.0;
  }
  
  //送信
  Serial.println(distance);
}
