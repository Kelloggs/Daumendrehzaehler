import processing.video.*;

Capture video;
PFont f;
Player player1;
Player player2;


void setup() {
  size(640, 480);
  f = createFont("Arial",16,true);
  video = new Capture(this, width, height);
  video.start();  
  player1 = new Player();
  player2 = new Player();
  
  noStroke();
  smooth();
}

void draw() {
  if (video.available()) {
    video.read();
    image(video, 0, 0, width, height);
    video.loadPixels();
    findDot(player1, player2);
    
    player1.drawTrackingPoint();
    player2.drawTrackingPoint();
    
    drawActiveHue(player1, 0, 0);
    drawActiveHue(player2, 590, 0);
    drawCounter(player1, 100, 80);
    drawCounter(player2, 450, 80);
 }
}

void drawCounter(Player player, int x, int y){
  if(!player.isActive()) return;
  textFont(f,106);
  fill(player.getColor());
  text(player.getCount(), x, y);  
}

void findDot(Player player1, Player player2) {
    int dotX = -1;
    int dotY = -1;
    int index = 0;
    int maxPixels = video.pixels.length - 1;
    player1.startCheck();
    player2.startCheck();
    for (int y = 0; y < video.height; y++) {
      for (int x = 0; x < video.width; x++) {
        int pixelValue1 = video.pixels[index];
        int pixelValue2 = video.pixels[(index == maxPixels) ? index : index + 1];
        color pixelColor1 = color(pixelValue1);
        color pixelColor2 = color(pixelValue2);
        color pixelColor = lerpColor(pixelColor1, pixelColor2, 0.5);
        if(isMatchingColor(pixelColor, player1.getColor())){
          player1.setPosition(x, y);
          player1.check();
        }
        if(isMatchingColor(pixelColor, player2.getColor())){
          player2.setPosition(x, y);
          player2.check();
        }
        index++;
      }
    }
    player1.stopCheck();
    player2.stopCheck();
}

void drawActiveHue(Player player, int x, int y){
  if(!player.isActive()) return;
  fill(player.getColor());
  rect(x, y, 50, 50);  
  
}

void mouseClicked(){
  int pixelValue1 = video.pixels[mouseY*video.width+mouseX];
  color color1 = color(pixelValue1);
  Player player = (mouseButton == RIGHT) ? player2 : player1;
  player.setActive(true);
  player.setColor(color1);
}

boolean isMatchingColor(color color1, color color2){
  int threshold = 7;
  return 
    abs(red(color1) - red(color2)) < threshold &&
    abs(green(color1) - green(color2)) < threshold &&
    abs(blue(color1) - blue(color2)) < threshold;
  
}

class Position {
  public int x = 0;
  public int y = 0;
  
  public Position(int x, int y){
    this.x = x;
    this.y = y;  
  }
  
  public void update(int x, int y){
    this.x = x;
    this.y = y;
  }
 
}

class Player{
 
  private color activeColor;
  private int count;
  private boolean visible;
  private Position position;
  private boolean checking;
  private boolean foundDuringCheck;
  private boolean active;
  
  public Player(){
    this.count = 0;
    this.activeColor = color(0,0,0);
    this.visible = false;
    this.position = new Position(0,0);
    this.checking = false;
    this.foundDuringCheck = false;
    this.active = false;
  } 
  
  public void setActive(boolean active){
    this.active = active;
  }
  
  public boolean isActive(){
    return this.active;  
  }
  
  public void startCheck(){
    if(!this.active) return;
    this.checking = true;
    this.foundDuringCheck = false;
  }
  
  public void check(){
    if(!this.active) return;
    this.foundDuringCheck = true;  
  }
  
  public void stopCheck(){
    if(!this.active) return;
    if(this.visible && !this.foundDuringCheck){
      this.count();
    }
    this.visible = this.foundDuringCheck;  
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
  
  public void setPosition(int x, int y){
    this.position.update(x, y);  
  }
  
  public void drawTrackingPoint(){
    if(!this.active) return;
    if(this.visible){
      fill(255, 204, 0, 128);
      ellipse(this.position.x, this.position.y, 100, 100);
    }
  }
  
}






