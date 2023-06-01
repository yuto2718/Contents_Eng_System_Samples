import processing.sound.*;

public class Machine
{
    float x, y;
    float size;
    float hitPoint;
    color c;

    ArrayList<Weapon> weapons;

    PApplet parent;

    int invincibleCounter;
    int invencibleTime;
    boolean collisionFlag;

    SoundFile damageEffect;

    Machine(PApplet parent, float x, float y, float size, color c, float hitPoint)
    {
        this.x = x;
        this.y = y;
        this.size = size;

        this.parent = parent;

        this.c = c;
        this.hitPoint = hitPoint;

        this.invincibleCounter = 0;
        this.invencibleTime = 60;

        weapons = new ArrayList<Weapon>();
        damageEffect = new SoundFile(parent, "arms01/game_explosion1.mp3");
        damageEffect.amp(0.2);

        ellipseMode(CENTER);
    }

    void addWeapon(Weapon w)
    {
        w.available();
        weapons.add(w);
    }   

    void isCollision(ArrayList<Projectile> p)
    {
        for(int i = 0; i < p.size(); i ++)
        {
            if(p.get(i).isCollision(this.x, this.y, this.size))
            {
                if(invincibleCounter == 0)
                {
                    damageEffect.play();
                    hitPoint -= p.get(i).damage;
                    invincibleCounter = invencibleTime;
                }
            }
        }
    }

    boolean isAlive()
    {
        return hitPoint > 0;
    }

    void update()
    {
        for(int i = 0; i < weapons.size(); i ++)
        {
            weapons.get(i).x = x;
            weapons.get(i).y = y;
            weapons.get(i).update();
        }
        if(invincibleCounter != 0)
        {
            invincibleCounter--;
        }
    }

    void draw()
    {
        noStroke();
        fill(c);
        ellipse(x,y,size,size);
        for(int i = 0; i < weapons.size(); i ++)
        {
            weapons.get(i).draw();
        }
    }
}