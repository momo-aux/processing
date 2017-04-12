int raster = 1;
float cubeposX = 0;
float cubeposY = 0;
float cubeposZ = 0;
float rotationX = 0;
float rotationY = 0;
float rotationZ = 0;

float startRotX = -45;
float startRotY = -45;
float startRotZ = 0;


float draggedX = 0;
float draggedY = 0;
float currentframe = 0;
  
void setup() {
  size(200, 200, P3D);
  cubeposX = width/2;
  cubeposY = height/2;
  
  //fullScreen(P3D);
  //noLoop();  // draw() will not loop
  println("width: " + width);
  println("height: " + height);
}

float x = 0;

void draw() {
  background(204);
  pushMatrix();
  //*/
  position3D();
  rotate3D();
  drawAxes3D();
  //noFill();
  drawObjects3D();
  animateMove3D();
  popMatrix();
  //*/
}

void drawObjects3D() {
  stroke(0,0,0);
  box(100);

}
void position3D() {
  translate(cubeposX, cubeposY, cubeposZ); 
}
void rotate3D() {
  rotateX(radians(rotationX+startRotX));
  rotateY(radians(rotationY+startRotY));
  rotateZ(radians(rotationZ+startRotZ));
}

void drawAxes3D() {
  stroke(255,0,0);
  line(0,0,0, 100,0,0);
  stroke(0,255,0);
  line(0,0,0, 0,-100,0);
  stroke(0,0,255);
  line(0,0,0, 0,0,100);
}
void mousePressed() {
  if (mouseButton == LEFT) {
  }
}

void mouseReleased() {
  if (mouseButton == RIGHT) {
    rotationX = 0;
    rotationY = 0;
  }
}

void animateMove3D() {
    currentframe+=0.01;
    if (currentframe>1.0)
      currentframe=1.0;
    rotationX += draggedX;
    rotationY += draggedY;
    draggedX = lerp(draggedX,0,currentframe);
    draggedY = lerp(draggedY,0,currentframe);
    //println("dragged("+draggedX+","+draggedY+")");
}

void mouseDragged() {
  if (mouseButton == CENTER) {
    cubeposX = mouseX;
    cubeposY = mouseY;
  }  
  if (mouseButton == LEFT) {
//    println("mouse x("+mouseX+") y("+mouseY+")");
//    println("pmouse x("+pmouseX+") y("+pmouseY+")");
//    println("rot x("+(pmouseX-mouseX)+") y("+(pmouseY-mouseY)+")");
    draggedX = (mouseY-pmouseY)*-1;
    draggedY = (mouseX-pmouseX);
    currentframe=0;

  }
}

void mouseWheel(MouseEvent event) {
  cubeposZ += event.getCount()*10;
}