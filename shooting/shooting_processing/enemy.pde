import processing.sound.*;

public class Enemy extends Machine //敵　とりあえずリサージュ曲線で動く
{
    int counter;
    float phase;

    Enemy(PApplet parent, float x, float y, float size, color c, float hitPoint)
    {
        super(parent,  x,  y,  size, c, hitPoint);
        phase = x;
        invencibleTime = 20;
    }

    void move()
    {
        this.x = width/3 * sin(counter/199.0 + phase) + width/2;
        this.y = height/11 * cos(counter/279.0 + phase) + 200;
        counter ++;
    }

    void addWeapon(Weapon w)
    {
        w.vy = w.vy * -1.0;
        super.addWeapon(w);
    }


    void update()
    {
        move();
        super.update();
    }
}