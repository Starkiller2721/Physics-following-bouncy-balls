float[] speed = {5, 10, 21};
float[] xspeed = {12, 5, 23};
float[] x = {0, 60, 930};
float[] y = {100, 50, 350};


float gravity = .98;
float damping = .85;

int xspeedChange = 10;
int yspeedChange = 10;
int ballincrease = 1;

boolean auto_bounce = false;

int size = 30;

int[] ballcolor = {#FF0000, #1CFF00, #FF00EF, #00E8FF, #FF0000};
int[] colors = {#FF0000, #1CFF00, #FF00EF, #7E02E5, #00E8FF, #F6FF00, #FFE043, #0024FF,#FF8D00, #FF6CFF, #FE0002, #41FDFE, #BC13FE};

void setup()
{
  noStroke();
  fullScreen();
  //size(600, 600);
  damping /= -1;
  background(0);
  ellipseMode(CENTER);

  for (int c = 0; c < y.length; c++)
  {
    ballcolor[c] = colors[int(random(0,colors.length))];
  }
}

void draw()
{
  background(0);
  
  ball();
  
  //drawing ball
  for (int c = 0; c < y.length; c++)
  {
    fill(ballcolor[c]);
    ellipse(x[c], y[c], size, size);
  }
}


void mousePressed()
{
  float x2 = (float) mouseX;
  float y2 = (float) mouseY;
  
  for (int i = 0; i < ballincrease; i++)
  {
    x = append(x, x2);
    y = append(y, y2);
    speed = append(speed, int(random(-40, 40)));
    xspeed = append(xspeed, int(random(-60,60)));
    ballcolor = append(ballcolor, colors[int(random(0,colors.length))]);
  }
}

void keyPressed()
{
  
  //moves ball faster horizontally
  if (key == 's' || key == 'S')
  {
    for (int c = 0; c < y.length; c++)
    {
      if (xspeed[c] >= 0)
      {
        xspeed[c] += xspeedChange;
      }
      else
      {
        xspeed[c] -= xspeedChange;
      }
    }
  }
  
  //moves ball faster vertically
  if (key == 'w' || key == 'W')
  {
    for (int c = 0; c < y.length; c++)
    {
      if (speed[c] > 0)
      {
        speed[c] += yspeedChange;
      }
      else
      {
        speed[c] -= yspeedChange;
      }
    }
  }
  
  //activates auto bounce when moving too slowly
  if (key == 'f' || key == 'F')
  {
    auto_bounce = !auto_bounce;
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
    x[c] += xspeed[c];
    y[c] += speed[c];
    speed[c] += gravity;
  
  
    //makes ball slow down in corrisponding direction

    if (xspeed[c] > 0)
    {
      xspeed[c] -= .01;
    }
    else if (xspeed[c] < 0)
    {
     xspeed[c] += .01;
    }
  
  
    //bounces on left and right edges
    if (x[c] > width - (size/2 - 2))
    {
      x[c] = width - (size/2 - 2);
      xspeed[c] *= damping;
    }
    else if (x[c] < (size/2 + 2))
    {
      x[c] = (size/2);
      xspeed[c] *= damping;
    }
  
    //bounces on top and bottom
    if (y[c] > height - (size/2 - 2))
    {
      y[c] = height - (size/2 - 2);
      speed[c] *= damping;
    }
    else if (y[c] < (size/2 + 2))
    {
      y[c] = (size/2 + 2);
      speed[c] *= damping;
    }
    for (int i = 0; i < x.length; i++)
    {
      if (x[i] > x[c]-(size/2) && x[i] < x[c]+(size/2)  &&  y[i] > y[c]-(size/2) && y[i] < y[c]+(size/2))
      {
        y[i] ++;
        x[i] ++;
        y[c] --;
        x[c] --;
        
        speed[i] *= -1.001;
        xspeed[i] *= -1.001;
        speed[c] *= -1.001;
        xspeed[c] *= -1.001;
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
        if (y[c] > height - 250)
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
