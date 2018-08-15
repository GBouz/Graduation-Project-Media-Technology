// meta variables --------------------------------------------------------------------------------------
final String SUBJECT_NAME = "Giorgos_M26_f_"; // goes to the name of the output file <-- different for every user
int instanceCounter = 0;     // goes to the name of the output file (differentiates the instances of the same person)
int SEARCH_AREA = 1;    // determines how much area will be searched for similar pixels in depth
//int MORE_DEPTH = 2;     // determines how much more depth than the closest pixel is allowed
int MORE_DEPTH = 1;      // determines how much more depth than the closest pixel is allowed !(millimeters)!

// additional window variables -------------------------------------------------------------------------
import g4p_controls.*;
GWindow[] window;

color secondWinBGIdle = color(200);
color secondWinBGColors = color(200);
color lockColorsCooking = color(255); // 255 essentially deactivates it , color(48) is a blacker option i was using before;
color lockColorsIdle = color(170);
color lockColors = color(170);
color successColors = color(141,221,105);
color successCelebrationColors = color(121,204,83);
int lockStroke = 5;

// kinect ----------------------------------------------------------------------------------------------
import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
Kinect2 kinect2;

// tracking --------------------------------------------------------------------------------------------
ArrayList<BlobDepth> blobs = new ArrayList<BlobDepth>();

// RGB
color trackColor; 
float threshold = 25;
final int DIST_THRESHOLD = 30;

// HSB
int rangeLow = -100;
int rangeHigh = -100;
int rangeLowModulated = -105;
int rangeHighModulated = 105;
final int COLOR_RANGE = 2;

// controls --------------------------------------------------------------------------------------------
boolean startedDrawing = true;
boolean allowInstances = false;
boolean trainingModeOn = false;
boolean depthTrackingOn = true;
boolean hueTrackingOn = false;
boolean sKeyBlock = false;
color AIcolor = #B31B1B; // AI = allow instance
color SScolor = #B31B1B; // SS = started signal
color TMcolor = #B31B1B; // TM = training mode
color DRcolor = #007000; // DR = Drawing / Reseting
int mutingMilli = 0;

// instance making -------------------------------------------------------------------------------------
final int COLS = 2;
final int ROWS = 100;
float[][] candidates = new float[COLS][ROWS]; // data structure that is being checked for signal

boolean userMadeSignal = false;
int rowsTraversing = 80;            // should be below rows
final int RESET_ROWS_TRAVERSING = 80; // should be equal to rowsTraversing
final float REDUCTION_FACTOR = 0.7;  // reduces the amount of rows traversed for the "finished" signal
final int SIM_THRESHOLD = 6;        // threshold that should not be violated for a signal to be valid

float [] checkMarkPostSignal = new float [] { 0.0, 0.0 };
IntList instanceMillis;      // parallel to the instance ArrayList to complete the csv
ArrayList<PVector> instance; // data structure that will become the CSV

boolean drawPOIs = false;

// #####################################################################################################################################
void setup() {
  
  // size(1024, 848, P2D);
  size(1024, 648, P2D); // the field of view is 512x424

  kinect2 = new Kinect2(this);
  //kinect2.initVideo();
  kinect2.initDepth();
  //kinect2.initIR();
  //kinect2.initRegistered();

  instance = new ArrayList<PVector>();
  instanceMillis = new IntList();
  
  trackColor = color(255, 0, 0);
  
  // Start all data
  kinect2.initDevice();
  
  // print the default text size
  //println("The default text size is: ", g.textSize);

  // set text size
  textSize(22);
    
  frameRate(30);
}

// #####################################################################################################################################
void draw() {
  
  background(0);
  
  // (1) find pixels
  float [] p = findImportantPixels(); 
  
  // allowInstances is the control variable that is toggled on and of by 's' or 'S' key
  if (allowInstances) {
  
    int m = millis();
    
    // (2.1) check if the user started drawing - if he/she also made signal, start adding
    if (userMadeSignal && !startedDrawing) { updateInstance(new PVector(p[0], p[1], p[2]), m); checkForUncertainty(p[3], p[4]); }

    // (2.2) check if the user started drawing - this opens up the possibility to start re-listening
    if (!userMadeSignal && !startedDrawing) { checkForUncertainty(p[3], p[4]); }

    // (3) update data strutures if the user made signal and started drawing
    if (userMadeSignal && startedDrawing) { updateInstance(new PVector(p[0], p[1], p[2]), m); }
  
  } 
  
  // (4) draw the ui
  updateScreenInfo(p);
        
  // (5) check for user signal --- whenever a user makes a signal, startedDrawing starts false!!!
  if (allowInstances) { signalCheck(); }
  
}

// #####################################################################################################################################
float [] findImportantPixels() {
  
  if (depthTrackingOn) { // depth case
  
    // find Points Of Interest with "best depth's neighborhood" technique
    //float [] POIs = depthBlobPixels();
        
    float [] POIs = depthBlobPixels();
    
    // in case POIs comes null return null to main loop too
    //if (POIs == null) { return null; } else { return POIs; }
    if (POIs == null) { return new float [] { -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0 }; } else { return POIs; }
    
  } else { return new float [] { -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0 }; }
  
}

// #####################################################################################################################################
void checkForUncertainty(float x, float y) {
  
  // find the distance of the current point with the checkmark that beginned the last instance
  float d = dist(checkMarkPostSignal[0], checkMarkPostSignal[1], x, y);
  
  // compare the distance with the threshold set
  if (d > SIM_THRESHOLD) { 
    
      // allows the point to be recorded
      startedDrawing = true;
      
      // set the color for feedback
      DRcolor = #007000;
    
    }
  
}

// #####################################################################################################################################
void updateInstance(PVector hotVec, int timestamp) {
  //print("The vector to begin with has this value: "+hotVec);
  // map r.x and r.y to 0 - 255 space to match z
  //float mx = map(hotVec.x, 0, 511, 0, 256);
  //float my = map(hotVec.y, 0, 423, 0, 256);
  //println(" || its x, y are transformed: "+mx+" "+my);
  // update data structures
  instance.add(new PVector(hotVec.x, hotVec.y, hotVec.z));
  instanceMillis.append(timestamp);

}

// #####################################################################################################################################
void updateScreenInfo(float [] pix) {
  
  /* --- the 0,1,2 indices in pix vector are the real coordinates of the point
     --- the 3,4 indices are the x,y means of the blobs that are transformed to the above 0,1 indices
     --- the 5,6 indices are the x,y of the single closest point */
  
  if (pix.length > 3) {
    
    // drawi GUI ad stuff
    drawEverything(pix[3], pix[4], pix[5], pix[6]);  // depth case
    
  } 
  
}