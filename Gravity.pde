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
        float massC = size[c];
        float massI = size[i];
        
        float force = (g * massC * massI) / (d * d);  // Gravitational force

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
