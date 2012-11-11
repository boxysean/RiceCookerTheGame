class RiceCookerScene implements Scene {
  Dispenser dispensers[] = new Dispenser[3];
  
  PImage bowlBackImage;
  PImage bowlFrontImage;
  
  RiceCookerScene() {
    dispensers[0] = new Dispenser(350, 150, "water", #0066ff, 0.8, 400, 164, 40, 40, waterImage);
    dispensers[1] = new Dispenser(250, 200, "white rice", #FFFFFF, 0.9, 309, 215, 45, 45, whiteRiceImage);
    dispensers[2] = new Dispenser(150, 250, "brown rice", #ff873b, 1.0, 215, 269, 50, 50, brownRiceImage);
  }
  
  void setup() {
    bowlBackImage = loadImage("images/bowl-back.png");
    bowlFrontImage = loadImage("images/bowl-front.png");
  }
  
  void draw(PGraphics g) {
    drawBowlBack(g);
    
    for (int i = 0; i < 3; i++) {
      dispensers[i].draw(g);
    }
    
    drawBowlFront(g);
  }
  
  int cornerPoint = 125;
  int cornerRadius = 100;
  int bowlHeight = 150;
  
  void drawBowlBack(PGraphics g) {
    g.pushMatrix();
    g.scale(0.75);
    g.image(bowlBackImage, 235, 480);
    g.popMatrix();
  }
  
  void drawBowlFront(PGraphics g) {
//    // bottom ellipse
//    g.fill(#FFFFFF);
//    g.ellipse(width/2, height-cornerPoint, width-cornerPoint-cornerRadius/4, 100);

    g.pushMatrix();
    g.scale(0.75);
    g.image(bowlFrontImage, 229, 535);
    g.popMatrix();
  }
  
  void drawBowl(PGraphics g) {
    // 
  }
  
  boolean onMousePressed(int x, int y) {
    for (int i = 0; i < dispensers.length; i++) {
      if (dispensers[i].faucet.onMousePressed(x, y)) {
        return true;
      }
    }
    
    return false;
  }

  boolean onMouseDragged(int x, int y) {
    for (int i = 0; i < dispensers.length; i++) {
      if (dispensers[i].faucet.onMouseDragged(x, y)) {
        return true;
      }
    }
    
    return false;
  }

  boolean onMouseReleased(int x, int y) {
    for (int i = 0; i < dispensers.length; i++) {
      if (dispensers[i].faucet.onMouseReleased(x, y)) {
        return true;
      }
    }
    
    return false;
  }
}


