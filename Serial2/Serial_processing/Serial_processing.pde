import processing.serial.*;

Serial arduino;
final String portName = "COM5";
final int lf = 10;
final int hedder = int('H');

final int black = 0;
final int white = 255;
final int coefficient  = 100;

final int recvSensorNum = 6;
final int recvDataSize = recvSensorNum * 2;
int[] recvData;
byte[] recvRawData;

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
    arduino = new Serial(this, portName, 115200);

    recvData = new int[recvSensorNum];
    recvRawData = new byte[recvDataSize];
}

void draw()
{
    background(black);
    if(arduino.available() > recvDataSize)
    {
        tmp = arduino.read();
        if(tmp == hedder)
        {
            recvRawData = arduino.readBytes(recvDataSize);
        }
        arduino.clear();
    }
    recvData = decode(recvRawData, recvDataSize);

    for(int i = 0; i < recvSensorNum; i++)
    {
        text("Sensor "+ str(i) + " :" + str(recvData[i]), 10, 50*(i+1));
    }
}

void stop()
{
    arduino.stop();
    super.stop();
}

int[] decode(byte data[], int len)
{
    int[] value =  new int[int(len/2)];
    for(int i = 0; i < recvSensorNum; i ++)
    {
        value[i] = (int(data[2*i+1]) << 8) + Byte.toUnsignedInt((byte)data[2*i]);
    }
    return value;
}