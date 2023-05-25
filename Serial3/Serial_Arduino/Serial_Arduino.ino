const uint8_t LED = 13;
const long baudRate = 115200;

char LEDState= 0;
char recvData = 0;

void setup()
{
  Serial.begin(baudRate);
  pinMode(LED, OUTPUT);
}

void loop()
{
  if(Serial.available() > 0)
  {
    recvData = (char)Serial.read();
    if(recvData == 'H')
    {
      LEDState = HIGH;
    }
    else if(recvData == 'L')
    {
      LEDState = LOW;
    }
    bufferClear();
  }
  digitalWrite(LED, LEDState);
  delay(10);
}

void bufferClear()
{
  while(Serial.available())
  {
    Serial.read();
  }
}

