int MAX_RATE = 100;

class Faucet implements Clickable {
  float x, y, r;
  float rate;
  String type;
  
  int initialPressY = 0;
  
  boolean mouseIsPressed = false;
  
  Faucet(float x, float y, float r, String type) {
    this.x = x;
    this.y = y;
    this.r = r;
    this.type = type;
  }
  
  void draw(PGraphics g) {
    g.ellipseMode(CENTER);
    g.fill(100);
    g.ellipse(x, y, r*2, r*2);
    
  }
  
  void setRate(float newRate) {
    rate = newRate;
  }
  
  boolean onMousePressed(int x, int y) {
    if (dist(x, y, this.x, this.y) < r) {
      mouseIsPressed = true;
      initialPressY = y;
      return true;
    }
    
    return false;
  }
  
  boolean onMouseDragged(int x, int y) {
    if (mouseIsPressed) {
      int newRate = min(max(y - initialPressY, 0), MAX_RATE);
      setRate(newRate);
      println(type + " " + newRate);
      return true;
    }
    
    return false;
  }
  
  boolean onMouseReleased(int x, int y) {
    if (mouseIsPressed) {
      mouseIsPressed = false;
      return true;
    }
    
    return false;
  }
}
