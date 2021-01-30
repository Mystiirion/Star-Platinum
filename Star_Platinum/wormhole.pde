class Worm {
  float iZ = -1000;
  float fZ = 1000;

  float xPos, yPos, zPos;

  float speed = 20 + intensity*3;

  Worm () {
    xPos = random(-width, width);
    yPos = random(-height, height); 
    zPos = random(iZ, fZ);
  }

  void forward() {
    zPos = zPos + speed;
  }

  void show() {
    color strokeColor = color(scoreLow*0.42, scoreMid*0.42, scoreHi*0.42, intensity*12);
    stroke(strokeColor);
    
    for (int theta = 0; theta < 360; theta++) {
      ellipse(map(zPos * cos(theta), 0, 360, 0, xPos) + intensity, map(zPos * sin(theta) + intensity, 0, 360, 0, xPos), map(intensity, 0, 1, 2, 0), map(intensity, 0, 1, 2, 0));
    }

    if (zPos >= fZ) {
      xPos = random(-width, width);
      yPos = random(-height, height); 
      zPos = iZ;
    }
  }
}
