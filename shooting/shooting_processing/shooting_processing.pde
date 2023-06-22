import processing.sound.*;
import processing.serial.*;

Game g;

final static String portName = "devname";

void setup()
{
    g = new Game(this);
}

void draw()
{
    g.update();
    g.draw();
}
