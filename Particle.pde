class Particle
{
  int counter = 0;
  float x, y;
  float xspeed, yspeed, heat, dissapate;
  int size;
  color ballcolor;
  ArrayList<PVector> trail;
  
  Particle(float x, float y, float xspeed, float yspeed, int size, color col, float heat)
  {
    counter++;
    this.x = x;
    this.y = y;
    this.xspeed = xspeed;
    this.yspeed = yspeed;
    this.size = size;
    this.ballcolor = col;
    this.heat = heat;
    dissapate = 5*5.67e-8*(2*PI*size)*300;
    //this.trail = new ArrayList<PVector>();
  }
  
  // New function to calculate acceleration (gravity effects)
  PVector computeAcceleration(ArrayList<Particle> particleCopy) 
  {
    PVector acceleration = new PVector(0, 0);
    
    for (Particle other : particleCopy)
    {
      if (other == this) continue;  // Skip self
      float dx = other.x - this.x;
      float dy = other.y - this.y;
      float distance = sqrt(dx * dx + dy * dy);
      
      float massC = this.size; 
      float massI = other.size;
      float invDistSquared = 1.0 / (dx * dx + dy * dy + 0.01);
      float force = g * massC * massI * invDistSquared;
    
      float unit_x = dx / distance;
      float unit_y = dy / distance;
    
      float xAcceleration = force * unit_x;
      float yAcceleration = force * unit_y;
  
      acceleration.x += xAcceleration;
      acceleration.y += yAcceleration;
    }
  
    return acceleration;
  }
  
  void renderheat()
  {
    noStroke();
    fill(255,0,0,heat*5);
    ellipse(x,y,heat,heat);
  }
  
  void render(ArrayList<Particle> particleCopy)
  {
    noStroke();
    if (particles)
    {
      noStroke();
      fill(ballcolor);
      ellipse(x, y, size, size);
    }

    
    if (labels)
    {
      stroke(255, 0, 0);
      strokeWeight(1);
      line(x, y, x + xspeed*100, y + yspeed*100);
      fill(255);
      text(heat,x+size,y+size);
      
      PVector acc = this.computeAcceleration(particleCopy);
      drawGravityVector(x, y, acc.x, acc.y);
    }
  }
  
  void tick(ArrayList<Particle> particleCopy)
  {
    if (paused) return;
    
    //motion
    x += xspeed / scalefactor;
    y += yspeed / scalefactor;
    heat -= dissapate;
    heat = constrain(heat,0,1000);
    
    if (frameCount % 4 == 0 && heat > 5)
    {
      if (heat > 20)
      {
        excessheat.add( new heatparticle(x,y, heat/8, dissapate*8));
      }
      else
      {
        excessheat.add( new heatparticle(x,y, heat/2, dissapate*4));
      }
    }
    
    if (!no_gravity)
    {
      yspeed += gravity;
    }

    
    //wraps around left and right edges
    if (right)
    {
      if (x > screenX - (size/2))
      { 
        x = screenX - (size/2);
        xspeed *= damping;
        float energylost = xspeed*(1+damping);
        heat += energylost*size*g;
      }
    }
    if (left)
    {
      if (x < -screenX + (size/2))
      {
        x = -screenX + (size / 2 + 2);
        xspeed *= damping;
        float energylost = xspeed*(1+damping);
        heat += energylost*size*g;
      }
    }
  
    //bounces on top and bottom
    if (down)
    {
      if (y > screenY - (size/2))
      {
        y = screenY - (size/2 + 2);
        yspeed *= damping;
        float energylost = yspeed*(1+damping);
        heat += energylost*size*g;
      }
    }
    if (up)
    {
      if (y < -screenY + (size/2))
      {
        y = -screenY + (size/2 + 2);
        yspeed *= damping;
        float energylost = yspeed*(1+damping);
        heat += energylost*size*g;
      }
    }
    if (particle.size() > 1)
    {
      for (Particle other : particleCopy)
      {
        if (this != other)
        {
          
          float dx = other.x - this.x;
          float dy = other.y - this.y;
          float distance = sqrt((float)dx * (float)dx + (float)dy * (float)dy);
          float minDist = (other.size / 2.0) + (this.size / 2.0);

          if (distance < minDist && !paused) 
          {
            
            float overlap = minDist - distance;
            
            //float separationFactor = 0.1;
            other.x += dx / distance * overlap * pushFactor;
            other.y += dy / distance * overlap * pushFactor;
            this.x -= dx / distance * overlap * pushFactor;
            this.y -= dy / distance * overlap * pushFactor;
            
            float massC = pow(this.size, 2);
            float massI = pow(other.size, 2);
            
            float newyspeedC = ((massC - massI) * this.yspeed + 2 * massI * other.yspeed) / (massC + massI);
            float newyspeedI = ((massI - massC) * other.yspeed + 2 * massC * this.yspeed) / (massC + massI);
            float newxspeedC = ((massC - massI) * this.xspeed + 2 * massI * other.xspeed) / (massC + massI);
            float newxspeedI = ((massI - massC) * other.xspeed + 2 * massC * this.xspeed) / (massC + massI);
            
            this.yspeed = newyspeedC;
            other.yspeed = newyspeedI;
            this.xspeed = newxspeedC;
            other.xspeed = newxspeedI;
            
            float elasticity = .96;  // 1.0 = perfect bounce, lower = more energy loss, higher = just don't try it
            
            float energylost = abs(this.xspeed*(1-elasticity)+this.yspeed*(1-elasticity));
            
            this.heat += energylost*size*g;
            
            energylost = abs(other.xspeed*(1-elasticity)+other.yspeed*(1-elasticity));
            
            other.heat += energylost*size*g;
            
            this.xspeed *= elasticity;    
            this.yspeed *= elasticity;
            other.xspeed *= elasticity;
            other.yspeed *= elasticity;
          }
        }
      }
    }
    
    PVector acc = computeAcceleration(particleCopy);
    xspeed += acc.x;
    yspeed += acc.y;
    
    if (mouseAttractMode) {pull(this);}
    
    total += size;
    momentum += ((pow(size, 2) * (abs(yspeed) + abs(xspeed))) / size);
  
    //auto bouncing after pressing f
    if (auto_bounce)
    {
      if (yspeed < 2 && yspeed > -2)
      {
        if (y > height - height / 4)
        {
          yspeed += 40;
        }
      }
      
      if (xspeed < 2 && xspeed > -2)
      {
        if (xspeed > 0)
        {
          xspeed += 30;
        }
        else
        {
          xspeed -= 30;
        }
      }
    }
  }
  
  public float getX() { return this.x; }
  public float getY() { return this.y; }
  public float getXspeed() { return xspeed; }
  public float getYspeed() { return yspeed; }
  public int getSize() { return size; }
}
