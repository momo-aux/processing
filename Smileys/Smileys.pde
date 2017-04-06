float mousePosX = 0;
float mousePosY = 0;
int headsize=100;
int padding=0;

void setup() {
  size(displayWidth, displayHeight);
}

void draw() {
  mousePosX+=mouseX-pmouseX;  
  mousePosY+=mouseY-pmouseY; 
  background(255);
  for (int i = 0; i< (displayWidth/headsize)+1; i++)
    for (int j = 0; j< (displayHeight/headsize)+1; j++)
      drawHead(i*headsize+padding, j*headsize+padding, headsize);
}

void drawHead(int x, int y, float size) {
  PVector v1 = new PVector(x-(size/6), y-(size/6));
  PVector v2 = new PVector(x+(size/6), y-(size/6)); 
  PVector vmouse = new PVector(mouseX, mouseY);

  PVector v1distance = PVector.sub(vmouse, v1);
  PVector v2distance = PVector.sub(vmouse, v2);
  v1distance.normalize();
  v2distance.normalize();

  //Kopf
  fill(#000000);
  ellipse(x, y, size, size);
  //Augapfel
  fill(#FFFFFF);
  ellipse(v1.x, v1.y, (size/3.5), (size/3.5));
  ellipse(v2.x, v2.y, (size/3.5), (size/3.5));
  //Pupille
  fill(#000000);
  float distanceX = mousePosX;
  float distanceY = mousePosY;
  int factor = 8;
  ellipse(v1.x+(v1distance.x*factor), v1.y+(v1distance.y*factor), (size/10), (size/10));
  ellipse(v2.x+(v2distance.x*factor), v2.y+(v2distance.y*factor), (size/10), (size/10));
  fill(#FFFFFF);
  noStroke();
  ellipse(x-(size/6), y+(size/5), (size/5), (size/5));
  ellipse(x+(size/6), y+(size/5), (size/5), (size/5));
  rectMode(CENTER);
  float mouthx = x-(size/6)+(size/5)-1;
  float mouthy = y+(size/5);
  float mouthwidth = (size/6)*2;
  float mouthheight = (size/5);

  rect(mouthx, mouthy, mouthwidth, mouthheight);
  stroke(0);
  fill(#000000);
  line(x-(size/6), y+(size/5), x-(size/6), mouthy-(size/5));
  line(x-(size/6), y+(size/5), x-(size/6), mouthy+(size/5));

  line(x+(size/6), y+(size/5), x+(size/6), mouthy-(size/5));
  line(x+(size/6), y+(size/5), x+(size/6), mouthy+(size/5));

  line(x, y+(size/5), x, mouthy-(size/5));
  line(x, y+(size/5), x, mouthy+(size/5));
  
  line(x-(size/6)-(size/5), y+(size/5), x+(size/6)+(size/5), y+(size/5));

}

