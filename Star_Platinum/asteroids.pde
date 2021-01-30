class Cube {
  float iZ = -1000;
  float fZ = 1000;

  float xPos, yPos, zPos;

  float theta = random(0, 2*PI + 1);
  float speed = 10;
  
  float rotX;
  float rotY;
  float rotZ;

  Cube () {
    xPos = random(-width, width);
    yPos = random(-height, height); 
    zPos = random(iZ, fZ);
    
  }

  void forward() {
    zPos = zPos + speed;
  }

  void show() {
    color strokeColor = color(255, 150 - 20*intensity);
    stroke(strokeColor);
    
    stroke(0);
    
    color displayColor = color(scoreLow*0.69, scoreMid*0.69, scoreHi*0.69, intensity*5);
    fill(displayColor, 255);
    
    //float size = map(zPos, 0, width, 0, 15); //increaase size of cubes as they approach screen

    pushMatrix();
    translate(xPos, yPos, zPos);
    
    rotX += intensity * theta/1000;
    rotY += intensity * theta/1000;
    rotZ += intensity * theta/1000;
    
    rotateX(rotX);
    rotateY(rotY);
    rotateZ(rotZ);
    
    box(50 + intensity);
    popMatrix();

    if (zPos >= fZ) {
      xPos = random(-width, width);
      yPos = random(-height, height); 
      zPos = iZ;
    }
  }
}
