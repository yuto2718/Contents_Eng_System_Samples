public class Projectile
{
    float x, y; //Projectileの位置
    float vx,vy;//Projectileの速度
    float size; //Projectileの大きさ
    float damage;//接触時のダメージ
    color c;    //色

    Projectile(float x, float y, float vx, float vy, float size, float damage, color c)
    {
        //コンストラクタ
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
        //更新処理 (直線移動)
        x = x + vx;
        y = y + vy;
    }

    void draw()
    {
        //描画
        noStroke();
        fill(c);
        ellipse(x, y, size, size);
    }

    void setTartget(Coordinate c)
    {
        //追跡するようなProjectileに使用
    }

    boolean isInField()
    {
        //画面内部にProjectileが存在するか
        return x < 0 || y < 0 || x > width || y > height;
    }

    boolean isCollision(float x, float y, float size)
    {
        //Projectileが接触したか　当たり判定
        return getDistance(x, y, this.x, this.y) < (size+this.size)/2;
    } 

    protected float getDistance(float x1, float y1, float x2, float y2)
    {
        //距離の計算
        return sqrt(pow(x1-x2, 2) + pow(y1-y2, 2));
    }
}

//　以下　具体的なProjectileの定義
public class AccProjectile extends Projectile //加速
{
    float max;
    float acc;

    AccProjectile(float x, float y, float vx, float vy, float size, float damage, color c)
    {
        super(x,  y, vx, vy, size, damage, c);
        max = 50;
        acc = 1.05;
    }

    void update()
    {
        float tmp = vx * acc;
        if(tmp < max)
        {
            vx = tmp;
        }
        tmp = vy * acc;
        if(tmp < max)
        {
            vy = tmp;
        }
        super.update();
    }
}

public class DccProjectile extends Projectile //減速
{
    float min;
    float dcc;

    DccProjectile(float x, float y, float vx, float vy, float size, float damage, color c)
    {
        super(x,  y, vx, vy, size, damage, c);
        min = 1;
        dcc = 0.95;
    }

    void update()
    {
        float tmp = vx * dcc;
        if(tmp > min)
        {
            vx = tmp;
        }
        tmp = vy * dcc;
        if(tmp > min)
        {
            vy = tmp;
        }
        super.update();
    }
}


public class Seeker extends Projectile //追尾
{
    Coordinate target;
    int count = 0;
    int stopFrames;
    Seeker(float x, float y, float vx, float vy, float size, float damage, color c)
    {
        super(x,  y, vx, vy, size, damage, c);
        target = new Coordinate(0, 0);

        stopFrames = (int)random(0, 30);
    }
    
    void setTartget(Coordinate c)
    {
        target = c; 
    }

    double getNormL2(float x, float y)
    {
        return sqrt(x*x + y*y);
    }

    void update()
    {
        float dx = target.x - x;
        float dy = target.y - y;

        if(count >=  50 && count <= 50 + stopFrames)
        {
            vx = 10 * (float)((dx)/getNormL2(dx, dy));
            vy = 10* (float)((dy)/getNormL2(dx,dy));
        }
        else
        {
            super.update();
        }
        count ++;
    }
}