void drawGravityVector(float x, float y, float forceX, float forceY) 
{
    float baseLength = 10;  // Minimum length for weak forces
    float maxLineLength = 1e5;  // Max length for extreme forces
    float forceMagnitude = dist(0, 0, forceX, forceY);

    // Nonlinear mapping: Weak forces get boosted, extreme ones are capped
    float scaleFactor = map(sqrt(forceMagnitude), 0, sqrt(1000), baseLength, maxLineLength);  
    scaleFactor = constrain(scaleFactor, baseLength, maxLineLength);

    float normX = (forceX / forceMagnitude) * scaleFactor;
    float normY = (forceY / forceMagnitude) * scaleFactor;

    stroke(0, 255, 0);
    strokeWeight(1);
    line(x, y, x + normX, y + normY);
}

void pull(Particle p)
{
  if (dist(p.x, p.y, mouseX, mouseY) < 200)
  {
    float dx = mouseX - p.x;
    float dy = mouseY - p.y;
    float distance = sqrt(dx * dx + dy * dy);
    
    float massC = p.size; 
    float massI = 40;
    float invDistSquared = 1.0 / (dx * dx + dy * dy + 0.01);
    float force = g * massC * massI * invDistSquared;
  
    float unit_x = dx / distance;
    float unit_y = dy / distance;
  
    float xAcceleration = force * unit_x;
    float yAcceleration = force * unit_y;
    
    p.xspeed += xAcceleration;
    p.yspeed += yAcceleration;
  }
}
