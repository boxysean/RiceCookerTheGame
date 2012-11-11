int SCENE_RICE_COOKER = 0;
int SCENE_BUTTON_MENU = 1;

Scene scene = new RiceCookerScene();

void setup() {
  size(600, 600);
  smooth();
  
  scene.setup();
  
  reservoirImage = loadImage("images/reservoir.png");
  tapImage = loadImage("images/tap.png");
  
  brownRiceImage = loadImage("images/ricegrain_brown.jpg");
  whiteRiceImage = loadImage("images/ricegrain_white.jpg");
  waterImage = loadImage("images/ricegrain_brown.jpg");
}

void draw() {
  background(200);
  scene.draw(g);
}

void mousePressed() {
  scene.onMousePressed(mouseX, mouseY);
  println(mouseX + ", " + mouseY);
}

void mouseDragged() {
  scene.onMouseDragged(mouseX, mouseY);
}

void mouseReleased() {
  scene.onMouseReleased(mouseX, mouseY);
}

