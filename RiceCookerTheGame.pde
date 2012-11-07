int SCENE_RICE_COOKER = 0;
int SCENE_BUTTON_MENU = 1;

Scene scene = new RiceCookerScene();

void setup() {
  size(600, 600);
  smooth();
}

void draw() {
  scene.draw(g);
}

void mousePressed() {
  scene.onMousePressed(mouseX, mouseY);
}

void mouseDragged() {
  scene.onMouseDragged(mouseX, mouseY);
}

void mouseReleased() {
  scene.onMouseReleased(mouseX, mouseY);
}

/*******************************************************/
/* Rice cooker scene                                   */
/*******************************************************/


