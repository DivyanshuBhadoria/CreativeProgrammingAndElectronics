class treePart {
  //hold x, y, width, and height of tree object
  float x;
  float y;
  float currentWidth;
  float tall;
  //if tree has a nest and location
  boolean hasNest = false;
  int nestx;
  int nesty;
  //what side tree has leaf
  boolean hasleaf;
  boolean side;
  void update() {
    //draw the tree object's darker border
    stroke(81,54,26);
    fill(81,54,26);
    rect(x-7,y,7,tall);
    rect(x+currentWidth,y,7,tall);
    //draw the tree object
    stroke(101,67,33);
    fill(101,67,3);
    rect(x,y,currentWidth,tall);
  }
}
