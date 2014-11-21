import processing.video.*;

Capture video;
boolean lastState = false;
int counter = 0;
float activeHue = 0.0;
color activeColor = color(0,0,0);
PFont f;


void setup() {
  size(640, 480);
  f = createFont("Arial",16,true);
  video = new Capture(this, width, height);
  video.start();  
  noStroke();
  smooth();
}

void draw() {
  if (video.available()) {
    video.read();
    image(video, 0, 0, width, height);
    video.loadPixels();
    boolean state = findDot();
    if(lastState && !state){
      counter++;
    }
    lastState = state;
    drawActiveHue();
    drawCounter();
 }
}

void drawCounter(){
  textFont(f,156);
  fill(255, 255, 255, 100);
  text(counter, 300,200);  
}

boolean findDot() {
    int dotX = -1;
    int dotY = -1;
    int index = 0;
    int maxPixels = video.pixels.length - 1;
    for (int y = 0; y < video.height; y++) {
      for (int x = 0; x < video.width; x++) {
        int pixelValue1 = video.pixels[index];
        int pixelValue2 = video.pixels[(index == maxPixels) ? index : index + 1];
        color pixelColor1 = color(pixelValue1);
        color pixelColor2 = color(pixelValue2);
        color pixelColor = lerpColor(pixelColor1, pixelColor2, 0.5);
        if(isMatchingColor(pixelColor, activeColor)){
          dotY = y;
          dotX = x;          
        }
        index++;
      }
    }
    
    if(0 <= dotX && 0 <= dotY){
      fill(255, 204, 0, 128);
      ellipse(dotX, dotY, 100, 100);
      return true;
    }
    
    return false;  
}

void drawActiveHue(){
  fill(activeColor);
  rect(0, 0, 50, 50);  
  
}

void mouseClicked(){
  int pixelValue1 = video.pixels[mouseY*video.width+mouseX];
  color color1 = color(pixelValue1);
  activeColor = color1;
}

boolean isMatchingColor(color color1, color color2){
  int threshold = 7;
  return 
    abs(red(color1) - red(color2)) < threshold &&
    abs(green(color1) - green(color2)) < threshold &&
    abs(blue(color1) - blue(color2)) < threshold;
  
}




