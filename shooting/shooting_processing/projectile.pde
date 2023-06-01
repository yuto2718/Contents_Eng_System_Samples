public class Projectile
{
    float x, y;
    float vx,vy;
    float size;
    float damage;
    color c;

    Projectile(float x, float y, float vx, float vy, float size, float damage, color c)
    {
        this.x = x;
        this.y = y;
        this.vx = vx;
        this.vy = vy;

        this.size = size;

        this.c = c;
        this.damage = damage;
        ellipseMode(CENTER);
    }

    void update()
    {
        x = x + vx;
        y = y + vy;
    }

    void draw()
    {
        noStroke();
        fill(c);
        ellipse(x, y, size, size);
    }

    boolean isInField()
    {
        return x < 0 || y < 0 || x > width || y > height;
    }

    boolean isCollision(float x, float y, float size)
    {
        return getDistance(x, y, this.x, this.y) < (size+this.size)/2;
    } 

    protected float getDistance(float x1, float y1, float x2, float y2)
    {
        return sqrt(pow(x1-x2, 2) + pow(y1-y2, 2));
    }
}