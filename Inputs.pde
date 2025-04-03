void mouseWheel(MouseEvent event) 
{
  float zoomFactor = 1.1;  // Scale factor per scroll step
  float prevZoom = zoom;   // Store previous zoom level
  float newZoom = event.getCount() > 0 ? zoom / zoomFactor : zoom * zoomFactor;

  // Compute world coordinates of the mouse BEFORE zooming
  float worldMouseX = (mouseX - width / 2) / prevZoom + cameraX;
  float worldMouseY = (mouseY - height / 2) / prevZoom + cameraY;

  // Apply zoom
  zoom = newZoom;

  // Compute new camera position to keep the same world position under the mouse
  cameraX = int(worldMouseX - (mouseX - width / 2) / zoom);
  cameraY = int(worldMouseY - (mouseY - height / 2) / zoom);
}


void mousePressed() 
{
  if (!paused) 
  {
    if (!readyfollow)
    {
      if (mouseY < height - 50 && !orbital) 
      {
        float x2 = ((mouseX - width / 2) / zoom) + cameraX;
        float y2 = ((mouseY - height / 2) / zoom) + cameraY;

        for (int i = 0; i < ballincrease; i++) 
        {
          if (ballincrease > 1)
          {
            particle.add(new Particle(x2 + int(random(-100, 100)), y2 + int(random(-100, 100)), 0, 0, int(random(minsize, maxsize)), color(colors[int(random(0, colors.length))])));
            
          }
          else
          {
            particle.add(new Particle(x2, y2, 0, 0, int(random(minsize, maxsize)), color(colors[int(random(0, colors.length))])));
          }
        }
      } 
      else if (mouseY < height - 50 && orbital && ballincrease == 1) 
      {
        float x2 = ((mouseX - width / 2) / zoom) + cameraX;
        float y2 = ((mouseY - height / 2) / zoom) + cameraY;

        // Find the closest particle
        int closestIndex = -1;
        float minDistance = Float.MAX_VALUE;

        for (int i = 0; i < particle.size(); i++) 
        {
          float d = dist(x2, y2, particle.get(i).x, particle.get(i).y);
          if (d < minDistance) 
          {
            minDistance = d;
            closestIndex = i;
          }
        }

        // Ensure a valid particle is found and minimum safe distance
        if (closestIndex != -1 && minDistance > 10) 
        {  
          Particle closest = particle.get(closestIndex);
          float xc = closest.x;
          float yc = closest.y;
          float mass_c = closest.size;
          int mass_p = int(random(minsize, maxsize));

          float totalMass = mass_c + mass_p;

          // **Increase Initial Distance Slightly** to prevent instant collision
          float safeDistance = minDistance * 1.2f;
          float angle = atan2(y2 - yc, x2 - xc);
          x2 = xc + cos(angle) * safeDistance;
          y2 = yc + sin(angle) * safeDistance;

          // **Calculate Orbital Velocity**  
          float v_orb = sqrt(g * totalMass / safeDistance);  

          // Get perpendicular direction for orbit
          float dx = x2 - xc;
          float dy = y2 - yc;
          float mag = sqrt(dx * dx + dy * dy) + 0.0001f; 

          // Normalize and rotate 90 degrees (Counterclockwise)
          float vx = (-dy / mag) * v_orb;
          float vy = (dx / mag) * v_orb;

          // Assign velocities based on mass ratios
          float v1x = vx * (mass_p / totalMass);
          float v1y = vy * (mass_p / totalMass);
          float v2x = -vx * (mass_c / totalMass);
          float v2y = -vy * (mass_c / totalMass);

          // **Velocity Clamp to Prevent Instability**  
          float maxvelocity = 50;
          v1x = constrain(v1x, -maxvelocity, maxvelocity);
          v1y = constrain(v1y, -maxvelocity, maxvelocity);
          v2x = constrain(v2x, -maxvelocity, maxvelocity);
          v2y = constrain(v2y, -maxvelocity, maxvelocity);

          // Apply velocity to the closest particle
          closest.xspeed += v1x;
          closest.yspeed += v1y;

          // Add new orbiting particle
          particle.add(new Particle(x2, y2, v2x, v2y, mass_p, color(colors[int(random(0, colors.length))])));
        }
      }
    }

    // **Handle Follow Mode**  
    float worldMouseX = ((mouseX - width / 2) / zoom) + cameraX;
    float worldMouseY = ((mouseY - height / 2) / zoom) + cameraY;

    if (readyfollow) 
    {
      for (int c = 0; c < particle.size(); c++) 
      {
        Particle p = particle.get(c);
        float px = p.x;
        float py = p.y;
        float radius = p.size / 2;

        // Compare world coordinates instead of screen coordinates
        if (worldMouseX > px - radius && worldMouseX < px + radius && worldMouseY > py - radius && worldMouseY < py + radius) 
        {
          follower = c;  // Store the selected particle
          follow = true;  // Enable following
          readyfollow = false;  // Exit ready mode
          break;
        }
      }
    }
  }

  
  if (gui)
  {
    if (mouseX > 50 && mouseX < 100 && mouseY > height - 40 && mouseY < height - 10)
    {
      button1[0] = true;
      g = 6.674e-4;
      for (int c = 0; c < button1.length; c ++)
      {
        if (button1[c] && c != 0)
        {
          button1[c] = !button1[c];
        }
      }
    }
    else if (mouseX > 105 && mouseX < 155 && mouseY > height - 40 && mouseY < height - 10)
    {
      button1[1] = true;
      g = 6.674e-3;
      for (int c = 0; c < button1.length; c ++)
      {
        if (button1[c] && c != 1)
        {
          button1[c] = !button1[c];
        }
      }
    }
    else if (mouseX > 160 && mouseX < 210 && mouseY > height - 40 && mouseY < height - 10)
    {
      button1[2] = true;
      g = 6.674e-2;
      for (int c = 0; c < button1.length; c ++)
      {
        if (button1[c] && c != 2)
        {
          button1[c] = !button1[c];
        }
      }
    }
    
    if(mouseX > 260 && mouseX < 290 && mouseY > height - 40 && mouseY < height - 10)
    {
      button2[0] = true;
      scalefactor = 1;
      for (int c = 0; c < button2.length; c ++)
      {
        if (button2[c] && c != 0)
        {
          button2[c] = !button2[c];
        }
      }
    }
    else if(mouseX > 295 && mouseX < 325 && mouseY > height - 40 && mouseY < height - 10)
    {
      button2[1] = true;
      scalefactor = 2;
      for (int c = 0; c < button2.length; c ++)
      {
        if (button2[c] && c != 1)
        {
          button2[c] = !button2[c];
        }
      }
    }
    else if(mouseX > 330 && mouseX < 360 && mouseY > height - 40 && mouseY < height - 10)
    {
      button2[2] = true;
      scalefactor = 4;
      for (int c = 0; c < button2.length; c ++)
      {
        if (button2[c] && c != 2)
        {
          button2[c] = !button2[c];
        }
      }
    }
    else if(mouseX > 365 && mouseX < 395 && mouseY > height - 40 && mouseY < height - 10)
    {
      button2[3] = true;
      scalefactor = .5;
      for (int c = 0; c < button2.length; c ++)
      {
        if (button2[c] && c != 3)
        {
          button2[c] = !button2[c];
        }
      }
    }
    
    if(mouseX > 450 && mouseX < 480 && mouseY > height - 40 && mouseY < height - 10)
    {
      button3[0] = true;
      ballincrease = 1;
      for (int c = 0; c < button3.length; c ++)
      {
        if (button3[c] && c != 0)
        {
          button3[c] = !button3[c];
        }
      }
    }
    else if(mouseX > 485 && mouseX < 515 && mouseY > height - 40 && mouseY < height - 10)
    {
      button3[1] = true;
      ballincrease = 10;
      for (int c = 0; c < button3.length; c ++)
      {
        if (button3[c] && c != 1)
        {
          button3[c] = !button3[c];
        }
      }
    }
    else if(mouseX > 520 && mouseX < 550 && mouseY > height - 40 && mouseY < height - 10)
    {
      button3[2] = true;
      ballincrease = 50;
      for (int c = 0; c < button3.length; c ++)
      {
        if (button3[c] && c != 2)
        {
          button3[c] = !button3[c];
        }
      }
    }
    else if(mouseX > 555 && mouseX < 585 && mouseY > height - 40 && mouseY < height - 10)
    {
      button3[3] = true;
      ballincrease = 100;
      for (int c = 0; c < button3.length; c ++)
      {
        if (button3[c] && c != 3)
        {
          button3[c] = !button3[c];
        }
      }
    }
    if(mouseX > 615 && mouseX < 660 && mouseY > height-40 && mouseY < height-10)
    {
      button4 = !button4;
      labels = !labels;
    }
    
    if(mouseX > 675 && mouseX < 725 && mouseY > height-40 && mouseY < height-10)
    {
      button5 = !button5;
      particles = !particles;
    }
    
    if(mouseX > 750 && mouseX < 795 && mouseY > height-40 && mouseY < height-10)
    {
      button6 = !button6;
      orbital = !orbital;
    }
    
    if (mouseX > 820 && mouseX < 865 && mouseY > height - 40 && mouseY < height - 10) 
    {
      if (!follow && !readyfollow)  // If follow mode is off, prepare to select
      { 
        readyfollow = true;
        button7 = true;
      } 
      else // If follow mode is already active, turn it off
      {  
        follow = false;
        readyfollow = false;
        button7 = false;
      }
    }
  }
}

void keyPressed()
{
  if (key == 'm') 
  {
    mouseAttractMode = !mouseAttractMode;
  }

  
  if ((key == 'w' || key == 'W') && !Key.contains('w'))
  {
    Key.add('w');
  }
  if ((key == 's' || key == 'S') && !Key.contains('s'))
  {
    Key.add('s');
  }
  if ((key == 'a' || key == 'A') && !Key.contains('a'))
  {
    Key.add('a');
  }
  if ((key == 'd' || key == 'D') && !Key.contains('d'))
  {
    Key.add('d');
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
    particle.clear();
  }
  
  if (key == 'v' || key == 'V')
  {
    controls = !controls;
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
  
  if (key == ENTER)
  {
    paused = !paused;
  }
  
  if (key == 'x' || key == 'X')
  {
    gui = !gui;
  }
  
  if (key == 't' || key == 'T')
  {
    smalldebug = !smalldebug;
  }
}

void keyReleased()
{
  if (key == 'w' || key == 'W')
  {
    for (int c = 0; c < Key.size(); c ++)
    {
      if (Key.get(c) == 'w')
      {
        Key.remove(c);
      }
    }
  }
  if (key == 's' || key == 'S')
  {
    for (int c = 0; c < Key.size(); c ++)
    {
      if (Key.get(c) == 's')
      {
        Key.remove(c);
      }
    }
  }
  if (key == 'a' || key == 'A')
  {
    for (int c = 0; c < Key.size(); c ++)
    {
      if (Key.get(c) == 'a')
      {
        Key.remove(c);
      }
    }
  }
  if (key == 'd' || key == 'D')
  {
    for (int c = 0; c < Key.size(); c ++)
    {
      if (Key.get(c) == 'd')
      {
        Key.remove(c);
      }
    }
  }
}
