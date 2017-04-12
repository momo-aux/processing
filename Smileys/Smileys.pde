float mousePosX = 0;
float mousePosY = 0;
int headsize=100;
int padding=0;

void setup() {
  size(500, 500);
}

void draw() {
  mousePosX+=mouseX-pmouseX;  
  mousePosY+=mouseY-pmouseY; 
  background(255);
  for (int i = 0; i< (width/headsize)+1; i++)
    for (int j = 0; j< (height/headsize)+1; j++)
      drawHead(i*headsize+headsize/2+padding, j*headsize+headsize/2+padding, headsize);
}

void drawHead(int x, int y, float size) {
  PVector v1 = new PVector(x-(size/6), y-(size/6));
  PVector v2 = new PVector(x+(size/6), y-(size/6)); 
  PVector vmouse = new PVector(mouseX, mouseY);

  PVector v1distance = PVector.sub(vmouse, v1);
  PVector v2distance = PVector.sub(vmouse, v2);
  v1distance.normalize();
  v2distance.normalize();

  //
  //Kopf
  fill(#FFFF00);
  strokeWeight(1);
  ellipse(x, y, size, size);
  //Augapfel
  fill(#FFFFFF);
  ellipse(v1.x, v1.y, (size/3.5), (size/3.5));
  ellipse(v2.x, v2.y, (size/3.5), (size/3.5));
  //Pupille
  fill(#000000);
  int factor = 8;
  ellipse(v1.x+(v1distance.x*factor), v1.y+(v1distance.y*factor), (size/10), (size/10));
  ellipse(v2.x+(v2distance.x*factor), v2.y+(v2distance.y*factor), (size/10), (size/10));
//*/

  noFill();
  stroke(#000000);   
  strokeWeight(5);
  beginShape();
  vertex(v1.x-(size/6), v1.y+(size/3));
  quadraticVertex(v1.x+((v2.x-v1.x)/2), v1.y+(size/2)-Math.min(size/3, PVector.sub(vmouse, v1).mag()/(size/6)), v2.x+(size/6), v2.y+(size/3)); 
  endShape();
}