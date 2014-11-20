import processing.video.*;

Capture video;
boolean lastState = false;
int counter = 0;

void setup() {
  size(640, 480);
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
      println(counter);
      lastState = false;
    }
    lastState = state;
 }
}

boolean findDot() {
    int dotX = -1;
    int dotY = -1;
    int index = 0;
    for (int y = 0; y < video.height; y++) {
      for (int x = 0; x < video.width; x++) {
        int pixelValue = video.pixels[index];
        color pixelColor = color(pixelValue);
        float red = red(pixelColor);
        float green = green(pixelColor);
        float blue = blue(pixelColor);
        if(
           green > 120 && 
           blue < 110 && 
           red < 110
           ){    
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

