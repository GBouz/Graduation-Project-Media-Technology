/*
 A more comprehensive version of the multiple windows code can
 be found at:
 
 http://www.lagers.org.uk/g4p/applets/g4p_windowsstarter
 
 for Processing V3, made by
 (c) 2015 Peter Lager
 
 */

public void createWindow() {
  //int col = c;
  window = new GWindow[1];
  //col = 0xff000000;
  //window[0] = GWindow.getWindow(this, "Window experiment", 70, 160, 700, 600, JAVA2D); // P2D was making the VM fail
  window[0] = GWindow.getWindow(this, "Window experiment", 70, 160, 1920, 1080, JAVA2D); // P2D was making the VM fail
  window[0].addData(new MyWinData());
  // pass the secondWinBG as data.col
  ((MyWinData)window[0].data).col = secondWinBGColors;
  //((MyWinData)window[0].data).colLock = lockColors;
  window[0].addDrawHandler(this, "windowDraw");
}

/**
 * Handles drawing to the windows PApplet area
 * 
 * @param appc the PApplet object embeded into the frame
 * @param data the data for the GWindow being used
 */
public void windowDraw(PApplet appc, GWinData data) {
  MyWinData data2 = (MyWinData)data;
  //appc.background(data2.col);
  appc.background(secondWinBGColors);
  
  appc.stroke(lockColors);
  // draw the lock "canvas"
  appc.rectMode(CENTER);
  appc.fill(255);
  float a = findSquareSide(appc.width, appc.height);
  appc.strokeWeight(3);
  appc.rect(appc.width/2, appc.height/2, a, a);
  
  appc.pushMatrix();
  appc.strokeWeight(lockStroke);
  appc.translate(appc.width/2, appc.height/2);
  // draw the lock
  float b = 0.4*a;  // (0.8*(a/2)) expression shortened to (0.4 * a)
  float c = 0.08585 * a; // factor to shrink the triangle basis: (4-3.1415)/(2+5) = 0.08585
  drawLock(appc, b, c);
  appc.popMatrix();

  appc.strokeWeight(1);
}  

public float findSquareSide(float w, float h) {
  
  if ((w / h) >= 1.0) {
    
    return h;
    
  } else {
    
    return w;
    
  }
  
}

public void drawLock(PApplet appc, float b, float c) {
  // lines that make an isoplevro triangle
  //appc.line(-b, b, b, b);
  //appc.line(-b, b, 0, -b);
  //appc.line(b, b, 0, -b);

  // lines that make an isosceles triangle, shrinked by a factor of: c = 0.08585 = (4-3.1415)/(2+5)
  //appc.triangle(-b+c, b, b-c, b, 0, -b);
  appc.line(-b+c, b, b-c, b);
  appc.line(-b+c, b, 0, -b);
  appc.line(b-c, b, 0, -b);
  
  //appc.noFill();
  //appc.arc(0, -b/2, b+0.1, -b-0.1, -QUARTER_PI+0.1, PI+QUARTER_PI-0.1, OPEN); // P2D
  appc.arc(0, -b/2, b, b, QUARTER_PI+HALF_PI-0.031415, TWO_PI+QUARTER_PI+0.031415, OPEN); //JAVA2D
  //appc.ellipse(0, -b/2,10,10);

}

/**
 * Simple class that extends GWinData and holds the data 
 * that is specific to a particular window.
 * 
 * @author Peter Lager
 */
class MyWinData extends GWinData {
  //int sx, sy, ex, ey;
  //boolean done;
  int col;
  //int colLock;
}