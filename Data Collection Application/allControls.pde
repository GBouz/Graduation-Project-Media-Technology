//// #####################################################################################################################################
void mousePressed() {
  
  color c = get(mouseX, mouseY);
  trackColor = c;
  println("r: " + red(c) + " g: " + green(c) + " b: " + blue(c));
   
  int hue = int(hue(c)); // former: int(map(hue(c), 0, 255, 0, 180));
  
  //rangeLow = (((hue - 5) % 256) + 256) % 256;
  //rangeHigh = (hue + 5) % 256;
  rangeLow = hue - COLOR_RANGE;
  rangeHigh = hue + COLOR_RANGE;
  
  rangeLowModulated = ((rangeLow % 256) + 256) % 256;
  rangeHighModulated = rangeHigh % 256;
  
  println("hue to detect: " + hue + " , " + "rangeLow: " + rangeLow + " , " + "rangeHigh: " + rangeHigh);
  println("rangeLowModulated: " + rangeLowModulated + " , " + "rangeHighModulated: " + rangeHighModulated);
  println("The saturation of the selected color is: ", saturation(hue));
  println("The brightness of the selected color is: ", brightness(hue));

}

// #####################################################################################################################################
void keyPressed() {
  
  // Start/Stop functionality
  // (instanceHasStarted == false), indicates that Start goes
  // KEY THAT ALLOWS RECORDING
  if ((key == 's' || key == 'S') && sKeyBlock == false) { 
        
    // invert the control value
    allowInstances = !allowInstances;
    
    // thrown a warning
    if (allowInstances) {
      
      println("~~ Instance production is allowed.");
      AIcolor = #007000;
      
    } else {
      
      println("~~ Instance production is not allowed.");
      AIcolor = #B31B1B;
      
    }
    
  // KEY FOR SECOND SCREEN
  } else if ((key == 'w' || key == 'W') && allowInstances == false) { 
    
    createWindow();
    
  // KEY FOR TRAINING MODE (DOESN'T SAVE CSV)
  } else if ((key == 't' || key == 'T') && allowInstances == false) {
    
    trainingModeOn = !trainingModeOn;
    
    if (trainingModeOn) { TMcolor = #007000; } else { TMcolor = #B31B1B; }
      
  // KEY FOR TRACKING MODE (COLOR - DEPTH SWAP)
  } else if ((key == 'c' || key == 'C') && allowInstances == false) {
    
    depthTrackingOn = !depthTrackingOn;
        
  // KEY TO CONTROL COLOR MODE (HUE - RGB SWAP)
  } else if ((key == 'h' || key == 'H') && allowInstances == false) {
    
    hueTrackingOn = !hueTrackingOn;
      
    // KEY FOR SEARCH_AREA
  } else if (key == '=') { 
    
    SEARCH_AREA += 1;

    // KEY FOR SEARCH_AREA
  } else if (key == '-') { 
    
    SEARCH_AREA -= 1;

    // KEY FOR MORE_DEPTH
  } else if (key == '9') { 
    
    MORE_DEPTH += 1;

    // KEY FOR MORE_DEPTH
  } else if (key == '0') { 
    
    MORE_DEPTH -= 1;

    // KEY FOR DRAWING POIs
  } else if (key == 'd' || key == 'D') { 
    
    drawPOIs = !drawPOIs;

  }

}