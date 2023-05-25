const uint8_t uSensorPin[] = {0, 1,2,3,4,5};
const uint8_t uSensorNum = 6;

const uint8_t uSizeRate = int(sizeof(uint16_t)/sizeof(uint8_t));

const long baudRate = 115200;

union packet
{
  uint16_t data;
  int8_t senddata[2];
};

union packet *pPackets;

void setup()
{
  Serial.begin(baudRate);
  pPackets = malloc(sizeof(union packet) * uSensorNum);
  Serial.println(uSizeRate);
}

void loop()
{ 
  for(int i = 0; i < uSensorNum; i ++)
  {
    pPackets[i].data = analogRead(uSensorPin[i]);
  }

  //Serial.println(pPackets[0].data);
  Serial.write("H");
  for(int i = 0; i < uSensorNum ; i ++ )
  {
    for(int j = 0; j < uSizeRate; j ++ )
    {
      Serial.write(pPackets[i].senddata[j]);
    }
  }
  delay(10);
}   