const uint8_t uSensorPin[] = {0, 1, 2};     //使用するADCのピンを指定
const uint8_t uSensorNum = 3;               //使用するセンサの数を指定

const uint8_t uSizeRate = int(sizeof(uint16_t)/sizeof(uint8_t)); //１つのセンサのデータを何分割して送信するかを決定

const long baudRate = 115200;               //ボーレート Processing側とそろえる

union packet                                //パケット生成用の共用体 (メモリに対して16 bit*1個と8 bit*2個でアクセスできるようにする)
{
  uint16_t data;
  int8_t senddata[2];
};

union packet *pPackets;                     //パケット生成用の共用体の配列を保存するためのポインタ (ポインタはメモリ上のデータの場所のようなもの)

void setup()
{
  Serial.begin(baudRate);                   //シリアルポートを開く
  pPackets = malloc(sizeof(union packet) * uSensorNum);     //パケット生成，センサのデータ保存用のメモリ領域を確保し，場所をpPlacketsに記録
}

void loop()
{ 
  for(int i = 0; i < uSensorNum; i ++)
  {
    pPackets[i].data = analogRead(uSensorPin[i]);   //センサのデータを読み込み，データを16bitのデータとして保存
  }

  Serial.write("H");                                //ヘッダーを送信
  for(int i = 0; i < uSensorNum ; i ++ )            //センサの数だけ送信を繰り返す
  {
    for(int j = 0; j < uSizeRate; j ++ )            //データの分割数だけ送信を繰り返す
    {
      Serial.write(pPackets[i].senddata[j]);        //センサのデータを8 bitずつ読みだして，シリアル通信で送信する
    }
  }
  delay(10);
} 