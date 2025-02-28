float[] speed = {5, 10, 21};
float[] xspeed = {12, 5, 23};
float[] x = {0, 60, 930};
float[] y = {100, 50, 350};


float gravity = .98;
float damping = .85;

int xspeedChange = 10;
int yspeedChange = 10;
int ballincrease = 1;

boolean auto_bounce = true;
boolean ball_counter = false;

int[] size = {20, 35, 56};

//scalefactor:1
int scalefactor = 1;

int[] ballcolor = {#FF0000, #1CFF00, #FF00EF, #00E8FF, #FF0000};
int[] colors = {#FF0000, #1CFF00, #FF00EF, #7E02E5, #00E8FF, #F6FF00, #FFE043, #0024FF,#FF8D00, #FF6CFF, #FE0002, #41FDFE, #BC13FE, #7e15db};

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
    ellipse(x[c], y[c], size[c], size[c]);
  }

  //drawing a counter of every ball
  if (ball_counter)
  {
    fill(255);
    text(x.length,30, 30);
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
    size = append(size, int(random(20, 60)));
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

  //activates the ball counter
  if (key == 'e' || key == 'E')
  {
    ball_counter = !ball_counter;
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
    if (x[c] > width - (size[c]/2 - 2))
    {
      //x[c] = size[c];
      
      x[c] = width - size[c];
      xspeed[c] *= damping;
    }
    else if (x[c] < (size[c]/2 + 2))
    {
      //x[c] = width - size[c];
      
      x[c] = size[c];
      xspeed[c] *= damping;
    }
  
    //bounces on top and bottom
    if (y[c] > height - (size[c]/2 - 2))
    {
      y[c] = height - (size[c]/2 - 2);
      speed[c] *= damping;
    }
    else if (y[c] < (size[c]/2 + 2))
    {
      y[c] = (size[c]/2 + 2);
      speed[c] *= damping;
    }

    if (x.length > 1)
    {
      for (int i = 0; i < x.length; i++)
      {
        if (i != c) // Prevent self-collision
        {
          float dx = x[i] - x[c];
          float dy = y[i] - y[c];
          float distance = sqrt(dx * dx + dy * dy);
          float minDist = (size[i] / 2.0) + (size[c] / 2.0);

          if (distance < minDist) 
          {
            float overlap = minDist - distance;
            x[i] += dx / distance * overlap / 2;
            y[i] += dy / distance * overlap / 2;
            x[c] -= dx / distance * overlap / 2;
            y[c] -= dy / distance * overlap / 2;
            
            float massC = pow(size[i] / 2.0, 2); // mass proportional to volume
            float massI = pow(size[i] / 2.0, 2);
            
            float newSpeedC = ((massC - massI) * speed[c] + 2 * massI * speed[i]) / (massC + massI);
            float newSpeedI = ((massI - massC) * speed[i] + 2 * massC * speed[c]) / (massC + massI);
            float newXspeedC = ((massC - massI) * xspeed[c] + 2 * massI * xspeed[i]) / (massC + massI);
            float newXspeedI = ((massI - massC) * xspeed[i] + 2 * massC * xspeed[c]) / (massC + massI);
            
            speed[c] = newSpeedC;
            speed[i] = newSpeedI;
            xspeed[c] = newXspeedC;
            xspeed[i] = newXspeedI;
          }
        }
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
