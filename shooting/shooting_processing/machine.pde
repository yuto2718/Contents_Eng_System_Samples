import processing.sound.*;

public class Machine
{
    float x, y; //Machineの位置
    float size; //大きさ
    float hitPoint;//HP
    color c;       //色

    ArrayList<Weapon> weapons;  //所持しているWeaponの配列

    PApplet parent;             //Sound再生用にPApplet

    int invincibleCounter;      //無敵時間のカウンター
    int invencibleTime;         //無敵時間

    SoundFile damageEffect;     //ダメージを受けたときに鳴らす効果音

    Machine(PApplet parent, float x, float y, float size, color c, float hitPoint)
    {
        //コンストラクタ
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
        //武器を所持する
        w.available();
        weapons.add(w);
    }   

    void isCollision(ArrayList<Projectile> p)
    {
        //Projectileに接触したか
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
        //生存しているか
        return hitPoint > 0;
    }

    void update()
    {
        //更新処理
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
        //描画処理
        noStroke();
        fill(c);
        ellipse(x,y,size,size);
        for(int i = 0; i < weapons.size(); i ++)
        {
            weapons.get(i).draw();
        }
    }
}