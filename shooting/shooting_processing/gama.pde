import processing.sound.*;
import processing.serial.*;

public class Game
{
    ArrayList<Enemy> enemys;
    Player player;

    int state;
    PFont font;

    Serial arduino;
    final String portName = "COM3";
    final int lf = 10;
    final int baudRate = 115200;

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

        enemys.add(new Enemy(parent, 0, 10, 30, color(0, 0, 255), 100));
        enemys.get(0).addWeapon(new RotateRight(parent, width/2, height/2));
        enemys.get(0).weapons.get(0).c = color(100,50,50);
        enemys.get(0).addWeapon(new RotateLeft(parent, width/2, height/2));
        enemys.get(0).weapons.get(1).c = color(100,50,50);

        enemys.add(new Enemy(parent, 20, 10, 30, color(0, 0, 255), 100));
        enemys.get(1).addWeapon(new Housya(parent, width/2, height/2));
        enemys.get(1).weapons.get(0).c = color(100,50,50);
        enemys.get(1).addWeapon(new Ougi(parent, width/2, height/2));
        enemys.get(1).weapons.get(1).c = color(100,50,50);

        enemys.add(new Enemy(parent, -20, 10, 30, color(0, 0, 255), 100));
        enemys.get(2).addWeapon(new RotateLeft(parent, width/2, height/2));
        enemys.get(2).weapons.get(0).c = color(100,50,50);
        enemys.get(2).addWeapon(new RotateRight(parent, width/2, height/2));
        enemys.get(2).weapons.get(1).c = color(100,50,50);

        player = new Player(parent, width/2, height/2, 20, color(0, 255, 0), 100);
        player.addWeapon(new Laser(parent, width/2, height/2));
        player.addWeapon(new Ougi2(parent, width/2, height/2));

        textAlign(CENTER, BOTTOM);

        arduino = new Serial(parent, portName, baudRate);
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

            //if(arduino.available() > 0)
            //{
            //    player.x = map(float(arduino.readStringUntil(lf)), 0, 50.0, 0, width);
            //    println(player.x);
            //}
            //while(arduino.available() != 0)
            //{

            //    arduino.read();
            //}

            player.update();

            for(int i = 0; i < enemys.size(); i ++)
            {
                enemys.get(i).update();
                for(int j = 0; j < enemys.get(i).weapons.size(); j ++)
                {
                    player.isCollision(enemys.get(i).weapons.get(j).projectiles);
                }
                for(int j = 0; j < player.weapons.size(); j++)
                {
                    enemys.get(i).isCollision(player.weapons.get(j).projectiles);
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
            fill(0);
            text("クリア！", width/2, height/2);
            text(int(player.hitPoint), width/2, height/2+200);
        }
        else if(state == -1)
        {
            fill(255,0,0);
            text("死", width/2, height/2);
        }
        else if(state == 2)
        {
            fill(0);
            text("キーを押してスタート", width/2, height/2);
        }
    }
}