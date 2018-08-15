// #####################################################################################################################################
float [] depthBlobPixels() {
  
  // init image
  image(kinect2.getDepthImage(), 0, 0, kinect2.depthWidth, kinect2.depthHeight);
  
  // get the raw depth data
  int[] depth = kinect2.getRawDepth();
  
  //b.clear();

  //
  // step1: find the lowest depth value in the image
  //

  // find the pixel with lowest depth value in two steps
  float dChamp_ = 5500.0;
  int dChampX = -1;
  int dChampY = -1;
    
  for (int x = 0; x < kinect2.depthWidth; x++ ) {
    
    for (int y = 0; y < kinect2.depthHeight; y++ ) {
      
      // pixel location
      int loc = x + y * kinect2.depthWidth;
      
      // current depth in 0-255 mapping
      float currentDepth = depth[loc];
      
      // if the currentDepth is the smallest, keep note
      if ((x > 2) && (x < 510) && (y > 2) && (y < 422)) {
        
        // (currentDepth > 20) goes because some pixels are black or too close and their value is 0.0
        if (currentDepth > 500 && currentDepth < dChamp_ && nearPixelsAgreement(depth, x, y, currentDepth)==true) {
          
          dChamp_ = currentDepth;
          dChampX = x;
          dChampY = y;
  
        }
      }
    }
  }

  // if nothing was found by step1 break the search
  if (dChampX == -1 || dChampY == -1) { println("Warning!! The lowest depth value was not found!! __ ", dChampX, dChampY); return null; }
  
  BlobDepth b = new BlobDepth(dChampX, dChampY, dChamp_);
  
  //
  // step2: loop again to find the point in the middle of the closest blob
  //
  
  // define the rectangle
  int rOverheadX = 0;
  if (dChampX > SEARCH_AREA && dChampX < 510 - SEARCH_AREA) {
    rOverheadX = SEARCH_AREA;
  } else {
    rOverheadX =  min ( 510 - dChampX , dChampX - 0 );
  }
  
  int rOverheadY = 0;
  if (dChampY > SEARCH_AREA && dChampY < 420 - SEARCH_AREA) {
    rOverheadY = SEARCH_AREA;
  } else {
    rOverheadY = min ( 382 - dChampY , dChampY - 0 );
  }
  
  // initialize thresholds
  float thresholdDepth_high = dChamp_ + MORE_DEPTH;
  float thresholdDepth_low = dChamp_ - MORE_DEPTH;
  //int pointsChecked = 0;
  
  // the loop is in an area of a rectangle around the lowest point - the only area to be scanned
  for (int x = dChampX - rOverheadX; x < dChampX + rOverheadX; x++ ) {
    
    for (int y = dChampY - rOverheadY; y < dChampY + rOverheadY; y++ ) {
      
      // pixel location
      int loc = x + y * kinect2.depthWidth;
      
      // if the pixel is similar in depth add it to blob
      float currentDepth = depth[loc];
      
      if ((currentDepth < thresholdDepth_high) && (currentDepth > thresholdDepth_low)) {
        
        b.add(x, y, currentDepth);
        
      }
      
      // increment the counter for points checked
      //pointsChecked++;
      
    }
    
  }
  
  // get the means of the POIs
  PVector fake_POI = b.means();
  
  /*
  print("The difference between the closest point, and the closest point of the blob in terms of x, y (in pixels) and z (in mm), is: ");
  print(fake_POI.x-dChampX, fake_POI.y-dChampY, fake_POI.z-dChamp_);
  print(" || The size of the blob is: "+b.getSize());
  
  if (b.getSize()==1) { print(", its values are: "+fake_POI.x+" "+fake_POI.y+" "+fake_POI.z); }
  
  println(" || The points checked are: "+pointsChecked);
  */
  
  // convert the mean values of the pixels rectangle to the values for csv 
  PVector POI = depthToPointCloudPos(fake_POI.x, fake_POI.y, fake_POI.z);
  
  // the 3 first values are the ones that should be outputted in the csv
  // the 4th and 5th values are the ones that reflect the center of the blob
  // the 6th and 7th values are the ones that reflect the closest point
  return new float[] { POI.x, POI.y, POI.z, fake_POI.x, fake_POI.y, dChampX, dChampY };

}

// #####################################################################################################################################
boolean nearPixelsAgreement(int[] depth, int xx, int yy, float chasedValue) {
  
  int differentiationThreshold = 100; // does not allow different values to score into candidatesCounter
  int candidatesThreshold = 4;        // considers a candidate good if 
  int candidatesCounter = 0;          // counter of how many good candidates appeared
          
  float d1 = depth[(xx+1) + yy * kinect2.depthWidth]; if ( abs ( d1 - chasedValue ) < differentiationThreshold ) { candidatesCounter++; }
  float d2 = depth[xx + (yy+1) * kinect2.depthWidth]; if ( abs ( d2 - chasedValue ) < differentiationThreshold ) { candidatesCounter++; }
  float d3 = depth[(xx-1) + yy * kinect2.depthWidth]; if ( abs ( d3 - chasedValue ) < differentiationThreshold ) { candidatesCounter++; }
  float d4 = depth[xx + (yy-1) * kinect2.depthWidth]; if ( abs ( d4 - chasedValue ) < differentiationThreshold ) { candidatesCounter++; }
  float d5 = depth[(xx+1) + (yy+1) * kinect2.depthWidth]; if ( abs ( d5 - chasedValue ) < differentiationThreshold ) { candidatesCounter++; }
  float d6 = depth[(xx+1) + (yy-1) * kinect2.depthWidth]; if ( abs ( d6 - chasedValue ) < differentiationThreshold ) { candidatesCounter++; }
  float d7 = depth[(xx-1) + (yy+1) * kinect2.depthWidth]; if ( abs ( d7 - chasedValue ) < differentiationThreshold ) { candidatesCounter++; }
  float d8 = depth[(xx-1) + (yy-1) * kinect2.depthWidth]; if ( abs ( d8 - chasedValue ) < differentiationThreshold ) { candidatesCounter++; }

  float d9 = depth[(xx+2) + yy * kinect2.depthWidth]; if ( abs ( d9 - chasedValue ) < differentiationThreshold ) { candidatesCounter++; }
  float d10 = depth[xx + (yy+2) * kinect2.depthWidth]; if ( abs ( d10 - chasedValue ) < differentiationThreshold ) { candidatesCounter++; }
  float d11 = depth[(xx-2) + yy * kinect2.depthWidth]; if ( abs ( d11 - chasedValue ) < differentiationThreshold ) { candidatesCounter++; }
  float d12 = depth[xx + (yy-2) * kinect2.depthWidth]; if ( abs ( d12 - chasedValue ) < differentiationThreshold ) { candidatesCounter++; }
  //float d5 = depth[(xx+1) + (yy+1) * kinect2.depthWidth]; if ( abs ( d5 - chasedValue ) < differentiationThreshold ) { candidatesCounter++; }
  //float d6 = depth[(xx+1) + (yy-1) * kinect2.depthWidth]; if ( abs ( d6 - chasedValue ) < differentiationThreshold ) { candidatesCounter++; }
  //float d7 = depth[(xx-1) + (yy+1) * kinect2.depthWidth]; if ( abs ( d7 - chasedValue ) < differentiationThreshold ) { candidatesCounter++; }
  //float d8 = depth[(xx-1) + (yy-1) * kinect2.depthWidth]; if ( abs ( d8 - chasedValue ) < differentiationThreshold ) { candidatesCounter++; }

  if (candidatesCounter >= candidatesThreshold) { return true; } else { return false; }
  
}

//calculte the xyz camera position based on the depth data
PVector depthToPointCloudPos(float x, float y, float depthValue) {
  PVector point = new PVector();
  point.z = (depthValue);// / (1.0f); // Convert from mm to meters
  point.x = (x - CameraParams.cx) * point.z / CameraParams.fx;
  point.y = (y - CameraParams.cy) * point.z / CameraParams.fy;
  return point;
}