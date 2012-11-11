interface Clickable {
  boolean onMousePressed(int x, int y);
  boolean onMouseReleased(int x, int y);
  boolean onMouseDragged(int x, int y);
}

interface Scene {
  void draw(PGraphics g);
  void setup();
  boolean onMousePressed(int x, int y);
  boolean onMouseReleased(int x, int y);
  boolean onMouseDragged(int x, int y);
}
