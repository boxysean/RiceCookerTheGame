class RiceCookerScene implements Scene {
  Dispenser dispensers[] = new Dispenser[3];
  
  RiceCookerScene() {
    dispensers[0] = new Dispenser(150, 150, "brown rice");
    dispensers[1] = new Dispenser(300, 150, "white rice");
    dispensers[2] = new Dispenser(450, 150, "water");
  }
  
  void draw(PGraphics g) {
    for (int i = 0; i < 3; i++) {
      dispensers[i].draw(g);
    }
    
    drawBowl(g);
  }
  
  void drawBowl(PGraphics g) {
    arc(width/2, height/2, 3*width/4, 3*height/4, 0, PI);
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


