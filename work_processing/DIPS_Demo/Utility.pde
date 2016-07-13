// no need argument (this file is treated as inner class of DIPS_Demo)
public class Utility {

  // Depth range
  static final int MAX_D = 2000; //unit: cm
  static final int MIN_D = 1000;

  void initKinectV2() {
    //kinect = new KinectPV2(this);
    //kinect.enableDepthImg(true);
    //kinect.enablePointCloud(true);
    //kinect.init();
  }

  //Draw the operation status
  void drawOperationStatus() {
    offscreen.textSize(24);
    offscreen.fill(0, 0, 255);
    offscreen.text("Status: "+ s_demo_status, 100, 100);
  }

  // Get depth data
  void drawWallDepthDiff() {

  }

  void drawSurfaceAndHoldPoint() {

    // white wall surface
    offscreen.background(255);

    // indicator circle for calibrate hold point
    offscreen.fill(0, 255, 0); //(R,G,B)
    offscreen.ellipse(surfaceMouse.x, surfaceMouse.y, 75, 75); //center, radius

    // Draw the calibrated hold points
    for (int i = 0; i < hold_pts_array.size(); i++) {  
      offscreen.fill(0, 255, 0); //(R,G,B)
      offscreen.ellipse(hold_pts_array.get(i).getX(), hold_pts_array.get(i).getY(), 50, 50); //center, radius

      offscreen.fill(0, 102, 153);
      offscreen.textSize(32);
      offscreen.text("pt["+i+"]", hold_pts_array.get(i).getX()-16, hold_pts_array.get(i).getY()-16);
    }
  }

  void drawStandbyContext() {

    // black background
    offscreen.background(0);

    // draw sony logo and line from pt(n-1) to pt(n)
  }

  void startTimer() {
    // decrement the limit time(1-3min?)
  }

  void updateScoreAndTime() {
    // black background
    offscreen.background(0);

    //judge whether object passed avobe the calibrated pts

    //Draw the score and time
    offscreen.textSize(32);
    offscreen.fill(255, 255, 255);
    offscreen.text("Score:"+ "0" +" Time: "+ "1", 45, 45); //Todo: show score and time decrement status
  }

  void drawFinalStatus() {
    //draw success/fail and total score and remained time
    //TODO timeout iru?
  }

  void calibDepthData() {
    println("raw data 255 copied, size:"+ calib_rawData.length);// size:217088(514*424), bit depth 0-4500

    //calib_rawData = cap_rawData;

    //for(int h=0; h < 424; h++) {
    //  for(int w=0; w < 512; w++) {
    //   println("cap_rawData256=", cap_rawData256[(512*h)+w]);
    //  }
    //}
  }

  void calibHoldPoints() {
    // Calib hold pts to Max
    if (mouseButton == LEFT) {
      //println("mousePressed called:"+s_demo_status);
        if (hold_pts_array == null || hold_pts_array.size() != HOLD_POINT_MAX) {
          PT2D tmp_pt2d = new PT2D();
          tmp_pt2d.setX((int)surfaceMouse.x); // conv float to int
          tmp_pt2d.setY((int)surfaceMouse.y); // conv float to int
          hold_pts_array.add(tmp_pt2d);    
          println("save pt["+(hold_pts_array.size()-1)+"](x,y)=("+(int)surfaceMouse.x+", "+(int)surfaceMouse.y+")");
        } else {
          println("!! Limit the save pt !!");
        }
    }
  }
};