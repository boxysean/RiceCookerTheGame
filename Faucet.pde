int MAX_RATE = 100;

PImage reservoirImage;
PImage tapImage;

PImage brownRiceImage, whiteRiceImage, waterImage;

class Dispenser {
  float x, y;
  String type;
  int streamColour;
  float scaleFactor;
  PImage contents;
  
  Dial dial;
  Faucet faucet;
  
  Dispenser(float x, float y, String type, int streamColour, float scaleFactor, int px, int py, int pw, int ph, PImage contents) {
    this.type = type;
    this.x = x;
    this.y = y;
    this.streamColour = streamColour;
    this.scaleFactor = scaleFactor;
    this.contents = contents;
    
    dial = new Dial(x, y-75, 25, this);
    faucet = new Faucet(x, y, 50, this, px, py, pw, ph);
  }
  
  void draw(PGraphics g) {
    dial.amount += faucet.rate;
    
    drawStream(g);
    
    g.pushMatrix();
    
    g.translate(x, y);
    g.scale(scaleFactor * 0.5);
    
    g.image(reservoirImage, -reservoirImage.width/2, -reservoirImage.height/2);
    g.image(tapImage, 80, 80);
    
    faucet.draw(g);
    
    g.popMatrix();
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
  
  int px, py, pw, ph;
  
  int initialPressY = 0;
  
  boolean mouseIsPressed = false;
  
  Faucet(float x, float y, float r, Dispenser dispenser, int px, int py, int pw, int ph) {
    this.x = x;
    this.y = y;
    this.r = r;
    this.dispenser = dispenser;
    
    this.px = px;
    this.py = py;
    this.pw = pw;
    this.ph = ph;
  }
  
  void draw(PGraphics g) {
    g.pushMatrix();
    
    g.fill(#000000);
    g.noStroke();
    
    g.translate(180, 90);
    g.rotate(PI/4);
    g.rotate(PI * rate / 100);
    
    g.rect(-50, -8, 100, 16);
    g.rect(-8, -50, 16, 100);
    
    g.popMatrix();
    
    g.pushMatrix();
    g.resetMatrix();
    g.stroke(#FF0000);
    g.noFill();
    g.rect(px, py, pw, ph);
    g.popMatrix();
  }
  
  void setRate(int newRate) {
    rate = newRate;
  }
  
  boolean onMousePressed(int x, int y) {
    if (px <= x && x < px + pw && py <= y && y < py + ph) {
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
