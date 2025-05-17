//Dylan King
//Physics Simulation

import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import processing.data.*;
import processing.sound.*;

ArrayList<Particle> particle = new ArrayList<Particle>();
ArrayList<heatparticle> excessheat = new ArrayList<heatparticle>();

ArrayList<Character> Key = new ArrayList<Character>();

float gravity = .98;
//perfect bounce = .969
float damping = .6;
float pushFactor = 0.7;

int ballincrease = 0;
int maxsize = 10;
int minsize = 4;
int temptotal = 0;

boolean auto_bounce = false;
boolean ball_counter = false;
boolean no_gravity = true;
boolean controls = true;
boolean labels = true;
boolean paused = false;
boolean gui = true;
boolean split = false;
boolean particles = true;
boolean orbital = false;
boolean smalldebug = false;
boolean mouseAttractMode = false;
boolean setting = false;
boolean[] button1 = {true, false, false};
boolean[] button2 = {true, false, false, false};
boolean[] button3 = {false, false, false, false};
boolean button4 = true;
boolean button5 = true;
boolean button6 = false;
boolean button7 = false;
boolean button8 = false;
boolean button9 = false;
boolean[] button10 = {false,false,false};

//walls
boolean left = true;
boolean right = true;
boolean up = true;
boolean down = true;

ArrayList<Integer> bigger = new ArrayList<Integer>();
ArrayList<Integer> delete = new ArrayList<Integer>();
ArrayList<Float> tempx = new ArrayList<Float>();
ArrayList<Float> tempy = new ArrayList<Float>();
ArrayList<Integer> size = new ArrayList<Integer>();
float g = 6.674e-4;

//scalefactor:1, scalefactor controls the sim yspeed
float scalefactor = 1;

int[] colors = {#FF0000, #1CFF00, #FF00EF, #7E02E5, #00E8FF, #F6FF00, #FFE043, #0024FF, #FF8D00, #FF6CFF, #FE0002, #41FDFE, #BC13FE, #7e15db};

float average = 0;
float total = 0;
float momentum = 0;

//camera movement
float cameraY = 0;
float cameraX = 0;
float zoom = 1;
int screenX = 20000;
int screenY = 20000;
int movement = 20;
float worldMouseX = 0;
float worldMouseY = 0;
boolean readyfollow = false;
boolean follow = false;
int follower = 0;

float simtime = 0;

int fpsSamples = 60; // Number of frames to average
float[] fpsHistory = new float[fpsSamples];
int fpsIndex = 0;
boolean fpsFilled = false;
float avgFPS = 0;

SoundFile file;

void setup()
{
  /*
  size(700,1000);
  surface.setTitle("Particle Physics Simulation");
  surface.setResizable(true);
  */
  
  fullScreen();
  
  particle.add(new Particle(300, 200, 0, 0, int(random(minsize,maxsize)), color(colors[int(random(0,colors.length))]),0));

  frameRate(60);
  noStroke();
  //size(600, 600);
  damping /= -1;
  //background(0);
  ellipseMode(CENTER);
  
  startPhysicsThread();
}

void draw() 
{
  
  if (frameCount % 60 == 0)
  {
    if (scalefactor == 1)
    {
      simtime ++;
    }
    else if (scalefactor == 2)
    {
      simtime += .5;
    }
    else if (scalefactor == 4)
    {
      simtime += .25;
    }
    else if (scalefactor == .5)
    {
      simtime += 2;
    }
  }
  
  rectMode(CENTER);
  background(0);
  
  fpsHistory[fpsIndex] = frameRate;
  fpsIndex = (fpsIndex + 1) % fpsSamples;
  
  if (fpsIndex == 0) 
  {
    fpsFilled = true; // Mark when the array is filled
  }
  
  int count = fpsFilled ? fpsSamples : fpsIndex;
  for (int i = 0; i < count; i++) {
    avgFPS += fpsHistory[i];
  }
  avgFPS /= count;
  
  // Creating white borders to outline the edge of the simulation
  strokeWeight(1);

  // Apply transformations
  translate(width / 2, height / 2); // Move to center of screen
  scale(zoom); // Apply zooming
  translate(-cameraX, -cameraY); // Adjust for camera movement
  
  worldMouseX = (width / 2) / zoom + cameraX;
  worldMouseY = (height / 2) / zoom + cameraY;

  stroke(255);
  strokeWeight(10);
  line(screenX / -1, screenY / -1, screenX, screenY / -1);
  line(screenX, screenY / -1, screenX, screenY);
  line(screenX / -1, screenY, screenX, screenY);
  line(screenX / -1, screenY / -1, screenX / -1, screenY);
  
  noStroke();
  
  if (maxsize < minsize) 
  {
    maxsize = minsize + 5;
  }
  
  momentum = 0;
  average = 0;
  total = 0;
  
  ArrayList<heatparticle> excessheatcopy = new ArrayList<heatparticle>(excessheat);
  for (heatparticle h : excessheatcopy)
  {
    if (h != null)
    {
      h.display();
      h.shrink();
    }
  }
  ArrayList<Particle> particleCopy;
  synchronized (particle)
  {
    particleCopy = new ArrayList<>(particle); // Copy list safely
  }
  for (Particle p : particleCopy) 
  { 
    p.renderheat();
  }
  for (Particle p : particleCopy) 
  { 
    p.render(particleCopy);
  }
  
  noStroke();
  
  average = total / particle.size();
  
  if(!follow)
  {
    for (int c = 0; c < Key.size();c ++)
    {
      if (Key.get(c) == 'w')
      {
        cameraY -= movement/zoom;
      }
      if(Key.get(c) == 's')
      {
        cameraY += movement/zoom;
      }
      if (Key.get(c) == 'a')
      {
        cameraX -= movement/zoom;
      }
      if (Key.get(c) == 'd')
      {
        cameraX += movement/zoom;
      }
    }
  }
  if (follow && follower >= 0 && follower < particle.size()) 
  {
    cameraX = particle.get(follower).getX();  // Access x using the getter
    cameraY = particle.get(follower).getY();  // Access y using the getter
  }

  
  //drawing information
  
  pushMatrix();
    resetMatrix();
    fill(255);
    textSize(15);
    
    text("Simulation time: " + int(simtime), 22, height-75);
    
    //display the current time
    if(hour() >= 10) {text(hour()%12+":",22,height-60);}
    
    else {text(hour()%12+":",30,height-60);}
    
    if(minute() < 10) {text("0" + minute(), 40, height-60);}
    
    else {text(minute(),40,height-60);}
    
    if(hour()>12) {text("PM",55,height-60);}
    
    else {text("AM",55,height-60);}
    
    textSize(14);
    fill(0);
    if (ball_counter)
    {
      rect(25,20,125,65);
      fill(255);
      text(particle.size() + " Particles",30, 30);
      text(scalefactor + "X yspeed", 30, 40);
      text(ballincrease + " Ball Increase", 30, 50);
      text(frameRate + " FPS", 30, 60);
      text("Overall Mass = " + average, 30, 70);
      text("Combined Mass = " + total, 30, 80);
      text("Gravity constant = " + g, 30, 90);
      text("Maxsize = " + maxsize, 30, 100);
      text("Minsize = " + minsize, 30, 110);
      text("average FPS = " + avgFPS, 30, 120);
    }
    
    if (controls)
    {
      fill(255);
      text("F = autobounce", 1700, 30);
      text("E = Stats", 1700, 40);
      text("R = Change yspeed", 1700, 50);
      text("Q = Increase Change", 1700, 60);
      text("G = Toggle Gravity", 1700, 70);
      text("WASD = move camera", 1700, 80);
      text("Click = Place Particles", 1700, 90);
      text("C = clear particles", 1700, 100);
      text("X = UI panel", 1700, 110);
      text("+ = maxsize increase", 1700, 120);
      text("- = minsize increase", 1700, 130);
      text("V = This Panel", 1700, 140);
    }
    
    textSize(12);
    if (gui)
    {
      GUI();
    }
  popMatrix();
}
