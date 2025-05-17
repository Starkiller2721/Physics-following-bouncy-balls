void updatePhysics() 
{
  if (!paused) 
  {
    ArrayList<Particle> particleCopy;
    synchronized (particle)
    {
      particleCopy = new ArrayList<>(particle); // Copy list safely
    }
    for (Particle p : particleCopy) 
    { 
      p.tick(particleCopy);
    }
  }
  delay(10);
}

void startPhysicsThread() 
{
  new Thread(new Runnable() 
  {
    public void run() 
    {
      while (true) 
      {
        updatePhysics();
        delay(10);
      }
    }
  }).start();
}

void saveParticlesToJson(String filename) 
{
  JSONArray particleArray = new JSONArray();

  for (Particle p : particle) 
  {
    JSONObject particleData = new JSONObject();
    particleData.setFloat("x", p.x);
    particleData.setFloat("y", p.y);
    particleData.setFloat("xspeed", p.xspeed);
    particleData.setFloat("yspeed", p.yspeed);
    particleData.setInt("size", p.size);
    particleData.setInt("color", p.ballcolor);  // Store color as an integer
    particleData.setFloat("heat",p.heat);
    
    particleArray.append(particleData);
  }
  
  // Save the array of particles to a file
  saveJSONArray(particleArray, filename);
}

void loadParticlesFromJson(String filename) 
{
  JSONArray particleArray = loadJSONArray(filename);
  particle.clear();  // Clear existing particles

  for (int i = 0; i < particleArray.size(); i++) 
  {
    JSONObject particleData = particleArray.getJSONObject(i);
    float x = particleData.getFloat("x");
    float y = particleData.getFloat("y");
    float xspeed = particleData.getFloat("xspeed");
    float yspeed = particleData.getFloat("yspeed");
    int size = particleData.getInt("size");
    color col = particleData.getInt("color");
    float heat = particleData.getFloat("heat");
    
    Particle p = new Particle(x, y, xspeed, yspeed, size, col, heat);
    
    particle.add(p);
  }
}

void fileSelected(File selection) 
{
  if (selection != null) 
  {
    loadParticlesFromJson(selection.getAbsolutePath());
  }
}

void filePathSelected(File selection) 
{
  if (selection != null) 
  {
    saveParticlesToJson(selection.getAbsolutePath()+".json");
  }
}
