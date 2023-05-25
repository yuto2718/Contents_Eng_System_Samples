import processing.serial.*;

Serial arduino;
final String portName = "COM5";
final int lf = 10;

float recvData = 0;
String tmp = null;

PFont  font;

final int black = 0;
final int white = 255;
final int coefficient  = 100;

final int bufferSize = 1024;
float buffer[];

void setup()
{
    surface.setResizable(true); 
    surface.setSize(640, 360);
    frameRate(60);
    smooth();

    font = createFont("Meiryo UI", 250);; 
    textFont(font, 18); 

    buffer = new float[bufferSize];

    for(int i = 0; i < bufferSize; i ++)
    {
        buffer[i] = 0;
    }

    println(Serial.list());
    arduino = new Serial(this, portName, 115200);
    arduino.bufferUntil(lf); 
}

void draw()
{
    background(black);
    text("received: " + nf(recvData, 4, 2), 10, 50);

    stroke(white);
    
    float diameter = abs(recvData*coefficient);

    ellipse(width/2, height/2, diameter, diameter);
}

void stop()
{
    arduino.stop();
    super.stop();
}

void serialEvent(Serial p) 
{
    recvData = float(p.readStringUntil(lf));
} 

void update(float data)
{
    for(int i = 0 ; i < bufferSize - 1; i ++)
    {
        buffer[i] = buffer[i + 1];
    }
    buffer[bufferSize - 1] = data;
}