class heatparticle
{
  float x,y, heat, shrink;
  
  heatparticle(float tempx, float tempy, float tempheat, float tempshrink)
  {
    x = tempx;
    y = tempy;
    heat = tempheat;
    shrink = tempshrink;
  }
  
  void shrink()
  {
    heat -= shrink;
    
    if (heat < 5)
    {
      excessheat.remove(this);
    }
  }
  
  void display()
  {
    fill(255,0,0,heat*10);
    ellipse(x,y, heat*3,heat*3);
  }
}
