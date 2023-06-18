import processing.serial.*;
import processing.sound.*;

Serial arduino;                 
final String portName = "COM5"; //Arduino書き込み時のポートと同じもの
final long baudrRate = 115200;  //ボーレート Arduinoとそろえる．
final int lf = 10;

SoundFile effectSound;

final int black = 0;            //黒色
final int white = 255;          //白色

void setup()
{
    surface.setResizable(true);
    surface.setSize(640, 480);

    background(black);  
    frameRate(60);
    noStroke();
    
    effectSound = new SoundFile(this, "jump01.mp3");//ジャンプ効果音の読み込み

    arduino = new Serial(this, portName, baudrRate);//シリアルポートを開く
    arduino.bufferUntil(lf);                        //改行文字読み込み時にシリアルイベントを発生させる．
}

void draw()
{
    //特に何もしない．
}

void serialEvent(Serial p)
{
    effectSound.play(); //イベントが発生したら音を鳴らす．文字を読み込んで，それによって処理を変えても面白いかもしれないですね．
}