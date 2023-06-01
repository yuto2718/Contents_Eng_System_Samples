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

PFont  font;
Button button;

int tmp = 0;

class Button
{
    
    float x, y;
    float sizeX;
    float sizeY;

    protected color baseColor;

    private float normalBrightness;
    private float selsectBrightness;
    private float pushedBrightness;

    private String str[];
    private int state;

    Button(float x, float y, float sizeX, float sizeY, color baseColor)
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
    
    void update()
    {
        this.updateState();
        this.draw();
    }

    protected void draw() 
    {
        rectMode(CENTER);
        colorMode(HSB, 360, 100, 100);
        textAlign(CENTER, CENTER);

        noStroke();
        changeColor();

        rect(x, y, sizeX, sizeY, 20);

        fill(0, 0, 100);
        textSize(30);
        text(str[state], x, y-5);
    }

    boolean isPush()
    {
        if(state == 2)
        {
            return true;
        }
        return false;
    }

    protected boolean isInside()
    {
        if (mouseX > x-sizeX/2 && mouseX < x+sizeX/2) 
        {
            if (mouseY>y-sizeY/2 && mouseY<y+sizeY/2) 
            {
                return true;
            }
        }
        return false;
    }

    protected void updateState()
    {
        state = checkState();
    }

    private int checkState()
    {
        if(!isInside())
        {
            return 0;
        }
        if(!mousePressed)
        {
            return 1;
        }
        return 2;
    }

    protected void changeColor()
    {
        switch (state) 
        {
            case 0:
                fill(hue(baseColor), saturation(baseColor), brightness(baseColor)*normalBrightness);
                break;

            case 1:
                fill(hue(baseColor), saturation(baseColor), brightness(baseColor)*selsectBrightness);
                break;

            case 2:
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

    rectMode(CENTER);
    colorMode(HSB, 360, 100, 100);
    textAlign(CENTER, CENTER);

   // println(Serial.list());
    arduino = new Serial(this, portName, 115200);

    button = new Button(width/2, height/2, 200, 100, color(25, 95, 100));
}

void draw()
{
    background(white);
    button.update();
    
    if(button.isPush())
    {
        arduino.write('H');
    }
    else 
    {
        arduino.write('L');
    }
}

void stop()
{
    arduino.stop();
    super.stop();
}
