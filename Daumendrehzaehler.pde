import processing.video.*;

Capture video;
PFont f;
Player player1;


void setup() {
  size(640, 480);
  f = createFont("Arial",16,true);
  video = new Capture(this, width, height);
  video.start();  
  player1 = new Player();
  noStroke();
  smooth();
}

void draw() {
  if (video.available()) {
    video.read();
    image(video, 0, 0, width, height);
    video.loadPixels();
    boolean visible = findDot(player1);
    if(player1.isVisible() && !visible){
      player1.count();
    }
    player1.setVisible(visible);
    drawActiveHue(player1);
    drawCounter(player1);
 }
}

void drawCounter(Player player){
  textFont(f,156);
  fill(255, 255, 255, 100);
  text(player.getCount(), 300,200);  
}

boolean findDot(Player player) {
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
        if(isMatchingColor(pixelColor, player.getColor())){
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

void drawActiveHue(Player player){
  fill(player.getColor());
  rect(0, 0, 50, 50);  
  
}

void mouseClicked(){
  int pixelValue1 = video.pixels[mouseY*video.width+mouseX];
  color color1 = color(pixelValue1);
  player1.setColor(color1);
}

boolean isMatchingColor(color color1, color color2){
  int threshold = 7;
  return 
    abs(red(color1) - red(color2)) < threshold &&
    abs(green(color1) - green(color2)) < threshold &&
    abs(blue(color1) - blue(color2)) < threshold;
  
}

class Player{
 
  private color activeColor;
  private int count;
  private boolean visible;
  
  public void Player(){
    this.count = 0;
    this.activeColor = color(0,0,0);
    this.visible = false;
  } 
  
  public boolean isVisible(){
    return this.visible;  
  }
  
  public void setVisible(boolean visible){
    this.visible = visible;
  }
  
  public color getColor(){
    return this.activeColor; 
  }
  
  public void setColor(color newColor){
    this.activeColor = newColor; 
  }
  
  public void resetCount(){
    this.count = 0;  
  }
  
  public int getCount(){
    return this.count; 
  }
  
  public void count(){
    this.count++;  
  }
  
}




