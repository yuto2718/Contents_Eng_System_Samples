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