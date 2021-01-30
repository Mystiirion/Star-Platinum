import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;
AudioPlayer song;
FFT fft; // song analyzer

float specLow = 0.03; //3%
float specMid = 0.125; // 12.5%
float specHi = 0.2; // 20%

//rest of sound spectrum is not used because they are too high for human ears

float scoreLow = 0;
float scoreMid = 0;
float scoreHi = 0;

float oldScoreLow = scoreLow;
float oldScoreMid = scoreMid;
float oldScoreHi = scoreHi;

float scoreDecreaseRate = 25;

float intensity;

//*****************  setup  ***************************************
Cube[] c = new Cube[100];
Worm[] worms = new Worm[10];
shootingStar[] sStars = new shootingStar[700];

void setup() {
  //size(1920, 1080, P3D); //best full screen on beefy computers
  size(960, 540, P3D); //tiny tinsy traptop laptops
  
  minim =  new  Minim ( this );
  song = minim.loadFile ("jojo.mp3");
  fft =  new FFT(song.bufferSize(), song.sampleRate());
  
  for (int i = 0; i < c.length; i++) {
    c[i] = new Cube();
  }
  
  for (int i = 0; i < worms.length; i++) {
    worms[i] = new Worm();
  }
  
  for (int i = 0; i < sStars.length; i++) {
    sStars[i] = new shootingStar();
  }
  
  song.play();
}

//*****************  draw  ********************************************

void draw() {
  background(0);
  
  fft.forward (song.mix);
  
  //save old values
  oldScoreLow = scoreLow;
  oldScoreMid = scoreMid;
  oldScoreHi = scoreHi;
  
  //reset the values
  scoreLow = 0;
  scoreMid = 0;
  scoreHi = 0;
  
  //intensity measures
  for (int i = 0; i < c.length * worms.length; i++) {
    intensity = fft.getBand(i%((int)(fft.specSize()*specHi)));
    //intensity = fft.specSize()*specHi;
  }
  
  //new scores calculation
  for (int i = 0; i < fft.specSize()*specLow; i++) {
    scoreLow = scoreLow + fft.getBand(i);
  }
  
  for (int i = (int)(fft.specSize()*specLow); i < fft.specSize()*specMid; i++) {
    scoreMid += fft.getBand(i);
  }
  
  for (int i = (int)(fft.specSize()*specMid); i < fft.specSize()*specHi; i++) {
    scoreHi += fft.getBand(i);
  }
  
  //slows down descent
  if (oldScoreLow > scoreLow) {
    scoreLow = oldScoreLow - scoreDecreaseRate;
  }
  
  if (oldScoreMid > scoreMid) {
    scoreMid = oldScoreMid - scoreDecreaseRate;
  }
  
  if (oldScoreHi > scoreHi) {
    scoreHi = oldScoreHi - scoreDecreaseRate;
  }

//***************************** cam movement  *************************************************
  float eyeX = width/2;
  float eyeY = height/2;
  
  float moveSpeed = map(intensity, specLow, specHi, 0, 10);
  float updatedEX = eyeX + moveSpeed/5;
  float updatedEY = eyeY + moveSpeed/5;
  
  float maxEZ = 1000;
  float focalZ = 0;
  
  camera(updatedEX, updatedEY, maxEZ,   //eye changes = cam movement
         width/2, height/2, focalZ,      //focal point
         0, 1, 0);                  //nonsense up positions, idk what they do
  
  if (updatedEX > eyeX + 10) {
    updatedEX = eyeX - cos(moveSpeed/5);
  }
  
  if (updatedEX < eyeX + 10) {
    updatedEX = eyeX + cos(moveSpeed/5);
  }
  
  if (updatedEY > eyeY + 10) {
    updatedEY = eyeY - sin(moveSpeed/5);
  }
  
  if (updatedEY < eyeY - 10) {
    updatedEY = eyeY + sin(moveSpeed/5);
  }
  
//*****************************  space elements  ****************************
  translate(width/2, height/2);

  for (int i = 0; i < worms.length; i++) {
    worms[i].show();
    worms[i].forward();
  }
  
  for (int i = 0; i < sStars.length; i++) {
    sStars[i].update();
    sStars[i].show();;
  }
  
  for (int i = 0; i < c.length; i++) {    
    c[i].show();
    c[i].forward();
  }
  
  //println(intensity);
  //println(fft.getBand(1));
  //println(fft.specSize());
  
//***************************  saving images/frame  **************************************
  //save("testImage.png");
  //saveFrame("output/star_###.png");
}
