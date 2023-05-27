#include <Wire.h>
#include <SparkFun_MMA8452Q.h>
#include <math.h>

MMA8452Q accel;

float JumpThreshold = 0.25;
float StationaryThreshold = 0.1;

float ax;
float ay;
float az;

double a;

uint8_t flag;

void setup()
{
  Serial.begin(115200);
  accel.init(SCALE_8G, ODR_800);   //range 8G, dataRate 800Hz
  flag = 0;
}

void loop()
{
  if(accel.available())
  {
    ax = accel.getCalculatedX();
    ay = accel.getCalculatedY();
    az = accel.getCalculatedZ();
    a = normL2(ax, ay, az);

    if(a < JumpThreshold)
    {
      if(flag == 0)
      {
        Serial.println("j");
        flag ++;
      }
    }
    if(flag != 0 && abs(0.98 - a) < StationaryThreshold)
    {
      flag ++;
    }
    if(flag > 300)
    {
      flag = 0;
    }
  }
  //delay(10);
}


float normL2(float x, float y, float z)
{
  return sqrt(x*x + y*y + z*z);
}

