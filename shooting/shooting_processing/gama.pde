import processing.sound.*;
import processing.serial.*;

public class Game
{
    ArrayList<Enemy> enemys;
    Player player;

    int state;
    PFont font;

    Game(PApplet parent)
    {
        surface.setResizable(true); 
        surface.setSize(1000, 1000);
        frameRate(60);
        smooth();
        ellipseMode(CENTER);

        font = createFont("Meiryo UI", 250);; 
        textFont(font, 50); 
        
        enemys = new ArrayList<Enemy>();
        Enemy e;
        e = new Enemy(parent, 0, 10, 30, color(0, 0, 255), 100);
        e.addWeapon(new RotateRight(parent, width/2, height/2));
        e.addWeapon(new RotateLeft(parent, width/2, height/2));
        enemys.add(e);


        e = new Enemy(parent, 20, 10, 30, color(0, 0, 255), 100);
        e.addWeapon(new Housya(parent, width/2, height/2));
        e.addWeapon(new Ougi(parent, width/2, height/2));
        enemys.add(e);

        e = new Enemy(parent, -20, 10, 30, color(0, 0, 255), 100);
        e.addWeapon(new RotateLeft(parent, width/2, height/2));
        e.addWeapon(new RotateRight(parent, width/2, height/2));
        enemys.add(e);

        player = new Player(parent, width/2, height/2, 20, color(0, 255, 0), 100);
        player.addWeapon(new Laser(parent, width/2, height/2));
        player.weapons.get(player.weapons.size()-1).c = color(255,0,0);
        player.addWeapon(new Ougi2(parent, width/2, height/2));
        player.weapons.get(player.weapons.size()-1).c = color(255,0,0);

        textAlign(CENTER, BOTTOM);

        state = 2;
    }

    void update()
    {
        if(state == 0)
        {
            if(enemys.size() == 0)
            {
                state = 1;
            }

            player.update();

            for(int i = 0; i < enemys.size(); i ++)
            {
                enemys.get(i).update();
                for(int j = 0; j < enemys.get(i).weapons.size(); j ++)
                {
                    player.isCollision(enemys.get(i).weapons.get(j).projectiles);
                    enemys.get(i).weapons.get(j).satTargets(player.x, player.y);
                }
                for(int j = 0; j < player.weapons.size(); j++)
                {
                    enemys.get(i).isCollision(player.weapons.get(j).projectiles);
                    player.weapons.get(j).satTargets(enemys.get(i).x, enemys.get(i).y);
                }
                if(!enemys.get(i).isAlive())
                {
                    enemys.remove(i);
                }
            }

            if(!player.isAlive())
            {
                state = -1;
            }
        }
        else if(state == 2)
        {
            if(keyPressed)
            {
                state = 0;
            }
        }
        else if(state == -1 || state == 1)
        {
            ;
        }
    }

    void drawClearScreen()
    {
        fill(0);
        text("クリア！", width/2, height/2);
        text(int(player.hitPoint), width/2, height/2+200);
    }

    void drawGameOverScreen()
    {
        fill(255,0,0);
        text("死", width/2, height/2);
    }

    void drawStandbyScreen()
    {
        fill(0);
        text("キーを押してスタート", width/2, height/2);
    }

    void draw()
    {
        background(255);
        if(state == 0)
        {
            player.draw();
            for(int i = 0; i < enemys.size(); i ++)
            {
                enemys.get(i).draw();
                fill(0);
                text(int(enemys.get(i).hitPoint), 50, 50 + 50*i );
            }
        }
        else if(state == 1)
        {
            drawClearScreen();
        }
        else if(state == -1)
        {
            drawGameOverScreen();
        }
        else if(state == 2)
        {
            drawStandbyScreen();
        }
    }
}