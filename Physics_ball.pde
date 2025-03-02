float[] speed = {5};
float[] xspeed = {0};
float[] x = {960};
float[] y = {100};

float gravity = .98;
float damping = 0.5;
float pushFactor = 0.6;

int xspeedChange = 10;
int yspeedChange = 10;
int ballincrease = 100;
int maxsize = 10;
int minsize = 4;

boolean auto_bounce = false;
boolean ball_counter = false;
boolean no_gravity = true;

//walls
boolean left = true;
boolean right = true;
boolean up = true;
boolean down = true;

//gravity
boolean gup = false;
boolean gdwn = true;
boolean gleft = false;
boolean gright = false;

int[] size = {10};
float g = 6.674e-4;

//scalefactor:1
float scalefactor = 1;

int[] ballcolor = {#FF0000};
int[] colors = {#FF0000, #1CFF00, #FF00EF, #7E02E5, #00E8FF, #F6FF00, #FFE043, #0024FF, #FF8D00, #FF6CFF, #FE0002, #41FDFE, #BC13FE, #7e15db};

void setup()
{
  frameRate(60);
  noStroke();
  fullScreen();
  //size(600, 600);
  damping /= -1;
  //background(0);
  ellipseMode(CENTER);

  for (int c = 0; c < x.length; c++)
  {
    ballcolor[c] = colors[int(random(0,colors.length))];
  }
}

void draw()
{
  background(0);
  
  ball();
  collision();
  gravity();
  
  //drawing ball
  for (int c = 0; c < y.length; c++)
  {
    fill(ballcolor[c]);
    ellipse(x[c], y[c], size[c], size[c]);
  }
  
  //drawing a counter of every ball
  if (ball_counter)
  {
    fill(255);
    text(x.length,30, 30);
  }
}

//**************************************
//this function calculates ball physics
//**************************************

void ball()
{
  //motion
  for (int c = 0; c < y.length; c++)
  {
    x[c] += xspeed[c] / scalefactor;
    y[c] += speed[c] / scalefactor;
    
    if (!no_gravity)
    {
      if (gdwn)
      {
        speed[c] += gravity;
      } 
      else if (gup)
      {
        speed[c] -= gravity;
      }
      else if (gright)
      {
        xspeed[c] += gravity;
      }
      else
      {
        xspeed[c] -= gravity;
      }
      
      //makes ball slow down in corrisponding direction
      if (xspeed[c] > 1)
      {
        xspeed[c] -= .01;
      }
      else if (xspeed[c] < -1)
      {
       xspeed[c] += .01;
      }
    }
  
    //wraps around left and right edges
    if (right)
    {
      if (x[c] > width - (size[c]/2))
      {
        //x[c] = size[c];
        
        x[c] = width - size[c] / 2 - 2;
        xspeed[c] *= damping;
      }
    }
    if (left)
    {
      if (x[c] < (size[c]/2))
      {
        //x[c] = width - size[c];
        
        x[c] = size[c] / 2 + 2;
        xspeed[c] *= damping;
      }
    }
  
    //bounces on top and bottom
    if (down)
    {
      if (y[c] > height - (size[c]/2))
      {
        y[c] = height - (size[c]/2 + 2);
        speed[c] *= damping;
      }
    }
    if (up)
    {
      if (y[c] < (size[c]/2))
      {
        y[c] = (size[c]/2 + 2);
        speed[c] *= damping;
      }
    }
    
  }
  
  //auto bouncing after pressing f
  if (auto_bounce)
  {
    for (int c = 0; c < y.length; c++)
    {
      if (speed[c] < 2 && speed[c] > -2)
      {
        if (y[c] > height - height / 4)
        {
          speed[c] += 40;
        }
      }
      
      if (xspeed[c] < 2 && xspeed[c] > -2)
      {
        if (xspeed[c] > 0)
        {
          xspeed[c] += 30;
        }
        else
        {
          xspeed[c] -= 30;
        }
      }
    }
  }
}
