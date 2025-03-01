float[] speed = {5};
float[] xspeed = {0};
float[] x = {960};
float[] y = {100};

float gravity = .98;
float damping = 0.6;
float pushFactor = 0.6;

int xspeedChange = 10;
int yspeedChange = 10;
int ballincrease = 10;
int maxsize = 30;
int minsize = 10;

boolean auto_bounce = false;
boolean ball_counter = false;
boolean no_gravity = true;

int[] size = {20};
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

  for (int c = 0; c < y.length; c++)
  {
    ballcolor[c] = colors[int(random(0,colors.length))];
  }
}

void draw()
{
  background(0);
  
  ball();
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


void mousePressed()
{
  float x2 = (float) mouseX;
  float y2 = (float) mouseY;
  
  for (int i = 0; i < ballincrease; i++)
  {
    x = append(x, x2);
    y = append(y, y2);
    speed = append(speed, int(random(-30, 30)));
    xspeed = append(xspeed, int(random(-30, 30)));
    ballcolor = append(ballcolor, colors[int(random(0,colors.length))]);
    size = append(size, int(random(minsize, maxsize)));
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
  
  //toggles ball counter
  if (key == 'e' || key == 'E')
  {
    ball_counter = !ball_counter;
  }
  
  //toggles gravity
  if (key == 'g' || key == 'G')
  {
    no_gravity = !no_gravity;
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
      speed[c] += gravity;
      damping = -0.9;
      g = 6.674e-3;
    
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
      damping = -.6;
      g = 6.674e-2;
    }
  
    //wraps around left and right edges
    if (x[c] > width - (size[c]/2 - 2))
    {
      //x[c] = size[c];
      
      x[c] = width - size[c] / 2 - 2;
      xspeed[c] *= damping;
    }
    else if (x[c] < (size[c]/2 + 2))
    {
      //x[c] = width - size[c];
      
      x[c] = size[c] / 2 + 2;
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
    
    //fill(255);
    //text(speed[0], 30, 30);
    
    //bounces off of other objects
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
            
            x[i] += dx / distance * overlap * pushFactor;
            y[i] += dy / distance * overlap * pushFactor;
            x[c] -= dx / distance * overlap * pushFactor;
            y[c] -= dy / distance * overlap * pushFactor;
            
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
            
            xspeed[c] *= 0.98;  
            speed[c] *= 0.98;
            
            float elasticity = 0.9;  // 1.0 = perfect bounce, lower = more energy loss
            xspeed[c] *= elasticity;
            speed[c] *= elasticity;
            xspeed[i] *= elasticity;
            speed[i] *= elasticity;
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

void gravity()
{
  for (int c = 0; c < x.length; c ++)
  {
    for (int i = 0; i < x.length; i++)
    {
      if (c == i) continue; // Avoid self-gravity

      float d = dist(x[c], y[c], x[i], y[i]);

      if (d > 0)  // Avoid division by zero
      {
        float force = (g * size[c] * size[i]) / (d * d);  // Gravitational force

        // Unit vector direction
        float unit_x = (x[i] - x[c]) / d;
        float unit_y = (y[i] - y[c]) / d;

        // Apply acceleration
        float xAcceleration = force * unit_x;
        float yAcceleration = force * unit_y;

        xspeed[c] += xAcceleration;
        speed[c] += yAcceleration;
      }
    }
  }
}
