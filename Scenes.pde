class RiceCookerScene implements Scene {
  Dispenser dispensers[] = new Dispenser[3];
  
  RiceCookerScene() {
    dispensers[0] = new Dispenser(150, 150, "brown rice", #ff873b);
    dispensers[1] = new Dispenser(300, 150, "white rice", #FFFFFF);
    dispensers[2] = new Dispenser(450, 150, "water", #0066ff);
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
    // background ellipse
    g.noStroke();
    g.fill(#FFFFFF);
    g.ellipse(width/2, height-cornerPoint-bowlHeight, width-cornerPoint-cornerRadius/4, 100);
    
    // mush
    g.fill(#0000FF);
    g.ellipse(width/2, height-cornerPoint-bowlHeight+50, width-cornerPoint-cornerRadius/4, 100);
  }
  
  void drawBowlFront(PGraphics g) {
    // upper rectangle
    g.noStroke();
    g.fill(#FFFFFF);
    g.rect(cornerPoint-cornerRadius/2, height-cornerPoint-bowlHeight, width-cornerPoint-cornerRadius/4, bowlHeight);
    
    // mush
    g.fill(#0000FF);
    g.ellipse(width/2, height-cornerPoint-bowlHeight+25, width-cornerPoint-cornerRadius/4, 100);
    
    // bottom ellipse
    g.fill(#FFFFFF);
    g.ellipse(width/2, height-cornerPoint, width-cornerPoint-cornerRadius/4, 100);
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


