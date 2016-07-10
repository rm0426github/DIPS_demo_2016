/* for DIPS Demo on 2016/07/19 
 * memo: Kinect Depth Resolutin: w512, h:424 */

import KinectPV2.*;
import deadpixel.keystone.*;
//import PT2D.*;

KinectPV2 kinect;
Keystone ks;
CornerPinSurface surface;
PGraphics offscreen;
PVector surfaceMouse;

// Depth range
static final int MAX_D = 2000; //unit: cm
static final int MIN_D = 1000;

// Max Num of Hold Point
static final int HOLD_POINT_MAX = 10; 

// Coordinates array of the indicated hold points
//PT2D[] hold_pts;
ArrayList<PT2D> hold_pts_array;

// raw Depth Data int values from [0 - 255]
Integer[] calib_rawData256; // caliblated depth data
Integer[] cap_rawData256; //capture depth data

//raw Depth Data int valeus from [0 - 4500]
Integer[] cap_rawData;// = kinect.getRawDepthData();

// Define the demo status
enum E_DEMO_STATUS
{
  // run this app
  DEMO_RUN_INIT,
  
  // before start demo
  DEMO_CALIB_SURFACE,
  DEMO_CALIB_HOLD_POINT,

  // after start demo
  DEMO_START,
  DEMO_END, // continue demo
  DEMO_QUIT // exit demo
};

// for management demo status
static E_DEMO_STATUS s_demo_status = E_DEMO_STATUS.DEMO_RUN_INIT;

void setup() {

  s_demo_status = E_DEMO_STATUS.DEMO_RUN_INIT;
  
  //// Initilize Kinect V2
  //kinect = new KinectPV2(this);
  //kinect.enableDepthImg(true);
  //kinect.enablePointCloud(true);
  //kinect.init();
  
  // Set window size
  size(800, 800, P3D);

  // Initialize KeyStone
  ks = new Keystone(this);
  
  // Projection target screen
  surface = ks.createCornerPinSurface(600, 600, 40); //1st,2nd args:calib image size, 3rd arg: div num
  offscreen = createGraphics(600, 600, P3D);
  
  // Init the hold points array
  //hold_pts = new PT2D[HOLD_POINT_MAX];
  hold_pts_array = new ArrayList<PT2D>();
  //for(int i=0; i < HOLD_POINT_MAX; i++) {
  //  hold_pts[i] = null;
  //}
  
  // Init depth data array
  calib_rawData256 = null;
  cap_rawData256 = null;
}

void draw() {
  
  // Convert the mouse coordinate into surface coordinates
  // this will allow you to use mouse events inside the 
  // surface from your screen. 
  surfaceMouse = surface.getTransformedMouse();

  // Draw the scene, offscreen
  offscreen.beginDraw();
  offscreen.background(255);
  
  offscreen.fill(0, 255, 0); //(R,G,B)
  offscreen.ellipse(surfaceMouse.x, surfaceMouse.y, 75, 75); //center, radius
  
  // Draw the hold point and line
  for(int i = 0; i < hold_pts_array.size(); i++) {  
      offscreen.fill(0, 255, 0); //(R,G,B)
      offscreen.ellipse(hold_pts_array.get(i).getX(), hold_pts_array.get(i).getY(), 50, 50); //center, radius
      offscreen.textSize(32);
      offscreen.text("pt["+i+"]", 10, 30); 
      offscreen.fill(0, 102, 153);
  }
  
  //Draw the score and time
  
  
  
  offscreen.endDraw();
  
  // black background
  background(0);

  // render the scene, transformed using the corner pin surface
  surface.render(offscreen);
  
  ////obtain the color image from the kinect v2
  //scale(-1.0, 1.0); //L-R flip
  //image(kinect.getDepthImage(), -1024, 0);
  //image(kinect.getPointCloudDepthImage(), -524, 0);
  
  //kinect.setLowThresholdPC(MIN_D); //for point cloud
  //kinect.setHighThresholdPC(MAX_D); //for point cloud
  
  //scale(-1.0, 1.0); //fix the coordinate
  //fill(255, 0, 0);
  //text(frameRate, 50, 50);

  ////raw Data int valeus from [0 - 4500]
  //// int [] rawData = kinect.getRawDepthData();

  ////values for [0 - 256] strip
  //cap_rawData256 = kinect.getRawDepth256Data();
}

void keyPressed() {
  switch(key) {
  case 'c': // caliblate the screen
    s_demo_status = E_DEMO_STATUS.DEMO_CALIB_SURFACE;
    // enter/leave calibration mode, where surfaces can be warped 
    // and moved
    ks.toggleCalibration();
    break;

  case 'a': //caliblate the pts
    s_demo_status = E_DEMO_STATUS.DEMO_CALIB_HOLD_POINT; //<>//
   // calib_rawData256 = cap_rawData256;
    //println("raw data 255 copied, size:"+ calib_rawData256.length);// size:217088(514*424)

  //  for(int h=0; h < 424; h++) {
  //    for(int w=0; w < 512; w++) {
  //     println("cap_rawData256=", cap_rawData256[(512*h)+w]);
  //    }
  //}
    break;

  case 'h': // init and save the coordinates of the hold points

    break;

  //case 'l':
  //  // loads the saved layout
  //  ks.load();
  //  break;

  //case 's':
  //  // saves the layout
  //  ks.save();
  //  break;
    
  case 's': // Start demo
    break;
    
  case 'e': // Finish demo
    break;
  
  case 'q': // quit this demo //TODO esc de OK?
    break;
    
  }
}

void mousePressed() {
  
   println("mousePressed called:"+s_demo_status);
  
  if(s_demo_status.equals(E_DEMO_STATUS.DEMO_CALIB_HOLD_POINT)) {
    //boolean is_save = false;  
    //for(int i = 0; i < HOLD_POINT_MAX; i++) { //<>//
      //if (hold_pts[i] == null) {
          PT2D tmp_pt2d = new PT2D();
          tmp_pt2d.setX((int)surfaceMouse.x); // conv float to int
          tmp_pt2d.setY((int)surfaceMouse.y); // conv float to int
          hold_pts_array.add(tmp_pt2d);
          //is_save = true; //<>//
          
          println("save pt["+(hold_pts_array.size()-1)+"](x,y)=("+(int)surfaceMouse.x+", "+(int)surfaceMouse.y+")");
          //break;
      //} 
      //if(is_save == false) {
      //  println("PT save reset 0, can't save");
      //}
    //}
  }
  
  //saveFrame();
}