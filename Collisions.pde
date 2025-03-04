void collision()
{
  for (int c = 0; c < y.length; c++)
    {
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
              
              float massC = pow(size[c], 2);
              float massI = pow(size[i], 2);
              
              // Store initial momentum for debugging
              float initialMomentumX = massC * xspeed[c] + massI * xspeed[i];
              float initialMomentumY = massC * speed[c] + massI * speed[i];
              
              float newSpeedC = ((massC - massI) * speed[c] + 2 * massI * speed[i]) / (massC + massI);
              float newSpeedI = ((massI - massC) * speed[i] + 2 * massC * speed[c]) / (massC + massI);
              float newXspeedC = ((massC - massI) * xspeed[c] + 2 * massI * xspeed[i]) / (massC + massI);
              float newXspeedI = ((massI - massC) * xspeed[i] + 2 * massC * xspeed[c]) / (massC + massI);
              
              speed[c] = newSpeedC;
              speed[i] = newSpeedI;
              xspeed[c] = newXspeedC;
              xspeed[i] = newXspeedI;
              
              float elasticity = 0.9;  // 1.0 = perfect bounce, lower = more energy loss
              xspeed[c] *= elasticity;
              speed[c] *= elasticity;
              xspeed[i] *= elasticity;
              speed[i] *= elasticity;
              
              // Store final momentum for debugging
              float finalMomentumX = massC * xspeed[c] + massI * xspeed[i];
              float finalMomentumY = massC * speed[c] + massI * speed[i];
              
              // Round momentum change to avoid floating-point artifacts
              float momentumChangeX = finalMomentumX - initialMomentumX;
              float momentumChangeY = finalMomentumY - initialMomentumY;
              
              // Debugging output
              //println("Collision between", c, i);
              //println("Initial Momentum:", initialMomentumX, initialMomentumY);
              //println("Final Momentum:", finalMomentumX, finalMomentumY);
              //println("Momentum Change:", finalMomentumX - initialMomentumX, finalMomentumY - initialMomentumY);
              //println();
            }
          }
        }
      }
    }
}
