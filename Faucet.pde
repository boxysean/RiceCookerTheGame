int MAX_RATE = 100;
int MAX_REMAINING = 5000;

PImage reservoirImage;
PImage reservoirShadowImage;
PImage tapImage;

PImage brownRiceImage, whiteRiceImage, waterImage;

PImage keepWarmTextImage;
PImage cookTextImage;
PImage onoffTextImage;

PImage flameImage;

class Dispenser {
  float x, y;
  String type;
  int streamColour;
  float scaleFactor;
  PImage contentsImage;
  
  Faucet faucet;
  
  RiceCookerScene rcScene;
  
  int remaining = MAX_REMAINING;
  int spill = 0;
  int amount = 0;
  
  Dispenser(float x, float y, String type, int streamColour, int streamHeight, float scaleFactor, int px, int py, int pw, int ph, PImage contentsImage, RiceCookerScene rcScene) {
    this.type = type;
    this.x = x;
    this.y = y;
    this.scaleFactor = scaleFactor;
    this.contentsImage = contentsImage;
    this.rcScene = rcScene;
    
    faucet = new Faucet(x, y, 50, this, streamColour, streamHeight, px, py, pw, ph);
    
    remask();
  }
  
  void draw(PGraphics g) {
    if (faucet.rate > 0) {
      int prevRemaining = remaining;
      remaining = max(remaining - faucet.rate, 0);
      
      if (rcScene.lid.on) {
        spill += prevRemaining - remaining;
      } else {
        amount += prevRemaining - remaining;
      }
      
      if (prevRemaining - remaining != 0) {
        remask();
      }
    }
    
    g.pushMatrix();
    
    g.translate(x, y);
    g.scale(scaleFactor * 0.5);
    
    drawContents(g);
    
    g.image(reservoirImage, -reservoirImage.width/2, -reservoirImage.height/2);
    g.image(tapImage, 80, 80);
    
    faucet.draw(g);
    
    g.popMatrix();
  }
  
  void remask() {
    pushMatrix();
    resetMatrix();
    PGraphics pg = createGraphics(contentsImage.width, contentsImage.height, P2D);
    pg.background(#000000);
    pg.image(reservoirShadowImage, 0, 0);
    pg.fill(#000000);
    float h = map(remaining, MAX_REMAINING, 0, 100, 465);
    pg.rect(0, 0, contentsImage.width, h);
    contentsImage.mask(pg);
    popMatrix();
  }    

  void drawContents(PGraphics g) {
    g.image(contentsImage, -reservoirImage.width/2, -reservoirImage.height/2);
  }
}

class Faucet implements Clickable {
  float x, y, r;
  int rate;
  Dispenser dispenser;
  int streamColour, streamHeight;
  
  int px, py, pw, ph;
  
  int initialPressY = 0;
  
  boolean mouseIsPressed = false;
  
  Faucet(float x, float y, float r, Dispenser dispenser, int streamColour, int streamHeight, int px, int py, int pw, int ph) {
    this.x = x;
    this.y = y;
    this.r = r;
    this.dispenser = dispenser;
    this.streamHeight = streamHeight;
    this.streamColour = streamColour;
    
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
    
    // tap
    
    g.rect(-50, -8, 100, 16);
    g.rect(-8, -50, 16, 100);
    
    g.popMatrix();
    
    drawStream(g);

//    // Draw click area    
//    g.pushMatrix();
//    g.resetMatrix();
//    g.stroke(#FF0000);
//    g.noFill();
//    g.rect(px, py, pw, ph);
//    g.popMatrix();
  }
  
  void drawStream(PGraphics g) {
    g.pushMatrix();
    
    if (rate > 0 && dispenser.remaining > 0) {
      float percent = (float) rate / MAX_RATE;
      g.noStroke();
      g.fill(red(streamColour), green(streamColour), blue(streamColour), (int) (map(percent, 0, 1, 0.5, 1) * 255));
      g.rect(179, 197, 30, streamHeight);
    }
    
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

class Burner implements Clickable {
  boolean on, keepWarm, cook;
  
  Burner() {
    keepWarmTextImage = loadImage("images/text-keepwarm.jpg");
    cookTextImage = loadImage("images/text-cook.jpg");
    onoffTextImage = loadImage("images/text-onoff.jpg");
    
    flameImage = loadImage("images/flame.png");
  }
  
  void draw(PGraphics g) {
    pushMatrix();
    
    translate(135, 630);
    
    // flames
    
    if (on && cook) {
        for (int i = 110; i < 290; i += 30) {
          g.image(flameImage, i, -65);
        }
    }
    
    // burner
    
    g.stroke(#303030);
    g.fill(#716869);
    g.strokeWeight(5);
    g.rect(0, 0, 400, 100);
    
    // grill
    
    g.noStroke();
    g.fill(#303030);
    g.rect(100, -30, 5, 30);
    g.rect(150, -30, 5, 30);
    g.rect(200, -30, 5, 30);
    g.rect(250, -30, 5, 30);
    g.rect(300, -30, 5, 30);
    g.rect(100, -30, 200, 5);
    
    // buttons
    
    g.strokeWeight(5);
    g.stroke(#A0A0A0);
    
    // on/off button
    
    if (on) {
      g.fill(#FF3333);
    } else {
      g.fill(#663333);
    }
    
    g.image(onoffTextImage, 55, 20);
    g.ellipse(100, 70, 30, 30);
    
    // cook button
    
    if (on && cook) {
      g.fill(#FF3333);
    } else {
      g.fill(#663333);
    }
    
    g.image(cookTextImage, 153, 18);
    g.ellipse(200, 70, 30, 30);
    
    // keep warm
    
    if (on && keepWarm) {
      g.fill(#FF3333);
    } else {
      g.fill(#663333);
    }
    
    g.image(keepWarmTextImage, 250, 22);
    g.ellipse(300, 70, 30, 30);
    
    popMatrix();
  }

  boolean onMousePressed(int x, int y) {  
    // on/off button
    
    if (220 <= x && x < 255 && 687 <= y && y < 717) {
      cook = false;
      keepWarm = false;
      on = !on;
      return true;
    }
    
    // cook button
    
    if (on && 322 <= x && x < 352 && 687 <= y && y < 717) {
      cook = !cook;
      
      sceneChange = true;
      
      return true;
    }
    
    // keep warm button
    
    if (on && 418 <= x && x < 449 && 687 <= y && y < 717) {
      keepWarm = !keepWarm;
      return true;
    }
    
    return false;
  }

  boolean onMouseDragged(int x, int y) {
    return false;
  }

  boolean onMouseReleased(int x, int y) {
    return false;
  }

}

class Lid implements Clickable {
  PImage lidImage;
  PImage lidRotImage;
  
  boolean on = false;
  
  int x = 165, y = 360;
  int xrot = 500, yrot = 300;
  
  Lid() {
    lidImage = loadImage("images/lid.png");
    lidRotImage = loadImage("images/lidRot.png");
  }
  
  void draw(PGraphics g) {
    if (on) {
      g.image(lidImage, x, y);
    } else {
      g.image(lidRotImage, xrot, yrot);
    }
  }
  
  boolean onMousePressed(int x, int y) {
    if (on && this.x <= x && x < this.x + lidImage.width && this.y <= y && y < this.y + lidImage.height) {
      on = !on;
      return true;
    } else if (!on && this.xrot <= x && x < this.xrot + lidRotImage.width && this.yrot <= y && y < this.yrot + lidRotImage.height) {
      on = !on;
      return true;
    }
    
    return false;
  }
  
  boolean onMouseDragged(int x, int y) {
    return false;
  }
  
  boolean onMouseReleased(int x, int y) {
    return false;
  }
}
