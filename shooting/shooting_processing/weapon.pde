import processing.sound.*;

public class Weapon
{
    float x, y; //位置，Projectileを射出する位置，使用状態でないアイテムとしての位置に使用
    float vx,vy;//初速度 Projectileに与える初速度
    float size; //Projectileのサイズ，使用状態でないアイテムとしての位置に使用
    float damage; //ダメージ
    color c;      //色

    SoundFile effect;//発射時の音
    int coolTime;    //クールタイム
    int coolTimeCounter;//クールタイム用のカウンター
    int blinkCounter;   //点滅に使用する予約

    boolean isAvailable;//利用可能か（Machineに所有されているか）
    boolean soundOn = false;//音のオンオフ
    ArrayList<Projectile> projectiles;//発射したProjectileの配列
    ArrayList<Coordinate> targets;    //ターゲットの配列 追尾するProjectileなどで使用
    
    Weapon(PApplet parent, float x, float y, float size, float damage, color c, int coolTime, String fileName)//コンストラクタ
    {
        this.x = x;
        this.y = y;
        this.size = size;

        this.c = c;
        this.damage = damage;

        this.coolTime = coolTime;
        this.isAvailable = false;

        this.coolTimeCounter = coolTime;

        this.vx = 0;
        this.vy = -1;
        this.blinkCounter = 0;
        
        if(!fileName.equals("Null"))
        {
            this.effect = new SoundFile(parent, fileName);
            this.soundOn = false;
        }

        this.projectiles = new ArrayList<Projectile>();
        this.targets = new ArrayList<Coordinate>();

        ellipseMode(CENTER);
    }

    void satTargets(float x, float y) 
    {
        //追尾するProjectileなどで使用
    }

    void available()
    {
        isAvailable = true;
        //所持された状態へ遷移
    }

    void genProjectile()
    { 
        projectiles.add(new Projectile(this.x, this.y, this.vx, this.vy, this.size, this.damage, this.c));
        //Projectileを発射する
    }
    
    void updateDisenable()
    {
        //Machineに所持されていない状態の処理 : アイテム状態などを想定しているが現在は未実装
        coolTimeCounter = coolTime;
        for(int i = 0; i < projectiles.size(); i ++)
        {
            projectiles.remove(i);
        }
    }
    
    void updateProjectiles()
    {
        //Projectileの更新処理
        for(int i = 0; i < projectiles.size(); i ++)
        {
            projectiles.get(i).update();
            if(projectiles.get(i).isInField())
            {
                projectiles.remove(i);
            }
        }
    }
    
    void update()
    {
        //Weaponの更新処理
        if(isAvailable)
        {
            if(this.coolTimeCounter >= this.coolTime)
            //クールタイムが経過していれば，Projectileを発射
            {
                genProjectile();
                this.coolTimeCounter = 0;
                if(soundOn)
                {
                    this.effect.play();
                }
            }
            this.coolTimeCounter ++;
            updateProjectiles();
        }
        else
        {
            updateDisenable();
        }
    }

    boolean isCollision(float x, float y, float size)
    {
        //接触判定 : アイテム状態での使用を想定，現在未使用
        return getDistance(x, y, this.x, this.y) < (size + this.size)/2;
    } 

    protected float getDistance(float x1, float y1, float x2, float y2)
    {
        //距離計算
        return sqrt(pow(x1 - x2, 2) + pow(y1 - y2, 2));
    }

    void draw()
    {
        //描画処理
        blinkCounter ++;
        if(isAvailable)
        {
            for(int i = 0; i < projectiles.size(); i ++)
            {
                projectiles.get(i).draw();
            }
        }
        else
        {
            noStroke();
            fill(c);
            ellipse(x, y, size * 2, size * 2);
        }
    }
}

//以下具体的な武器の定義：Weaponの継承になっている．
public class Laser extends Weapon
{
    Laser(PApplet parent, float x, float y)
    {
        super(parent, x, y, 10.0, 5.0, color(255,100, 50), 10, "arms01/laser1.mp3");
        effect.amp(0.01);
        this.vx = 0;
        this.vy = -5;
    }
}


public class Ougi extends Weapon
{
    Ougi(PApplet parent, float x, float y)
    {
        super(parent, x, y, 10.0, 5.0, color(255,100, 50), 59, "arms01/laser5.mp3");
        soundOn = false;
        effect.amp(0.2);
        this.vx = 0;
        this.vy = -5;
    }

    void genProjectile()
    {
        projectiles.add(new Projectile(this.x, this.y, this.vx, this.vy, this.size, this.damage, this.c));
        projectiles.add(new Projectile(this.x, this.y, -5, this.vy, this.size, this.damage, this.c));
        projectiles.add(new Projectile(this.x, this.y, 5, this.vy, this.size, this.damage, this.c));
    }
}


public class Ougi2 extends Weapon
{
    Ougi2(PApplet parent, float x, float y)
    {
        super(parent, x, y, 15.0, 15.0, color(255,100, 50), 80, "arms01/launcher1.mp3");
        effect.amp(0.2);
        this.vx = 0;
        this.vy = -5;
    }

    void genProjectile()
    {
        projectiles.add(new Projectile(this.x, this.y, this.vx, this.vy, this.size, this.damage, this.c));
        projectiles.add(new Projectile(this.x, this.y, -1, this.vy, this.size, this.damage, this.c));
        projectiles.add(new Projectile(this.x, this.y, 1, this.vy, this.size, this.damage, this.c));
    }
}


public class Radial extends Weapon
{
    Radial(PApplet parent, float x, float y)
    {
        super(parent, x, y, 10.0, 8.0, color(255,100, 50), 30, "arms01/laser3.mp3");
        soundOn = false;
        effect.amp(0.1);
        this.vx = 0;
        this.vy = -7;
    }

    void genProjectile()
    {
        for(int i = 0 ; i < 360; i=i+10){
            projectiles.add(new Projectile(this.x, this.y, abs(vy)*cos(radians(i)), -abs(vy)*sin(radians(i)), this.size, this.damage, this.c));
        }
        
    }
}

public class Radial2 extends Weapon
{
    Radial2(PApplet parent, float x, float y)
    {
        super(parent, x, y, 10.0, 2.0, color(255,100, 50), 25, "arms01/laser3.mp3");
        soundOn = false;
        effect.amp(0.1);
        this.vx = 0;
        this.vy = -7;
    }
    void genProjectile(int phase)
    {
        for(int i = phase ; i < 360; i=i+10)
        {
            projectiles.add(new Projectile(this.x, this.y, abs(vy)*cos(radians(i)), -abs(vy)*sin(radians(i)), this.size, this.damage, this.c));
        }
    }

    void update()
    {
        if(isAvailable)
        {
            if(this.coolTimeCounter == this.coolTime)
            {
                genProjectile(0);
                if(soundOn)
                {
                    this.effect.play();
                }
            }
            if(this.coolTimeCounter == this.coolTime + 5)
            {
                genProjectile(int(random(1, 10)));
                if(soundOn)
                {
                    this.effect.play();
                }
                coolTimeCounter = 0;
            }
            this.coolTimeCounter ++;
            updateProjectiles();
        }
        else
        {
            updateDisenable();
        }
    }
}


public class RotateLeft extends Weapon
{
    int i = 0;
    RotateLeft(PApplet parent, float x, float y)
    {
        super(parent, x, y, 15.0, 10.0, color(255,100, 50), 15, "arms01/laser5.mp3");
        soundOn = false;
        effect.amp(0.1);
        this.vx = 0;
        this.vy = -5;
    }

    void genProjectile()
    {
        projectiles.add(new Projectile(this.x, this.y, abs(vy)*cos(radians(i)), -abs(vy)*sin(radians(i)), this.size, this.damage, this.c));
        i = i + 3;
        
    }
}


public class RotateRight extends Weapon
{
    int i = 0;
    RotateRight(PApplet parent, float x, float y)
    {
        super(parent, x, y, 15.0, 10.0, color(255,100, 50), 15, "arms01/laser5.mp3");
        soundOn = false;
        effect.amp(0.1);
        this.vx = 0;
        this.vy = -5;
        
    }

    void genProjectile()
    {
        projectiles.add(new Projectile(this.x, this.y, abs(vy)*cos(radians(i)), -abs(vy)*sin(radians(i)), this.size, this.damage, this.c));
        i = i - 3;
        
    }
}


public class Missile extends Weapon
{
    Missile(PApplet parent, float x, float y)
    {
        super(parent, x, y, 15.0, 10.0, color(255,100, 50), 5, "Null");
        this.soundOn = false;
    }

    void satTargets(float x, float y)
    {
        targets.add(new Coordinate(x, y));
        println(x, y);
    }

    void updateSeeker()
    {
        for(int i = 0; i < projectiles.size(); i ++)
        {
            int index = 0;
            double dist = 0;
            double maxValue = 0;
            for(int j = 0; j < targets.size(); j ++)
            {
                dist = targets.get(j).getDistance(projectiles.get(i).x, projectiles.get(i).y);
                if( dist > maxValue)
                {
                    maxValue = dist;
                    index = j;
                }
            }
            if(targets.size() == 0)
            {
                projectiles.get(i).setTartget(new Coordinate(width/2, height/2));
            }
            else
            {
                projectiles.get(i).setTartget(targets.get(index));
            }
            
        }
    }

    void genProjectile()
    { 
        int direction = int(random(0, 360));
        projectiles.add(new Seeker(this.x, this.y, 3 * cos(radians(direction)), 3 * sin(radians(direction)), this.size, this.damage, this.c));
    }

    void update()
    {
        if(isAvailable)
        {
            if(this.coolTimeCounter >= this.coolTime)
            {
                genProjectile();
                if(soundOn)
                {
                    this.effect.play();
                    
                }
                coolTimeCounter = 0;
            }
            this.coolTimeCounter ++;
            updateSeeker();
            updateProjectiles();
            targets.clear();
        }
        else
        {
            updateDisenable();
        }
    }
}

public class Radial3 extends Missile
{
    Radial3(PApplet parent, float x, float y)
    {
        super(parent, x, y);
        this.soundOn = false;
        vy = -7.5;
        coolTime = 90;
    }

    void genProjectile()
    {
        for(int i = 0 ; i < 360; i = i + 3)
        {
            projectiles.add(new Seeker(this.x, this.y, abs(vy)*cos(radians(i)), -abs(vy)*sin(radians(i)), this.size, this.damage, this.c));
        }
    }
}