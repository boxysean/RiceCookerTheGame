int MAX_RATE = 100;

class Dispenser {
  float x, y;
  String type;
  int streamColour;
  
  Dial dial;
  Faucet faucet;
  
  Dispenser(float x, float y, String type, int streamColour) {
    this.type = type;
    this.x = x;
    this.y = y;
    this.streamColour = streamColour;
    
    dial = new Dial(x, y-75, 25, this);
    faucet = new Faucet(x, y, 50, this);
  }
  
  void draw(PGraphics g) {
    dial.amount += faucet.rate;
    
    drawStream(g);
    dial.draw(g);
    faucet.draw(g);
  }
  
  void drawStream(PGraphics g) {
    if (faucet.rate > 0) {
      float percent = (float) faucet.rate / MAX_RATE;
      noStroke();
      fill(streamColour);
      rect(x-(faucet.r*percent*.75), y, (faucet.r*percent*.75)*2, 250);
    }
  }
}

class Faucet implements Clickable {
  float x, y, r;
  int rate;
  Dispenser dispenser;
  
  int initialPressY = 0;
  
  boolean mouseIsPressed = false;
  
  Faucet(float x, float y, float r, Dispenser dispenser) {
    this.x = x;
    this.y = y;
    this.r = r;
    this.dispenser = dispenser;
  }
  
  void draw(PGraphics g) {
    g.stroke(#000000);
    g.ellipseMode(CENTER);
    g.fill(100);
    g.ellipse(x, y, r*2, r*2);
    
    float cx = x + sin((float) rate / MAX_RATE * PI * 1.9) * r;
    float cy = y - cos((float) rate / MAX_RATE * PI * 1.9) * r;
    
    g.line(x, y, cx, cy);
  }
  
  void setRate(int newRate) {
    rate = newRate;
  }
  
  boolean onMousePressed(int x, int y) {
    if (dist(x, y, this.x, this.y) < r) {
      mouseIsPressed = true;
      initialPressY = y - rate;
      return true;
    }
    
    return false;
  }
  
  boolean onMouseDragged(int x, int y) {
    if (mouseIsPressed) {
      int newRate = min(max(y - initialPressY, 0), MAX_RATE);
      setRate(newRate);
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

class Dial {
  float x, y, r;
  Dispenser dispenser;
  
  int amount = 0;
  
  Dial(float x, float y, float r, Dispenser dispenser) {
    this.x = x;
    this.y = y;
    this.r = r;
    this.dispenser = dispenser;
  }
  
  void draw(PGraphics g) {
    g.stroke(#000000);
    g.ellipseMode(CENTER);
    g.fill(200);
    g.ellipse(x, y, r*2, r*2);
    
    int cups = amount / 1000;
    int frac = amount % 1000;
    
    float cupsX = x + sin((float) cups / 10 * PI * 2) * r;
    float cupsY = y - cos((float) cups / 10 * PI * 2) * r;
    
    g.strokeWeight(3);
    g.stroke(#ff0000);
    g.line(x, y, cupsX, cupsY);
    
    float fracX = x + sin((float) frac / 1000 * PI * 2) * r;
    float fracY = y - cos((float) frac / 1000 * PI * 2) * r;
    
    g.strokeWeight(2);
    g.stroke(#00ff00);
    g.line(x, y, fracX, fracY);
  }
}
