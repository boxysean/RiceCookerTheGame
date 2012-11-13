Scene scenes[] = new Scene[3];

boolean sceneChange = false;
int sceneIdx = 0;
int sceneFade = 0;

void setup() {
  size(600, 800);
  smooth();
  
  reservoirImage = loadImage("images/reservoir.png");
  reservoirShadowImage = loadImage("images/reservoirShadow.png");
  tapImage = loadImage("images/tap.png");
  
  brownRiceImage = loadImage("images/ricegrain_brown.jpg");
  whiteRiceImage = loadImage("images/ricegrain_white.jpg");
  waterImage = loadImage("images/water.jpg");
  
  scenes[0] = new RiceCookerScene();
  scenes[1] = new WaitScene((RiceCookerScene) scenes[0]);
  scenes[2] = new FinalScene();
  
  sceneChange = false;
  sceneIdx = 0;
  sceneFade = 0;
}

void draw() {
  background(200);
  scenes[sceneIdx].draw(g);
  
  if (sceneChange) {
    switch (sceneIdx) {
    case 0:
      fill(color(0, 0, 0, map(++sceneFade, 0, 100, 0, 192)));
      rect(0, 0, width, height);
      if (sceneFade == 100) {
        sceneFade = 0;
        sceneIdx++;
        sceneChange = false;
        
        RiceCookerScene rcScene = (RiceCookerScene) scenes[0];
        WaitScene waitScene = (WaitScene) scenes[1];
        waitScene.remaining = (int) map(rcScene.dispensers[0].amount, 0, MAX_REMAINING, 0, 60); // water amount determines time to cook
        
        // wait twice as long if no lid
        
        if (!rcScene.lid.on) {
          waitScene.remaining *= 2;
        }
        
        boolean noContents = true;
        
        for (int i = 0; i < 3; i++) {
          if (rcScene.dispensers[i].amount != 0) {
            noContents = false;
            break;
          }
        }
        
        if (noContents) {
          sceneChange = true;
        }
      }
      break;
      
    case 1:
      if (sceneFade < 100) {
        fill(color(0, 0, 0, map(++sceneFade, 0, 100, 192, 255)));
        rect(0, 0, width, height);
      } else {
        sceneFade = 0;
        sceneIdx++;
        sceneChange = false;
        
        RiceCookerScene rcScene = (RiceCookerScene) scenes[0];
        WaitScene waitScene = (WaitScene) scenes[1];
        FinalScene finalScene = (FinalScene) scenes[2];
        
        int water = rcScene.dispensers[0].amount;
        int whiteRice = rcScene.dispensers[1].amount;
        int brownRice = rcScene.dispensers[2].amount;
        int rice = whiteRice + brownRice;
        
        if (rice == 0) {
          finalScene.noRice = true;
        }
        
        // The perfect ratio of rice to water depends on the mix of the whiteRice : brownRice ratio
        
        float perfectRatio = map((float)whiteRice/rice, 0.0, 1.0, 3.0, 2.0);
        float calculatedRatio = (float) water / rice;
        
        println("perfectRadio " + perfectRatio + " calculatedRatio " + calculatedRatio);
        
        // So a ratio difference of 0 will net a 10000, and a very large difference will net a score of 0
        int score = max(0, int(map(abs(calculatedRatio - perfectRatio), 0, 3, 10000, 0)));
        
        finalScene.score = score;
        
        // burnt vs mushy
        
        if (perfectRatio - calculatedRatio < -1.5) {
          finalScene.mushy = 2;
        } else if (perfectRatio - calculatedRatio < -0.5) {
          finalScene.mushy = 1;
        } else if (perfectRatio - calculatedRatio < 0.5) {
          finalScene.mushy = 0;
        } else if (perfectRatio - calculatedRatio < 1.5) {
          finalScene.mushy = -1;
        } else {
          finalScene.mushy = -2;
        } 
        
        // spill penalty
        
        int spill = 0;
        
        for (int i = 0; i < 3; i++) {
          spill += rcScene.dispensers[i].spill;
        }
        
        finalScene.spillPenalty = (int) map(spill, 0, MAX_REMAINING*3, 0, 5000);
        
        // mix penalty
        
        int mixed = min(rice - whiteRice, rice - brownRice);
        
        finalScene.mixPenalty = mixed;
        
        // no lid penalty
        
        if (!rcScene.lid.on) {
          finalScene.noLidPenalty = 2000;
        }
        
        // keep warm penalty
        
        if (!rcScene.keepWarm) {
          finalScene.keepWarmPenalty = (int) map(abs(waitScene.remaining), 0, 100, 0, 3000);
        }
      }
      
      break;
      
    case 2:
      setup();
    }
  }
}

void mousePressed() {
  if (!sceneChange) {
    scenes[sceneIdx].onMousePressed(mouseX, mouseY);
    println(mouseX + ", " + mouseY);
  }
}

void mouseDragged() {
  if (!sceneChange) {
    scenes[sceneIdx].onMouseDragged(mouseX, mouseY);
  }
}

void mouseReleased() {
  if (!sceneChange) {
    scenes[sceneIdx].onMouseReleased(mouseX, mouseY);
  }
}

