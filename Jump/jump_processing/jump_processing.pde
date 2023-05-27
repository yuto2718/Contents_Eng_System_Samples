import processing.serial.*;
import processing.sound.*;

Serial arduino;
final String portName = "COM5";
final long baudrRate = 115200;
final int lf = 10;

SoundFile effectSound;

final int black = 0;
final int white = 255;

void setup()
{
    surface.setResizable(true);
    surface.setSize(640, 480);

    background(black);  
    frameRate(60);
    noStroke();
    
    effectSound = new SoundFile(this, "jump01.mp3");

    arduino = new Serial(this, portName, 115200);
    arduino.bufferUntil(lf);
}

void draw()
{
    
}

void serialEvent(Serial p)
{
    effectSound.play();
}