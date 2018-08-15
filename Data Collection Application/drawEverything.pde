// #####################################################################################################################################
void drawEverything(float meanX, float meanY, float closestX, float closestY) {
  
    // draw meta data
    drawInfo();
  
    // draw box
    drawContourFindings(meanX, meanY);
    
    // update and draw history
    updateAndDrawHistory(meanX, meanY); // -------> does translate
    
    // keep track of the closest point for debugging purposes
    noStroke();
    fill(63, 255, 0); // Harlequin
    ellipse(closestX, closestY, SEARCH_AREA/2, SEARCH_AREA/2);

} // PILOT FUNCTION

// #####################################################################################################################################
void drawInfo() {
    
  // text
  fill(140);
  text(" Framerate: " + (int)(frameRate), 25, 448);

  fill(220);
  text("train_mode: ", 130, 550);
  text("Instances: ", 147, 605);

  text("signal_ON: ", 360, 550);
  text("drawing_ON: ", 336, 605);
  
  strokeWeight(3);
  stroke(210);
  line(555, 515, 555, 635);
  strokeWeight(1);
  
  text("search area: "+SEARCH_AREA, 597, 550);
  text("search depth: "+MORE_DEPTH, 580, 605);
  
  // colors
  noStroke();
  fill(TMcolor); // TM = training mode
  rect(290, 544, 42, 42);
  fill(AIcolor); // AI = allow instance
  rect(290, 597, 42, 42);
  fill(SScolor); // IIC = instance is cooking (the user made a signal that he is willing to give a lock)
  rect(508, 544, 42, 42);
  fill(DRcolor); // IIC = Drawing - Reseting
  rect(508, 597, 42, 42);
  fill(255);

}

// #####################################################################################################################################
void drawContourFindings(float x, float y) {
  //pushMatrix(); //-------------------------------- push -------
  //translate(0, 0, 0);
  //if (drawPOIs) { b.drawPOIs(); }
  
  // <11> Draw the bounding box of our object
  noFill(); 
  strokeWeight(1); 
  stroke(255, 36, 0); // scarlet
  rectMode(CENTER);
  rect(x, y, SEARCH_AREA, SEARCH_AREA);
  
  // <12> Draw a dot in the middle of the bounding box, on the object.
  noStroke(); 
  fill(255, 36, 0); // scarlet
  ellipseMode(CENTER);
  ellipse(x, y, SEARCH_AREA/2, SEARCH_AREA/2);
  //popMatrix(); //--------------------------------- pop -------
}

// #####################################################################################################################################
void updateAndDrawHistory(float x, float y) {
  
  // update history
  for(int i = 0; i < COLS; i++) {
        
    candidates[i] = reverse(candidates[i]);
    candidates[i] = shorten(candidates[i]);
    candidates[i] = reverse(candidates[i]);
            
  }
  
  // first col is x and second y
  candidates[0] = append(candidates[0], x);
  candidates[1] = append(candidates[1], y);
  
  pushMatrix();
  // draw history
  translate(512, 0);
  stroke(255, 36, 0); // scarlet
  strokeWeight(2);
  for (int i = 1; i < ROWS; i++) {
    line(candidates[0][i-1], candidates[1][i-1], candidates[0][i], candidates[1][i]);
  }
  strokeWeight(1);
  popMatrix();
      
  stroke(255);
}