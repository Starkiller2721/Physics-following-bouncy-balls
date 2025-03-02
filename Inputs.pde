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
    text("Success", 30, 30);
  }
}
