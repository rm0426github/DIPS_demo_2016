/*
Thomas Sanchez Lengeling.
 http://codigogenerativo.com/
 KinectPV2, Kinect for Windows v2 library for processing 
 Depth  and infrared Test
 */
import KinectPV2.*;
KinectPV2 kinect;

PImage depthPCImg;
PImage calib_depthPCImg;
PImage tmp_depthPCImg;

PImage diff_depthImg;

//int[] rawData;
//int[] rawData256;

//int[] calibRawData;
//int[] calibRawData256;

//int[] diffRawData;
//int[] diffRawData256;

//int[] tmpRawData;

boolean isDiffImageDraw;

// Depth range
static final int MAX_D = 2000; //unit: mm
static final int MIN_D = 1000;
static final int K_WIDTH = 512;
static final int K_HEIGHT = 424;
static final int THD_DIFF = 70;

void setup() {
  size(1536, 424, P3D);

  kinect = new KinectPV2(this);
  kinect.enableDepthImg(true);
  kinect.enablePointCloud(true);
  kinect.init();

  depthPCImg = createImage(K_WIDTH, K_HEIGHT, RGB);
  calib_depthPCImg = createImage(K_WIDTH, K_HEIGHT, RGB);
  diff_depthImg    = createImage(K_WIDTH, K_HEIGHT, RGB);

  /////println("Kw, kh: "+KinectPV2.WIDTHDepth+", "+KinectPV2.HEIGHTDepth); 512, 424
  //rawData         = new int[ KinectPV2.WIDTHDepth * KinectPV2.HEIGHTDepth];
  //calibRawData    = new int[ KinectPV2.WIDTHDepth * KinectPV2.HEIGHTDepth];
  //diffRawData     = new int[ KinectPV2.WIDTHDepth * KinectPV2.HEIGHTDepth];
  //rawData256      = new int[ KinectPV2.WIDTHDepth * KinectPV2.HEIGHTDepth];
  //calibRawData256 = new int[ KinectPV2.WIDTHDepth * KinectPV2.HEIGHTDepth];
  //diffRawData256  = new int[ KinectPV2.WIDTHDepth * KinectPV2.HEIGHTDepth];
  //tmpRawData      = new int[ KinectPV2.WIDTHDepth * KinectPV2.HEIGHTDepth];

  ////SET THE ARRAY TO 0s
  //for (int i = 0; i < KinectPV2.WIDTHDepth; i++) {
  //  for (int j = 0; j < KinectPV2.HEIGHTDepth; j++) {
  //    rawData[424*i + j]          = 0;
  //    calibRawData[424*i + j]     = 0;
  //    diffRawData[424*i + j]      = 0;
  //    rawData256[424*i + j]       = 0;
  //    calibRawData256[424*i + j]  = 0;
  //    diffRawData256[424*i + j]   = 0;
  //    tmpRawData[424*i + j]       = 0;
  //  }
  //}
}

void draw() {
  // black background
  background(0);

  //draw diff depth image
  if (isDiffImageDraw == true) {
    drawDepthDiffImage();
  } else {
    drawDepthImage();
  }
}

void keyPressed() {
  switch(key) {
  case 'd':
    isDiffImageDraw = true;
    break;
  case 'c': // get the depth data
    isDiffImageDraw = false;

    ////raw Data int valeus from [0 - 4500]
    //tmpRawData = kinect.getRawDepthData();
    //for (int i = 0; i < KinectPV2.WIDTHDepth; i++) {
    //  for (int j = 0; j < KinectPV2.HEIGHTDepth; j++) {
    //    calibRawData[424*i + j] = tmpRawData[424*i + j];
    //  }
    //}

    ////raw Data int valeus from [0 - 255]
    //tmpRawData = kinect.getRawDepth256Data();
    //for (int i = 0; i < KinectPV2.WIDTHDepth; i++) {
    //  for (int j = 0; j < KinectPV2.HEIGHTDepth; j++) {
    //    calibRawData256[424*i + j] = tmpRawData[424*i + j];
    //  }
    //}

    //// Get the point cloud as a PImage
    //// Each pixel of the PointCloudDepthImage correspondes to the value
    //// of the Z in the Point Cloud or distances, the values of
    //// the Point cloud are mapped from (0 - 4500) mm  to gray color (0 - 255)
    tmp_depthPCImg  = kinect.getPointCloudDepthImage();
    calib_depthPCImg = tmp_depthPCImg.copy();
    break;
    
  default:
    break;
  }
}

void drawDepthImage() {
  //scale(-1.0, 1.0); //L-R flip
  //image(kinect.getDepthImage(), -1024, 0);
  //image(kinect.getPointCloudDepthImage(), -524, 0);

  //image(kinect.getDepthImage(), 0, 0);

  //obtain the depth frame as strips of 256 gray scale values
  //image(kinect.getDepth256Image(), 512, 0);

  kinect.setLowThresholdPC(MIN_D);  //for point cloud
  kinect.setHighThresholdPC(MAX_D); //for point cloud
  image(kinect.getPointCloudDepthImage(), 0, 0);
  image(calib_depthPCImg, 512, 0);

  stroke(255);
  text(frameRate, 50, height - 50);
}

void drawDepthDiffImage() {
  image(kinect.getDepthImage(), 0, 0);
  image(calib_depthPCImg, 512, 0);

  //rawData = kinect.getRawDepthData();
  //rawData256 = kinect.getRawDepth256Data();
  depthPCImg = kinect.getPointCloudDepthImage();

  depthPCImg.loadPixels();
  calib_depthPCImg.loadPixels();
  diff_depthImg.loadPixels();

  int w, h, diff;
  for (h = 0; h < K_HEIGHT; h++) {
    for (w = 0; w < K_WIDTH; w++) {
      
      //diff = rawData[(K_WIDTH*h) + w] - calibRawData[(K_WIDTH*h) + w];
      //diff = rawData256[(K_WIDTH*h) + w] - calibRawData256[(K_WIDTH*h) + w];
      diff = abs(depthPCImg.get(w, h) - calib_depthPCImg.get(w, h));
      //diff = (int)(diff/4500)*256;
      if (diff >= THD_DIFF) {
        diff_depthImg.pixels[(K_WIDTH*h) + w] = color(diff, diff, diff);
        //diff_depthImg.pixels[(K_WIDTH*h) + w] = color(255, 255, 255);
      } else {
        diff_depthImg.pixels[(K_WIDTH*h) + w] = color(0, 0, 0);
      }
    }
  }
  depthPCImg.updatePixels();
  calib_depthPCImg.updatePixels();
  diff_depthImg.updatePixels();

  image(diff_depthImg, 1024, 0);

  stroke(255);
  text(frameRate, 50, height - 50);
}