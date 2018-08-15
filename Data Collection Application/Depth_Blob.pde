// BlobDepth Class
// the main data structure that holds the important pixels for finding the Point of Interest the application needs

class BlobDepth {
  ArrayList<PVector> points;

  // constructor
  BlobDepth(float x, float y, float z) {
    points = new ArrayList<PVector>();
    points.add(new PVector(x, y, z));
  }

  // adds a point to the blob
  void add(float x, float y, float z) {
    points.add(new PVector(x, y, z));
  }

  // find the means of the blob  
  PVector means() {
    
    // placeholders
    float meanX = 0;
    float meanY = 0;
    float meanZ = 0;
    
    for (PVector point : points) {
      meanX += point.x;
      meanY += point.y;
      meanZ += point.z;
    }
    
    // find denominator
    int n = points.size();
    
    // find final values for means
    meanX = meanX/n;
    meanY = meanY/n;
    meanZ = meanZ/n;
    
    return new PVector(meanX, meanY, meanZ);
    
  }
  
  // draw the pois
  void drawPOIs() {
    
    for (PVector point : points) {
      
      noStroke();
      fill(255);
      ellipse(point.x, point.y, 1, 1);
      
    } 
    
  }
  
  float getSize() {
    return points.size();
  }
  
}