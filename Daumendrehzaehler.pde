import processing.video.*;

Capture video;
PFont f;
Player player1;
Player player2;
int threshold = 7;
int radius = 100;


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
	
	if(player1.isActive())
	{
		boolean beenSeen = false;
		Position newPos = null;
	    for (int y = player1.getPosition().y - radius; y < min(player1.getPosition().y + radius, video.height); y++) {
	      for (int x = player1.getPosition().x - radius; x < min(player1.getPosition().x + radius, video.width); x++) {
			int index = y * video.width + x;
	        int pixelValue1 = video.pixels[index];
	        color pixelColor1 = color(pixelValue1);
	        if(isMatchingColor(pixelColor1, player1.getColor())){
				
				//TODO: validation of multiple candidates -> probabilistic comparison
			  beenSeen = true;
			  newPos = new Position(x, y);
			  break;
	        }
			if(newPos != null) {
				break;
			}
	      }
	    }
		if(!player1.isVisible() && beenSeen) {
			player1.count();
		}
		player1.setVisible(beenSeen);
		if(beenSeen)
		{
			player1.setPosition(newPos);
		}
	}
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
  player.setPosition(mouseX, mouseY);
}

boolean isMatchingColor(color color1, color color2){
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
  private boolean active;
  
  public Player(){
    this.count = 0;
    this.activeColor = color(0,0,0);
    this.visible = false;
    this.position = new Position(0,0);
    this.active = false;
  } 
  
  public void setActive(boolean active){
    this.active = active;
  }
  
  public boolean isActive(){
    return this.active;  
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
  
  public void setPosition(Position pos){
    this.position = pos;
  }
  
  public Position getPosition() {
	  return this.position;
  }
  
  public void drawTrackingPoint(){
    if(!this.active) return;
    if(this.visible){
      fill(255, 204, 0, 128);
      ellipse(this.position.x, this.position.y, radius, radius);
    }
  }
  
}






