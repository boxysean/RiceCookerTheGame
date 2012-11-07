class RiceCookerScene implements Scene {
  Faucet[] faucets = new Faucet[3];
  
  RiceCookerScene() {
    faucets[0] = new Faucet(100, 100, 50, "white rice");
    faucets[1] = new Faucet(300, 100, 50, "brown rice");
    faucets[2] = new Faucet(500, 100, 50, "water");
  }
  
  void draw(PGraphics g) {
    for (Faucet f : faucets) {
      f.draw(g);
    }
  }
  
  boolean onMousePressed(int x, int y) {
    for (int i = 0; i < faucets.length; i++) {
      if (faucets[i].onMousePressed(x, y)) {
        return true;
      }
    }
    
    return false;
  }

  boolean onMouseDragged(int x, int y) {
    for (int i = 0; i < faucets.length; i++) {
      if (faucets[i].onMouseDragged(x, y)) {
        return true;
      }
    }
    
    return false;
  }

  boolean onMouseReleased(int x, int y) {
    for (int i = 0; i < faucets.length; i++) {
      if (faucets[i].onMouseReleased(x, y)) {
        return true;
      }
    }
    
    return false;
  }
}


