// #####################################################################################################################################
void signalCheck() {
  
  // listens for a signal and acts accordingly
  if (startedDrawing) { signalCatcher(); }
  
  int celebrationDuration = 500;
  // celebrates for a time after a "closing the instance" signal, else it makes the lock background white
  if (userMadeSignal == false && (millis() - mutingMilli) < celebrationDuration) { celebrate(); } else {secondWinBGColors = secondWinBGIdle; }

} // PILOT

// #####################################################################################################################################
void signalCatcher() {
  
  // identify stable hand or return void
  //float [] checkMark = new float [] {candidates[0][ROWS-rowsTraversing], candidates[1][ROWS-rowsTraversing]};
  float [] checkMark = new float [] {candidates[0][ROWS-1], candidates[1][ROWS-1]};
  
  // go through every point (can also sample if it is expensive computationaly)
  for(int i = ROWS-rowsTraversing+1; i < ROWS; i++) {
    
    // distance between the first point of the array and the current one at check
    float d = dist(checkMark[0], checkMark[1], candidates[0][i], candidates[1][i]);
    
    // breaks everything - NO signal was made
    if (d > SIM_THRESHOLD) { return; }
    
  }
  
  // a signal is made!
  userMadeSignal = !userMadeSignal;
  
  // the user made a signal but he didn't start drawing yet
  startedDrawing = false; DRcolor = #B31B1B;

  // update checkmark to check when to unmute
  checkMarkPostSignal[0] = checkMark[0];
  checkMarkPostSignal[1] = checkMark[1];      

  // adapt gui and make it easier to signal while instance is cooking 
  if (userMadeSignal == true) {
        
    // blocks the keypressed 's' to close allowInstances
    sKeyBlock = true;
    
    // shorten the signal needed for closing the loop
    rowsTraversing = round(rowsTraversing * REDUCTION_FACTOR);
    
    // inform console and GUI about the status
    println("_ The instance is cooking ...");
    SScolor = #007000;
    lockColors = lockColorsCooking;
    lockStroke = 6;
    
  // save and reset the instance if the signal is false 
  } else {
    
    // save the instance in file, if not in training mode
    if (!trainingModeOn) { 
      
      dropInstanceCSV(); // <---------------------------- drop csv here
      println("____ The instance has been saved as: " + SUBJECT_NAME + "_" + instanceCounter + ".csv");
      
      // increment the counter of recorded instances
      instanceCounter++;
      
    } 
    
    // reset the sketch data structures for the next instance
    prepareForNextInstance();

    // update GUI colors
    SScolor = #B31B1B;
    lockColors = lockColorsIdle;
    lockStroke = 5;
    secondWinBGColors = successColors;
    
    // the user made negative signal but he didn't reset his position yet
    mutingMilli = millis();

    // opens the keypressed 's' functionality
    sKeyBlock = false;
    
  }
  
}

// #####################################################################################################################################
void dropInstanceCSV() {
  
  // initialize the table
  Table instanceBuffer;
  instanceBuffer = new Table();
  instanceBuffer.addColumn("x");
  instanceBuffer.addColumn("y");
  instanceBuffer.addColumn("z");
  instanceBuffer.addColumn("millis");
  
  /*  ---- 
  
  The comented lines here, attempt to shorten the output
  
  ----
  
  // get the size of the ArrayList
  int s = instance.size();
  
  // shorten the ArrayList instance 1.1 (has an issue - function of private type)
  //instance.removeRange(s-1, s-rowsTraversing);
  
  // shorten the ArrayList instance 1.2 
  for (int i = s-1; i > s-rowsTraversing+10; i--) { instance.remove(i); }
  
  */
  
  // populate
  int i = 0;
  for (PVector v : instance) {
    TableRow row = instanceBuffer.addRow();
    row.setFloat("x", v.x);
    row.setFloat("y", v.y);
    row.setFloat("z", v.z);
    row.setInt("millis", instanceMillis.get(i));
    
    i++;
  }
  
  // save
  saveTable(instanceBuffer, "data/" + SUBJECT_NAME + "_" + instanceCounter + ".csv");
    
}

// #####################################################################################################################################
void prepareForNextInstance() {
  
  instance.clear();
  instanceMillis.clear();
  rowsTraversing = RESET_ROWS_TRAVERSING;

}

// #####################################################################################################################################
void celebrate() {
  
  if (secondWinBGColors == successColors) {
    
    secondWinBGColors = successCelebrationColors;
    
  } else {
    
    secondWinBGColors = successColors;
    
  }
  
}