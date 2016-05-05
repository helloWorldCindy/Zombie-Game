//injured survivors are red,infected survivors are green, healthy survivors are blue
//infect=1,injured=2,healthy=3


int arrayLength=10;
//create a Survivor array
Survivor[] survivors=new Survivor[arrayLength];

void setup()
{
  frameRate(60);
  size(800, 700);
  for (int index = 0; index<survivors.length; index++)
  {

    survivors[index]=new Survivor(int(random(1, 4)));
    //constrain the x an y coordinate
    survivors[index]. x=constrain(survivors[index].x, radius/2, width-radius/2);
    survivors[index]. y=constrain(survivors[index].y, radius/2, height-radius/2);
  }
}
int radius=40;
//create a Survivor class
class Survivor
{
  float x;
  float y;
  String name;
  boolean infected;
  boolean injured;
  boolean uninfected;
  int carryBullet;
  float health;
  int healthStatue;
  float speedX;
  float speedY;
  color circleColor;
  //construtor
  Survivor(int healthStatueNumber)
  {

    //randomize each survivors' locations
    x=random(radius, width-radius);
    y=random(radius, height-radius);
    healthStatue=healthStatueNumber;
    //randomize the situation whether they are infected,injured or health
    // health=random(0, 0.9);
    //randomize the bullet numberes that they are carrying
    carryBullet=(int)random(30, 50);
    //assign different value in different case:healthy, injured,infected
    if (healthStatue==1)
    {
      speedX = 1;
      speedY = 1;
      infected=true;
      uninfected=false;
      circleColor=color( 0, 255, 0);
    } else if (healthStatue==2)
    {
      speedX = 1.5;
      speedY = 1.5;
      injured=true;
      uninfected=true;
      circleColor=color(255, 0, 0);
    } else
    {
      speedX = 2.1;
      speedY = 2.1;
      infected=false;
      injured=false;
      uninfected=true;
      circleColor=color( 0, 0, 255);
    }
  }
}

void draw()
{ 
  //to spawn two people when the healthy percentage less than 20%.
  boolean addMore=false;


  if (healthPercentage(survivors)<0.2)
  {
    addMore=true;
  }
  if (addMore==true)
  { 
    float randomNumber =random(1);
    int decide=0;
    if (randomNumber<=0.25)
    {
      decide=2;
    }
    if (randomNumber>0.25)
    {
      decide=3;
    }
    survivors=(Survivor[])append(survivors, new Survivor(decide));
    survivors=(Survivor[])append(survivors, new Survivor(decide));
    arrayLength=survivors.length;
    println(decide);
    println();
    addMore=false;
  }

  //draw the survivors as circles ,and displays their names on the top of the circles
  background(255);
  ellipseMode(CENTER);
  for (int i=0; i<survivors.length; i++)
  {
    move(survivors, survivors[i]);

    fill(survivors[i].circleColor);
    ellipse(survivors[i].x, survivors[i].y, radius, radius);

    fill(0);
    textSize(12);
    text(i+1, survivors[i].x, survivors[i].y);
  }
  //show the percentage of the healthy survivors ,and the total numbers of the bullet they carry
  float healthPer=float(nf(healthPercentage(survivors), 2, 2))*100;
  textSize(18);
  text("HEALTH: "+int(healthPer)+"%", 0, 400);
  text("Bullet"+healthyBullet(survivors), 0, 500);
}
float healthNumber;
//create a class to return  a percentage of survivors who are completely healthy among all the survivors
float healthPercentage(Survivor[] a)
{
  healthNumber=0;

  for (int i=0; i<arrayLength; i++)
  {
    if (a[i].uninfected==true&&a[i].injured==false&&a[i].infected==false)
    {
      healthNumber++;
    }
  }

  float healthPercent=healthNumber/arrayLength;
  return healthPercent;
}

//create a function that will return  the number of bullets in the possession of healthy survivors
int healthyBullet(Survivor[] a)
{
  int bulletNumber=0;
  for (int i=0; i<a.length; i++)
  {
    if (a[i].infected==false&&a[i].injured==false)
    {
      bulletNumber+=a[i].carryBullet;
    }
  }

  return bulletNumber;
}
//create a function to check if two people are touched or not 
boolean checkCollision(Survivor a, Survivor b)
{
  if (abs(dist(a.x, a.y, b.x, b.y))<radius)
  {

    return true;
  } else
  {
    return false;
  }
}
//create a function to control how the survivors move
void move(Survivor[] a, Survivor b)
{
  float infectedDirection;
  float targetX, targetY;
  float angle;
  int healthyIndex=0;


  for (int i=0; i<a.length; i++)
  {
    //check if the a[i] is infected or not
    if (a[i].infected==false)
    {
      healthyIndex=i;
    }
  }
  if (b.infected == true)
  {
    boolean moved = false;
    for (int i = 0; i<survivors.length; i++)
    {
      if (a[i].infected == false)
      {//the uninfected people will be infected after touched by the infected.
        if (abs(dist(b.x, b.y, a[i].x, a[i].y)) < 110)
        {
          if (checkCollision(b, a[i])==true)
          {
            float randomNumber =random(1);
            //if the survivor is healthy, he can be infected in 30%of the time
            if (survivors[i].injured==false)
            {
              if (randomNumber<=0.3)
              { 
                a[i].infected = true;
                if (survivors[i].infected=true)
                {//turn to infected
                  survivors[i].uninfected=false;
                  survivors[i].healthStatue=1;
                  survivors[i].circleColor=color( 0, 255, 0);
                }
              }
            }
            //if the survivor is injured, he can be infected in 60%of the time 
            else
            {
              if (randomNumber<=0.6)
              { 
                a[i].infected = true;
                if (survivors[i].infected=true)
                {//turn to infected
                  survivors[i].uninfected=false;
                  survivors[i].healthStatue=1;
                  survivors[i].circleColor=color( 0, 255, 0);
                }
              }
            }
          } else
          {//the infected people move toward the uninfected people
            moved = true;
            targetX = a[i].x;
            targetY = a[i].y;
            targetX=constrain(targetX, radius/2, width-radius/2);
            targetY=constrain(targetY, radius/2, height-radius/2);
            angle = atan2(targetY-b.y, targetX-b.x);
            b.y += sin(angle)*abs(b.speedY);
            b.x += cos(angle)*abs(b.speedX);
            b.x=constrain(b.x, radius/2, width-radius/2);
            b.y=constrain(b.y, radius/2, height-radius/2);
          }
        }
      }
    }
    if (moved == false)
    {
      b.y += b.speedY;
      b.x += b.speedX;
    }
  } 
  //if the a[i]is not infected
  else
  {
    boolean moved = false;
    for (int i = 0; i<survivors.length; i++)
    {
      if (a[i].infected == true)
      { 
        if (abs(dist(b.x, b.y, a[i].x, a[i].y))< 80)
        {//the uninfected people will walk away from the infected
          moved = true;
          targetX = a[i].x;
          targetY = a[i].y;
          targetX=constrain(targetX, radius/2, width-radius/2);
          targetY=constrain(targetY, radius/2, height-radius/2);
          angle = atan2(targetY-b.y, targetX-b.x);
          b.y += sin(angle+PI)*abs(b.speedY);
          b.x += cos(angle+PI)*abs(b.speedX);
          b.x=constrain(b.x, radius/2, width-radius/2);
          b.y=constrain(b.y, radius/2, height-radius/2);
        }
      }
    }
    if (moved == false)
    {
      b.y += b.speedY;
      b.x += b.speedX;
    }
  }
  //all the survivors will bounce back after they hit the edge of the window
  if (b.y+radius/2 > height|| b.y-radius/2 < 0)
  {
    b.speedY*= -1;
  }
  if (b.x+radius/2 > width||b.x-radius/2 < 0)
  {
    b.speedX*= -1;
  }
}