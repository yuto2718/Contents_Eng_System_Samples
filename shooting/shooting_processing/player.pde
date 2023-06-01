import processing.sound.*;

public class Player extends Machine
{
    SoundFile damageEffect;
    Player(PApplet parent, float x, float y, float size, color c, float hitPoint)
    {
        super(parent,  x,  y,  size, c, hitPoint);
        invencibleTime = 30;
        damageEffect = new SoundFile(parent, "arms01/game_explosion4.mp3");
    }

    void move()
    {
        this.x = mouseX;
        this.y = height-100;
    }

    void update()
    {
        move();
        super.update();
    }

    void draw()
    {
        text(int(hitPoint), width - 200, height-100);
        super.draw();
    }
}

public class ArduinoControlPlayer extends Player
{
    Serial arduino;
    final String portName = "COM3";
    final int lf = 10;
    final int baudRate = 115200;

    ArduinoControlPlayer(PApplet parent, float x, float y, float size, color c, float hitPoint)
    {
        super(parent, x, y, size, c, hitPoint);
        arduino = new Serial(parent, portName, baudRate);
    }

    void move()
    {
        while(arduino.available() >= 1)
        {
            arduino.read();
        }
        x = map(float(arduino.readStringUntil(lf)), 0, 50.0, 0, width);
        y = height-100;
    }    
}

public class FreeMousePlayer extends Player
{
    FreeMousePlayer(PApplet parent, float x, float y, float size, color c, float hitPoint)
    {
        super(parent, x, y, size, c, hitPoint);
    }

    void move()
    {
        x = mouseX;
        y = mouseY;
    }
}