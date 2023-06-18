import processing.serial.*;

Serial arduino;
final String portName = "COM5";         //Arduino書き込み時のポートと同じもの
final long baudRate = 115200;
final int lf = 10;                      //改行文字
final int hedder = int('H');            //ヘッダー

final int black = 0;                    //黒色
final int white = 255;                  //白色

final int recvSensorNum = 3;            //使用するセンサの数            
final int recvDataSize = recvSensorNum * 2;//ヘッダをのぞいたシリアル通信で受信するデータの大きさ  
int[] recvData;                         //受信したセンサのデータが保管される．センサの値を使いたいところにはこれを使用する．
byte[] recvRawData;                     //受信した生のデータが入ってる

PFont  font;

int tmp = 0;

void setup()
{
    surface.setResizable(true); 
    surface.setSize(640, 360);
    frameRate(60);
    smooth();

    font = createFont("Meiryo UI", 250);; 
    textFont(font, 18); 

    println(Serial.list());
    arduino = new Serial(this, portName, baudRate);       //シリアル通信のポートを開く
    recvData = new int[recvSensorNum];
    recvRawData = new byte[recvDataSize];
}

void draw()
{
    background(black);
    if(arduino.available() > recvDataSize)              //受信バッファにデータが届いているか確認
    {
        tmp = arduino.read();                           //1 byte読み込む
        if(tmp == hedder)                               //ヘッダと一致するか確認
        {
            recvRawData = arduino.readBytes(recvDataSize);  //センサの数分データを読み込む
            recvData = decode(recvRawData, recvDataSize);   //分割されたデータから，数値を復元
            arduino.clear();                                //送信バッファをクリアする
        }
    }

    for(int i = 0; i < recvSensorNum; i++)                  //描画
    {
        text("Sensor "+ str(i) + " :" + str(recvData[i]), 10, 50*(i+1));
    }
}

void stop()
{
    arduino.stop();
    super.stop();
}

int[] decode(byte data[], int len)                  //受信したデータを整数型に変換するデコーダ
{
    int[] value =  new int[int(len/2)];             //受信データ置き場
    for(int i = 0; i < recvSensorNum; i ++)
    {
        value[i] = (int(data[2*i+1]) << 8) + Byte.toUnsignedInt((byte)data[2*i]);  //分割したデータを結合
    }
    return value;
}