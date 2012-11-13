class RiceCookerScene implements Scene {
  Dispenser dispensers[] = new Dispenser[3];
  
  Burner burner = new Burner();
  Lid lid = new Lid();
  
  PImage bowlBackImage;
  PImage bowlFrontImage;
  PImage backgroundImage;
  
  boolean on = false;
  boolean cook = false;
  boolean keepWarm = false;
  
  RiceCookerScene() {
    dispensers[0] = new Dispenser(350, 150, "water", #037df4, 700, 0.8, 400, 164, 40, 40, waterImage, this);
    dispensers[1] = new Dispenser(250, 200, "white rice", #FFFFFF, 500, 0.9, 309, 215, 45, 45, whiteRiceImage, this);
    dispensers[2] = new Dispenser(150, 250, "brown rice", #ff873b, 300, 1.0, 215, 269, 50, 50, brownRiceImage, this);
    
    bowlBackImage = loadImage("images/bowl-back.png");
    bowlFrontImage = loadImage("images/bowl-front.png");
    
    backgroundImage = loadImage("images/background-red.jpg");
  }
  
  void draw(PGraphics g) {
    // draw
    
    g.image(backgroundImage, 0, 0);
    
    drawBowlBack(g);
    
    for (int i = 0; i < 3; i++) {
      dispensers[i].draw(g);
    }
    
    drawBowlFront(g);
    burner.draw(g);
    lid.draw(g);
  }
  
  void drawBowlBack(PGraphics g) {
    g.pushMatrix();
    g.scale(0.75);
    g.image(bowlBackImage, 235, 480);
    g.popMatrix();
  }
  
  void drawBowlFront(PGraphics g) {
    g.pushMatrix();
    g.scale(0.75);
    g.image(bowlFrontImage, 229, 535);
    g.popMatrix();
  }
    
  boolean onMousePressed(int x, int y) {
    for (int i = 0; i < dispensers.length; i++) {
      if (dispensers[i].faucet.onMousePressed(x, y)) {
        return true;
      }
    }
    
    if (burner.onMousePressed(x, y)) {
      return true;
    }
    
    if (lid.onMousePressed(x, y)) {
      return true;
    }
    
    return false;
  }

  boolean onMouseDragged(int x, int y) {
    for (int i = 0; i < dispensers.length; i++) {
      if (dispensers[i].faucet.onMouseDragged(x, y)) {
        return true;
      }
    }
    
    if (burner.onMouseDragged(x, y)) {
      return true;
    }
    
    return false;
  }

  boolean onMouseReleased(int x, int y) {
    for (int i = 0; i < dispensers.length; i++) {
      if (dispensers[i].faucet.onMouseReleased(x, y)) {
        return true;
      }
    }
    
    if (burner.onMouseReleased(x, y)) {
      return true;
    }
    
    return false;
  }
}

class WaitScene implements Scene {
  Scene riceCookerScene;
  
  PFont font;
  
  PImage stopwatch;
  
  int remaining;
  
  Option options[] = new Option[3];
  
  boolean waitTime;
  int waitFrames = 0;
  
  Label labelBank[] = {
    new Label("Check your facebook and look at cat photos", 20),
    new Label("Go for a quick run because you aren't that hungry", 35),
    new Label("Watch an episode of Girls that you pirated", 60),
    new Label("Watch an episode of Who's The Boss on Netflix", 24),
    new Label("Call your mom and tell her you love her", 15),
    new Label("Clip your toe nails", 4),
    new Label("Give your roommate a massage", 10),
    new Label("Read the latest Time Magazine on ", 17),
    new Label("Do a Sudoku puzzle because you aren't sick of them", 12),
  };
  
  WaitScene(RiceCookerScene riceCookerScene) {
    this.riceCookerScene = riceCookerScene;
    
    makeOptions();
    
    font = loadFont("SansSerif-16.vlw");
    stopwatch = loadImage("images/timer.png");
  }
  
  void draw(PGraphics g) {
    // rc scene
    
    riceCookerScene.draw(g);
    fill(color(0, 0, 0, 192));
    noStroke();
    rect(0, 0, g.width, g.height);
    
    if (waitTime) {
      image(stopwatch, g.width/2 - stopwatch.width/2, g.height/2 - stopwatch.height/2);
      waitFrames++;
      
      if (waitFrames == 100) {
        waitTime = false;
        waitFrames = 0;
      }
    } else {
      // draw popup box
      
      fill(color(255, 255, 255, 192));
      rect(100, 200, g.width-200, g.height-400);
      
      // options
      
      textSize(12);
      
      for (int i = 0; i < options.length; i++) {
        options[i].draw(g);
      }
      
      // prompt
      
      textSize(16);
      
      fill(#000000);
      noStroke();
      g.text("Your rice is cooking.", 150, 250);
      g.text("You've got a lot of time to kill.", 150, 275);
      g.text(remaining + " minutes to be precise.", 150, 300);
      g.text("What will you do?", 150, 325);
    }
  }
  
  void makeOptions() {
    options[0] = new Option(150, 350, 300, 50, labelBank[(int) random(0, labelBank.length)]);
    options[1] = new Option(150, 425, 300, 50, labelBank[(int) random(0, labelBank.length)]);
    options[2] = new Option(150, 500, 300, 50, labelBank[(int) random(0, labelBank.length)]);
  }
  
  boolean onMousePressed(int x, int y) {
    for (int i = 0; i < options.length; i++) {
      if (options[i].onMousePressed(x, y)) {
        remaining -= options[i].label.time;
        
        if (remaining <= 0) {
          sceneChange = true;
        } else {
          waitTime = true;
          waitFrames = 0;
          makeOptions();
        }
        
        return true;
      }
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

class Option implements Clickable {
  int x, y, w, h;
  Label label;
  
  Option(int x, int y, int w, int h, Label label) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
  }
  
  void draw(PGraphics g) {
    g.stroke(#ff8300);
    g.fill(#FFFFFF);
    g.strokeWeight(4);
    g.rect(x, y, w, h);
    
    g.fill(#000000);
    g.noStroke();
    g.text(label.label + " (" + label.time + " mins)", x+20, y+30);
  }
  
  boolean onMousePressed(int x, int y) {
    if (this.x <= x && x < this.x+w && this.y <= y && y < this.y+h) {
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

class Label {
  String label;
  int time;
  
  Label(String label, int time) {
    this.label = label;
    this.time = time;
  }
}

class FinalScene implements Scene {
  int x, y, w, h;
  
  int spillPenalty;
  int mixPenalty;
  int noLidPenalty;
  int keepWarmPenalty;
  int score;
  int mushy;
  
  boolean noRice = false;
  
  PImage backgroundImage;
  PImage mushyImages[] = new PImage[5];
  
  FinalScene() {
    backgroundImage = loadImage("images/background.jpg");
    
    mushyImages[0] = loadImage("images/burntrice.jpg");
    mushyImages[1] = loadImage("images/burntrice2.jpg");
    mushyImages[2] = loadImage("images/mushyrice2.jpg");
    mushyImages[3] = loadImage("images/mushyrice_brown.jpg");
    mushyImages[4] = loadImage("images/mushyrice1.jpg");
  }
  
  void draw(PGraphics g) {
    g.image(backgroundImage, 0, 0);
    
    // rice oval image
    
    if (noRice) {
      g.textSize(30);
      g.text("NO RICE", 300, 375);
    } else {
      String mushyness = "";
      
      switch (mushy) {
      case -2:
        mushyness = "BURNT TO A CRISP! add some more water whydontcha";
        break;
      case -1:
        mushyness = "mmmm, toasy!";
        break;
      case 0:
        mushyness = "You did a pretty good job there, eh";
        break;
      case 1:
        mushyness = "what are you trying to cook sticky rice? this is mushy!";
        break;
      case 2:
        mushyness = "dude hold back on the water. THIS IS MUSHY!";
        break;
      }
      
      g.textSize(20);
      g.text(mushyness, 25, 200);
      
      PImage riceImage = mushyImages[mushy+2];
      g.image(riceImage, g.width/2-riceImage.width/2, g.height/2-riceImage.height/2);
    
      // score
      
      g.textSize(16);
      g.text("score: " + score, 200, 600);
      g.text("spill penalty: " + spillPenalty, 200, 625);
      g.text("no lid penalty: " + noLidPenalty, 200, 650);
      g.text("keep warm penalty: " + keepWarmPenalty, 200, 675);
      g.text("mix penalty: " + mixPenalty, 200, 700);
      textSize(24);
      g.text("TOTAL: " + (score - mixPenalty - noLidPenalty - spillPenalty - keepWarmPenalty), 209, 725);
    }
    
    textSize(16);
    g.text("click to restart...", 400, 700);
  }
  
  boolean onMousePressed(int x, int y) {
    sceneChange = true;
    return true;
  }
  
  boolean onMouseDragged(int x, int y) {
    return false;
  }
  
  boolean onMouseReleased(int x, int y) {
    return false;
  }
}
