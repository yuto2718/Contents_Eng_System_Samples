#include <Wire.h>
#include <SparkFun_MMA8452Q.h>
#include <math.h>

MMA8452Q accel;

const int samples = 50;
float threshold = 1.0;

float ax;
float ay;
float az;

float a;
float pa;

void setup()
{
  Serial.begin(115200);
  accel.init(SCALE_8G, ODR_800);   //range 8g, dataRate 800Hz
}

void loop()
{
  if(accel.available())
  {
    ax = accel.getCalculatedX();
    ay = accel.getCalculatedY();
    az = accel.getCalculatedZ();
    a = sum_square(ax, ay, az);
    
    float da = pa - a;
    
    if(da * da > threshold)
    {
      for(int i = 0; i < samples; i ++)
      {
        Serial.print(accel.getCalculatedX());
        Serial.print(" ");
        Serial.print(accel.getCalculatedY());
        Serial.print(" ");
        Serial.println(accel.getCalculatedZ());
        delayMicroseconds(120);
      }
      ax = accel.getCalculatedX();
      ay = accel.getCalculatedY();
      az = accel.getCalculatedZ();
      pa = sum_square(ax, ay, az);
    }
    else
    {
      pa = a;
    }

  }
}


float sum_square(float x, float y, float z)
{
  return x*x + y*y + z*z;
}