const int analogPin = 0;        //使用するセンサを接続したピン番号
const long baudRate = 115200;   //ボーレート Processingとそろえる

void setup()
{
    Serial.begin(baudRate);     //シリアル通信開始
}

void loop()
{
    int sensorValue = analogRead(analogPin);    //センサからデータを取得
    Serial.println(sensorValue);                //センサのデータを文字列として送信
    delay(10);
}