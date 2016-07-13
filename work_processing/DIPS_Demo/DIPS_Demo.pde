/* for DIPS Demo on 2016/07/19  //<>// //<>//
 * memo: Kinect Depth Resolutin: w512, h:424 */

import KinectPV2.*;
import deadpixel.keystone.*;

void setup() {
  s_demo_status = E_DEMO_STATUS.DEMO_PREPARE_INIT;

  // Set window size
  size(800, 800, P3D);

  // Initialize KeyStone
  ks = new Keystone(this);

  // Projection target screen
  surface = ks.createCornerPinSurface(600, 600, 40); //1st,2nd args:calib image size, 3rd arg: div num
  offscreen = createGraphics(600, 600, P3D);

  // Init the hold points array
  hold_pts_array = new ArrayList<PT2D>();
  util = new Utility();

  // Init depth data array
  depth_diff_Img = createImage(K_WIDTH, K_HEIGHT, RGB);

  ///println("Kw, kh: "+KinectPV2.WIDTHDepth+", "+KinectPV2.HEIGHTDepth); 512, 424
  rawData = new Integer[ KinectPV2.WIDTHDepth * KinectPV2.HEIGHTDepth];
  calib_rawData = new Integer[ KinectPV2.WIDTHDepth * KinectPV2.HEIGHTDepth];

  //SET THE ARRAY TO 0s
  for (int i = 0; i < KinectPV2.WIDTHDepth; i++) {
    for (int j = 0; j < KinectPV2.HEIGHTDepth; j++) {
      rawData[424*i + j] = 0;
      calib_rawData[424*i + j] = 0;
    }
  }

  //Init KinectV2 setting
  util.initKinectV2();
}

void draw() {

  // Convert the mouse coordinate into surface coordinates
  // this will allow you to use mouse events inside the 
  // surface from your screen. 
  surfaceMouse = surface.getTransformedMouse();

  // Draw the scene, offscreenr
  offscreen.beginDraw();

  switch(s_demo_status) {
  case DEMO_CALIB_WALL_DEPTH:
    util.drawWallDepthDiff();
    break;
  case DEMO_CALIB_WALL_SURFACE:
  case DEMO_CALIB_HOLD_POINT:
    util.drawOperationStatus();
    util.drawSurfaceAndHoldPoint();
    break;
  case DEMO_STANDBY:
    util.drawStandbyContext();
    break;
  case DEMO_START:  
    util.updateScoreAndTime();
    break;
  case DEMO_END:
    util.drawFinalStatus();
    break;
  case DEMO_STATUS_NONE:
  case DEMO_PREPARE_INIT:
  case DEMO_QUIT:
  default:
    break;
  };

  offscreen.endDraw();

  // black background
  background(0);

  // render the scene, transformed using the corner pin surface
  surface.render(offscreen);
}

void keyPressed() {
  switch(key) {

  case 'd': // get the depth data
    s_demo_status = E_DEMO_STATUS.DEMO_CALIB_WALL_DEPTH;
    //util.calibDepthData();

    //show depth diff data
    break;

  case 'w': // caliblate the screen
    s_demo_status = E_DEMO_STATUS.DEMO_CALIB_WALL_SURFACE;
    // enter/leave calibration mode, where wall surfaces can be warped and moved
    ks.toggleCalibration();
    break;

  case 'p': //caliblate the pts
    s_demo_status = E_DEMO_STATUS.DEMO_CALIB_HOLD_POINT;
    // see the mousePressed()
    break;

  case 'z': // reinit all
    setup();
    break;

  case 's': //finish preparation and standby
    s_demo_status = E_DEMO_STATUS.DEMO_STANDBY;
    break;

  case 'r': // run demo
    s_demo_status = E_DEMO_STATUS.DEMO_START;
    util.startTimer();
    break;

  case 'e': // Finish demo
    s_demo_status = E_DEMO_STATUS.DEMO_END;
    break;

  case 'q': // show depth
    s_demo_status = E_DEMO_STATUS.DEMO_QUIT;
    break; 

    //case 'l':
    //  loads the saved layout
    //  ks.load();
    //  break;

    //case 's':
    //  saves the layout
    //  ks.save();
    //  break;

  default:
    println("keyPressed default");
    break;
  }
}

void mousePressed() {
  if (s_demo_status.equals(E_DEMO_STATUS.DEMO_CALIB_HOLD_POINT)) {
    util.calibHoldPoints();
  }
}