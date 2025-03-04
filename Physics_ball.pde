float[] speed = {5};
float[] xspeed = {0};
float[] x = {960};
float[] y = {100};

float gravity = .98;
//perfect bounce = .969
float damping = .6;
float pushFactor = 0.6;

int ballincrease = 0;
int maxsize = 10;
int minsize = 4;

boolean auto_bounce = false;
boolean ball_counter = false;
boolean no_gravity = true;
boolean controls = true;
boolean labels = true;

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

int[] size = {15};
float g = 6.674e-4;

//scalefactor:1
float scalefactor = 1;

int[] ballcolor = {#FF0000};
int[] colors = {#FF0000, #1CFF00, #FF00EF, #7E02E5, #00E8FF, #F6FF00, #FFE043, #0024FF, #FF8D00, #FF6CFF, #FE0002, #41FDFE, #BC13FE, #7e15db};

float average = 0;
float total = 0;
float momentum = 0;

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
  if (maxsize < minsize)
  {
    maxsize = minsize + 5;
  }
  
  momentum = 0;
  average = 0;
  total = 0;
  background(0);
 
  ball(); 
  gravity();
  collision();
  
  //drawing ball
  for (int c = 0; c < y.length; c++)
  {
    fill(ballcolor[c]);
    ellipse(x[c], y[c], size[c], size[c]);
    
    total = total + size[c];
    momentum = momentum + ((pow(size[c], 2) * (abs(speed[c]) + abs(xspeed[c]))) / size.length);
    
    if (labels)
    {
      fill(255);
      text((pow(size[c], 2) * (abs(speed[c]) + abs(xspeed[c]))), x[c] + size[c], y[c] + size[c]);
      text(c, x[c] + size[c], y[c] + size[c] - 10);
    }
  }
  
  average = total / size.length;
  //drawing information
  fill(0);
  if (ball_counter)
  {
    rect(25,20,125,65);
    fill(255);
    text(x.length + " Particles",30, 30);
    text(scalefactor + "X speed", 30, 40);
    text(ballincrease + " Ball Increase", 30, 50);
    text(frameRate + " FPS", 30, 60);
    text("Overall Mass = " + average, 30, 70);
    text("Combined Mass = " + total, 30, 80);
    text("Gravity constant = " + g, 30, 90);
    text("Maxsize = " + maxsize, 30, 100);
    text("Minsize = " + minsize, 30, 110);
    text("average momentum = " + momentum, 30, 120);
  }
  
  if (controls)
  {
    fill(255);
    text("F = autobounce", 1700, 30);
    text("E = Stats", 1700, 40);
    text("R = Change Speed", 1700, 50);
    text("Q = Increase Change", 1700, 60);
    text("G = Toggle Gravity", 1700, 70);
    text("WASD = Gravity Direction", 1700, 80);
    text("Arrows = Wall toggle", 1700, 90);
    text("Click = Place Particles", 1700, 100);
    text("C = this panel", 1700, 110);
    text("T = change gravity constant", 1700, 120);
    text("+ = maxsize increase", 1700, 130);
    text("- = minsize increase", 1700, 140);
  }
}

void ball()
{
  //motion
  for (int c = 0; c < y.length; c++)
  {
    x[c] += xspeed[c] / scalefactor;
    y[c] += speed[c] / scalefactor;
    
    if (!no_gravity)
    {
      //damping = -0.8;
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
    else
    {
      //damping = -0.5;
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
