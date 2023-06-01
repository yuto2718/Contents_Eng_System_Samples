import processing.sound.*;
import processing.serial.*;

Game g;
void setup()
{
    g = new Game(this);
}

void draw()
{
    g.update();
    g.draw();
}
