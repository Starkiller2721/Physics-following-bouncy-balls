void GUI()
{
  fill(#555555);
  rectMode(CORNERS);
  rect(0, height, width, height - 50);
  
  //gravity buttons
  fill(255);
  text("Gravity", 2, height - 30);
  text("constant", 2, height - 20);
  
  if (button1[0])
  {
    fill(#C90000);
  }
  else
  {
    fill(255);
  }
  rect(50, height - 40, 100, height - 10);
  fill(0);
  text("6.674e-4", 53, height - 20);
  
  if (button1[1])
  {
    fill(#C90000);
  }
  else
  {
    fill(255);
  }
  rect(105, height - 40, 155, height - 10);
  fill(0);
  text("6.674e-3", 108, height - 20);
  
  if (button1[2])
  {
    fill(#C90000);
  }
  else
  {
    fill(255);
  }
  rect(160, height - 40, 210, height - 10);
  fill(0);
  text("6.674e-2", 163, height - 20);
  
  //speed buttons
  fill(255);
  text("Sim", 220, height -30);
  text("Speed",220, height -20);
  
  if (button2[0])
  {
    fill(#C90000);
  }
  else
  {
    fill(255);
  }
  rect(260, height -40, 290, height-10);
  fill(0);
  text("1X",269,height -20);
  
  if (button2[1])
  {
    fill(#C90000);
  }
  else
  {
    fill(255);
  }
  rect(295, height -40, 325, height-10);
  fill(0);
  text("2X",304,height -20);
  
  if (button2[2])
  {
    fill(#C90000);
  }
  else
  {
    fill(255);
  }
  rect(330, height -40, 360, height-10);
  fill(0);
  text("4X",339,height -20);
  
  if (button2[3])
  {
    fill(#C90000);
  }
  else
  {
    fill(255);
  }
  rect(365, height -40, 395, height-10);
  fill(0);
  text("1/2X",367,height -20);
  
  //ball increase amount
  fill(255);
  text("Ball", 400, height -30);
  text("Increase",400, height -20);
  
  if (button3[0])
  {
    fill(#C90000);
  }
  else
  {
    fill(255);
  }
  rect(450, height -40, 480, height-10);
  fill(0);
  text("1",462,height -20);
  
  if (button3[1])
  {
    fill(#C90000);
  }
  else
  {
    fill(255);
  }
  rect(485, height -40, 515, height-10);
  fill(0);
  text("10",493,height -20);
  
  if (button3[2])
  {
    fill(#C90000);
  }
  else
  {
    fill(255);
  }
  rect(520, height -40, 550, height-10);
  fill(0);
  text("50",528,height -20);
  
  if (button3[3])
  {
    fill(#C90000);
  }
  else
  {
    fill(255);
  }
  rect(555, height -40, 585, height-10);
  fill(0);
  text("100",563,height -20);
  
  //debug mode toggle 
  if(button4)
  {
    fill(255,0,0);
  }
  else
  {
    fill(255);
  }
  rect(615, height-40, 660, height-10);
  fill(0);
  text("Debug", 620,height-25);
  text("Mode", 620, height-15);
  
  //Particles
  if(button5)
  {
    fill(255,0,0);
  }
  else
  {
    fill(255);
  }
  rect(675, height-40, 730, height-10);
  fill(0);
  text("Particles",680,height-20);
  
  //orbital mode
  if(button6)
  {
    fill(255,0,0);
  }
  else
  {
    fill(255);
  }
  rect(750, height-40, 795, height-10);
  fill(0);
  text("Orbital", 755,height-25);
  text("Mode", 755, height-15);
  
  //Follow mode
  if (follow) {fill(255, 0, 0);} // Red when following a particle
  
  else if (readyfollow) {fill(255, 165, 0);} // Orange when selecting a particle
  
  else {fill(255);} // White when inactive
  
  rect(820, height - 40, 865, height-10);
  fill(0);
  text("Follow", 825, height - 25);
  text("Mode", 825, height - 15);
  
  //halt all velocity button
  if (button8) {fill(255, 0, 0);}
  
  else {fill(255);}
  
  rect(880,height-40,925,height-10);
  fill(0);
  text("Halt all", 883, height-25);
  text("Velocity", 883, height-15);
  
  //mouse attract mode
  if (button9) {fill(255,0,0);}
  
  else {fill(255);}
  
  rect(940,height-40, 985, height-10);
  fill(0);
  text("Attract", 945, height-25);
  text("mode", 945, height-15);
  
  //load/export projects button
  if (button10[0]) {fill(255,0,0);}
  
  else {fill(255);}
  
  rect(1000,height-40, 1045, height-10);
  fill(0);
  text("Settings", 1002, height-20);
  
  if (setting)
  {
    fill(#555555);
    rect(1000,height-50,1055,height-120);
    
    //save button
    fill(255);
    rect(1005,height-115, 1050, height-85);
    fill(0);
    text("Save", 1015, height-95);
    
    //load button
    fill(255);
    rect(1005,height-80, 1050, height-50);
    fill(0);
    text("Load", 1015, height-60);
  }
}
