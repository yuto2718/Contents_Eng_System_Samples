#include <Wire.h>
#include <SparkFun_MMA8452Q.h> //このライブラリを追加する
#include <math.h>

MMA8452Q accel;               //加速度センサの宣言

float JumpThreshold = 0.25;   //ジャンプしたとする閾値．これ以下になるとジャンプしたとする．
float StationaryThreshold = 0.1;// 静止しているとする閾値．１G ±この値の範囲に加速度がある時静止しているとする．
uint16_t StationaryDuration = 300; //静止継続時間

float ax;   //加速度 x-axis
float ay;   //加速度 y-axis
float az;   //加速度 z-axis

double a;   //合成加速度

uint8_t flag; //0:ジャンプ待機 1:ジャンプ検出 other:ジャンプ後の静止時間計測 StationaryDurationを超えると0へ

void setup()
{
  Serial.begin(115200);
  accel.init(SCALE_8G, ODR_800);   //計測レンジ 8G, センサの出力レート 800Hz
  flag = 0;                        //0:ジャンプ待機に設定
}

void loop()
{
  if(accel.available())           //センサからデータが取得できるか
  {
    ax = accel.getCalculatedX(); //X軸方向の加速度取得
    ay = accel.getCalculatedY(); //Y軸方向の加速度取得
    az = accel.getCalculatedZ(); //Z軸方向の加速度取得
    a = normL2(ax, ay, az);      //合成加速度の取得

    if(a < JumpThreshold)        //合成加速度が自由落下を示すか？
    {
      if(flag == 0)             //ジャンプ待機状態か
      {
        Serial.println("j");    //ジャンプしたことを送信
        flag ++;                //ジャンプ検出状態に遷移
      }
    }
    if(flag != 0 && abs(1.0 - a) < StationaryThreshold) //ジャンプ待機状態ではないかつ，静止しているか
    {
      flag ++;                                          //静止時間をカウントアップ
    }
    if(flag > StationaryDuration)                       //静止時間が閾値より長いか
    {
      flag = 0;                                         //ジャンプ待機状態に遷移
    }
  }
}

float normL2(float x, float y, float z) //ユークリッドノルム，L2ノルムの計算
{
  return sqrt(x*x + y*y + z*z);
}

