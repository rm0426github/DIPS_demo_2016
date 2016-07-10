public class PT2D {

  private Integer x;
  private Integer y;
  
  // constructor
  PT2D() {
    x = null;
    y = null;
  }

  void init() {
      x = null;
      y = null;
  }
  
  void setX(int in_x) {
    x = in_x;
  }
  
  void setY(int in_y) {
    y = in_y;
  }
  
  int getX() {
    return x.intValue();
  }
  
  int getY() {
    return y.intValue();
  }
  
};