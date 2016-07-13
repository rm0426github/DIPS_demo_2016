
KinectPV2 kinect;
Keystone ks;
CornerPinSurface surface;
PGraphics offscreen;
PVector surfaceMouse;

// Coordinates array of the indicated hold points
ArrayList<PT2D> hold_pts_array;

//raw Depth Data int valeus from [0 - 4500]
Integer[] rawData;
Integer[] calib_rawData; // caliblated depth data

// Singleton instance for using util api
Utility util;

// Image for draw depth diff image
PImage depth_diff_img;
PImage depth_pc_img;
PImage calib_depth_pc_img;
PImage tmp_depth_pc_img;

// Max Num of Hold Point
static final int HOLD_POINT_MAX = 10; 

// Kinect depth resolution
static final int K_WIDTH = 512;
static final int K_HEIGHT = 424;

// Threshold val to judge depth diff
static final int THD_DIFF = 100;

// Defs for the demo status
enum E_DEMO_STATUS
{  // befire run this app
  DEMO_STATUS_NONE, 
    // run this app
    DEMO_PREPARE_INIT, 

    // before start demo
    DEMO_CALIB_WALL_DEPTH, 
    DEMO_CALIB_WALL_SURFACE, 
    DEMO_CALIB_HOLD_POINT, 

    // after start demo
    DEMO_STANDBY, 
    DEMO_START, 
    DEMO_END, // demo still run, status for preparation
    DEMO_QUIT, // exit demo
    
    DEMO_DEPTH_DIFF, // Show depth diff image
};

// for management demo status
static E_DEMO_STATUS s_demo_status = E_DEMO_STATUS.DEMO_STATUS_NONE;