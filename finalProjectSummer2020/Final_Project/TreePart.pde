class treePart {
  float x;
  float y;
  float currentWidth;
  float tall;
  boolean hasNest = false;
  int nestx;
  int nesty;
  boolean hasleaf;
  boolean side;
  void update() {
    stroke(81,54,26);
    fill(81,54,26);
    rect(x-7,y,7,tall);
    rect(x+currentWidth,y,7,tall);
    stroke(101,67,33);
    fill(101,67,3);
    rect(x,y,currentWidth,tall);
  }
}
