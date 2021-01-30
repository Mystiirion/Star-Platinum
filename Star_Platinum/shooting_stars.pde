class shootingStar {
  float x; 
  float y;
  float z;

  float pz;

  float speed = 10 + intensity*0.75;

  shootingStar() {
    x = random(-width, width);
    y = random(-height, height);
    z = random(width);

    pz = z; //reset the star trails
  }

  void update() {
    z = z - speed;

    if (z < 1) {
      x = random(-width, width);
      y = random(-height, height);
      z = random(width);

      pz = z;
    }
  }

  void show() {
    fill(255 - intensity/2);
    noStroke();

    float sx = map(x / z, 0, 1, 0, width);
    float sy = map(y / z, 0, 1, 0, height);

    float r = map(z, 0, width, 16, 0);
    ellipse(sx, sy, r, r);

    float px = map(x / pz, 0, 1, 0, width);
    float py = map(y / pz, 0, 1, 0, height);

    stroke(255 - 3*intensity);
    line(px, py, sx, sy); //star trails
  }
}
