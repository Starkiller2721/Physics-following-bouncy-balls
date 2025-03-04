void mousePressed()
{
  float x2 = (float) mouseX;
  float y2 = (float) mouseY;
  
  for (int i = 0; i < ballincrease; i++)
  {
    x = append(x, x2);
    y = append(y, y2);
    speed = append(speed, int(random(-10, 10)));
    xspeed = append(xspeed, int(random(-10, 10)));
    ballcolor = append(ballcolor, colors[int(random(0,colors.length))]);
    size = append(size, int(random(minsize, maxsize)));
  }
}

void keyPressed()
{
  
  //moves ball faster horizontally
  if (key == 's' || key == 'S')
  {
    gdwn = true;
    gleft = false;
    gright = false;
    gup = false;
  }
  if (key == 'w' || key == 'W')
  {
    gdwn = false;
    gleft = false;
    gright = false;
    gup = true;
  }
  if (key == 'a' || key == 'A')
  {
    gdwn = false;
    gleft = true;
    gright = false;
    gup = false;
  }
  if (key == 'd' || key == 'D')
  {
    gdwn = false;
    gleft = false;
    gright = true;
    gup = false;
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
  
  //walls
  if (keyCode == UP)
  {
    up = !up;
  }
  else if (keyCode == DOWN)
  {
    down = !down;
  }
  else if (keyCode == RIGHT)
  {
    right = !right;
  }
  else if (keyCode == LEFT)
  {
    left = !left;
  }
  
  //Scale Factor
  if (key == 'r' || key == 'R')
  {
    if (scalefactor == 1)
    {
      scalefactor = 2;
    }
    else if (scalefactor == 2)
    {
      scalefactor = 4;
    }
    else if (scalefactor == 4)
    {
      scalefactor = 8;
    }
    else if (scalefactor == 8)
    {
      scalefactor = .2;
    }
    else if (scalefactor == .2)
    {
      scalefactor = .5;
    }
    else
    {
      scalefactor = 1;
    }
  }
  
  if (key == 'q' || key == 'Q')
  {
    if (ballincrease == 1)
    {
      ballincrease = 5;
    }
    else if (ballincrease == 5)
    {
      ballincrease = 10;
    }
    else if (ballincrease == 10)
    {
      ballincrease = 50;
    }
    else if (ballincrease == 50)
    {
      ballincrease = 100;
    }
    else
    {
      ballincrease = 1;
    }
  }
  
  if (key == 'c' || key == 'C')
  {
    controls = !controls;
  }
  
  if (key == 't' || key == 'T')
  {
    if (g == 6.674e-4)
    {
      g = 6.674e-2;
    }
    else if (g == 6.674e-2)
    {
      g = 6.674e-3;
    }
    else
    {
      g = 6.674e-4;
    }
  }
  
  if (key == '+')
  {
    if (maxsize == 10)
    {
      maxsize = 20;
    }
    else if (maxsize == 20)
    {
      maxsize = 30;
    }
    else if (maxsize == 30)
    {
      maxsize = 40;
    }
    else if (maxsize == 40)
    {
      maxsize = 50;
    }
    else if (maxsize == 50)
    {
      maxsize = 60;
    }
    else if (maxsize == 60)
    {
      maxsize = 100;
    }
    else
    {
      maxsize = 10;
    }
  }
  
  if (key == '-')
  {
    if (minsize == 5)
    {
      minsize = 10;
    }
    else if (minsize == 10)
    {
      minsize = 20;
    }
    else if (minsize == 20)
    {
      minsize = 30;
    }
    else if (minsize == 30)
    {
      minsize = 40;
    }
    else if (minsize == 40)
    {
      minsize = 50;
    }
    else if (minsize == 50)
    {
      minsize = 60;
    }
    else
    {
      minsize = 5;
    }
  }
  
  if (key == 'l' || key == 'L')
  {
    labels = !labels;
  }
}
