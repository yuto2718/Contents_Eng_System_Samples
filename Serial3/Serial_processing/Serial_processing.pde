import processing.serial.*;

Serial arduino;
final String portName = "COM5"; //Arduino書き込み時のポートと同じものを指定

final int black = 0;            //黒色
final int white = 255;          //白色

PFont  font;                    //フォント
Button button;                  //ボタンクラス

class Button                    //ボタンクラスを定義
{
    float x, y;                 //表示位置
    float sizeX;                //ボタンサイズ x軸方向
    float sizeY;                //ボタンサイズ y軸方向

    protected color baseColor;  //表示色

    private float normalBrightness; //通常時のボタンの明るさ
    private float selsectBrightness;//カーソルが上に乗った時のボタンの明るさ
    private float pushedBrightness; //押し込まれた時のボタンの明るさ

    private String str[];           //ボタン内部に表示する文字
    private int state;              //ボタンの状態を示す変数

    Button(float x, float y, float sizeX, float sizeY, color baseColor)//コンストラクタ
    {
        this.x = x;
        this.y = y;
        this.sizeX = sizeX;
        this.sizeY = sizeY;
        
        this.baseColor = baseColor;
        this.state = 0;

        this.str = new String[3];
        this.str[0] = "OFF";
        this.str[1] = "OFF";
        this.str[2] = "ON";
        
        normalBrightness = 0.7;
        selsectBrightness = 0.78;
        pushedBrightness = 1.0;
    }
    
    void update()           //update メソッド これを毎回メインのdraw関数の中で実行する
    {
        this.updateState(); //スイッチの状態を確認
        this.draw();        //描画
    }

    protected void draw() //ボタンの描画処理
    {
        rectMode(CENTER);               //指定する座標が図形の中心になるように設定
        colorMode(HSB, 360, 100, 100);  //HSB色空間を指定
        textAlign(CENTER, CENTER);      //中心揃え

        noStroke();
        changeColor();                  //色変更メソッドの呼び出し

        rect(x, y, sizeX, sizeY, 20);   //ボタン本体の描画

        fill(0, 0, 100);
        textSize(30);
        text(str[state], x, y-5);       //文字を描画
    }

    boolean isPush()                    //ボタンが押されたかを戻すメソッド これを確認して使用する．
    {
        if(state == 2)
        {
            return true;
        }
        return false;
    }

    protected boolean isInside()        //ボタン内部にマウスカーソルが存在するか確認するメソッド
    {
        if (mouseX > x-sizeX/2 && mouseX < x+sizeX/2) //X座標の評価
        {
            if (mouseY>y-sizeY/2 && mouseY<y+sizeY/2) //Y座標の評価
            {
                return true;
            }
        }
        return false;
    }

    protected void updateState()//ステートを更新するメソッド
    {
        state = checkState();   //ステートを確認するメソッドを呼び出して，state変数を更新
    }

    private int checkState()//ステートの確認
    {
        if(!isInside())     //マウスが内部にない
        {
            return 0;       //state : 0 マウスがボタンの上にない
        }
        if(!mousePressed)
        {
            return 1;       //state : 1 マウスがボタン上にあるが押されていない．
        }
        return 2;           //state : 2 ボタンが押された．
    }

    protected void changeColor()//色を変更
    {
        switch (state) 
        {
            case 0://state : 1 マウスがボタン上にあるが押されていない ボタンを通常の明るさに
                fill(hue(baseColor), saturation(baseColor), brightness(baseColor)*normalBrightness);
                break;

            case 1://state : 0 マウスがボタンの上にない ボタンをハイライトする
                fill(hue(baseColor), saturation(baseColor), brightness(baseColor)*selsectBrightness);
                break;

            case 2://state : 2 ボタンが押された ボタンをさらに明るくする
                fill(hue(baseColor), saturation(baseColor), brightness(baseColor)*pushedBrightness);
                break;

            default:
                fill(0, 0, 0);
                break;
        }
    }
}

void setup()
{
    surface.setResizable(true); 
    surface.setSize(640, 360);
    frameRate(60);
    smooth();

    rectMode(CENTER);               //指定する座標が図形の中心になるように設定
    colorMode(HSB, 360, 100, 100);  //HSB色空間を指定
    textAlign(CENTER, CENTER);      //中心揃え

    arduino = new Serial(this, portName, 115200);   //Arduinoのポートを開く

    button = new Button(width/2, height/2, 200, 100, color(25, 95, 100)); //ボタンのインスタンス生成
}

void draw()
{
    background(white);  
    button.update();        //ボタンのアップデート処理
    
    if(button.isPush())     //ボタンが押されたか
    {
        arduino.write('H'); //'H'を送信　（ArduinoはHを受け取るとLED点灯）
    }
    else 
    {
        arduino.write('L'); //'L'を送信　（ArduinoはLを受け取るとLED消灯）
    }
}

void stop()
{
    arduino.stop();
    super.stop();
}
```

Arduinoで受信してLEDを光らせるプログラムは以下の通りです．

```C++
const uint8_t LED = 13;             //内蔵LEDの番号
const long baudRate = 115200;       //ボーレート Processsingとそろえる

char LEDState= 0;                   //LEDの状態を保持する
char recvData = 0;                  //受信したデータを保存

void setup()
{
  Serial.begin(baudRate);           //Serial通信開始
  pinMode(LED, OUTPUT);             //LEDが接続されているピンを出力に設定
}

void loop()
{
  if(Serial.available() > 0)        //受信できるデータがあったら
  {
    recvData = (char)Serial.read(); //1文字読み込み
    if(recvData == 'H')             //'H'が送られてきたら，点灯に設定
    {
      LEDState = HIGH;
    }
    else if(recvData == 'L')        //'L'が送られてきたら，消灯に設定
    {
      LEDState = LOW;
    }
    bufferClear();                  //受信バッファに入っているデータをクリア
  }
  digitalWrite(LED, LEDState);      //設定を反映
  delay(10);
}

void bufferClear()                  //受信バッファをクリアする関数
{
  while(Serial.available())
  {
    Serial.read();
  }
}