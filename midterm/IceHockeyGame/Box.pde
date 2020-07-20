class Box {
  int x;
  int y;
  color z;
  boolean appears = true;
  //Check if box should disappear or appear (if it has been hit or not)
  void update() {
    fill(z);
    if(appears) {
      rect(x,y,67,20,5);
    }
  }
}
