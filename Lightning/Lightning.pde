color lightningcolor = #ffffff;
color dotcolor = #ffffff;
color activedotcolor = #ffa0a0;
int raster = 150;
int dotsize = 10;

//ArrayList containing the dots to start the Lightningbeams if close 
ArrayList<PVector> dots = new ArrayList<PVector>();


void setup() {
  size(600, 600);
  //Setup the dots position
  for (int i = 0; i <= pixelWidth; i+=raster) {
    for (int j = 0; j <= pixelWidth; j+=raster) {
      PVector currentDot = new PVector(i, j);
      dots.add(currentDot);
    }
  }
}

void draw() {
  //Clean Screen
  background(#000000);

  //Draw the dots
  for (int i = 0; i <= pixelWidth; i+=raster) {
    for (int j = 0; j <= pixelWidth; j+=raster) {
      PVector currentDot = new PVector(i, j);
      drawDot(currentDot, dotsize, dotcolor);
    }
  }
  
  //create a mouseposition vector
  PVector mouseV = new PVector(mouseX, mouseY);
  
  //draw the Lightning and Active Dot 
  for (PVector dot : dots) {
    if (PVector.dist(dot, mouseV) < raster) {
      stroke(lightningcolor);
      //Lightning first
      drawLightning(dot, mouseV);
      //Active dot afterwards to make it look like it comes out of the dot
      drawDot(dot, dotsize*2, activedotcolor);
    }
  }
}

//draw a dot with the given color
void drawDot(PVector v, int size, color c) {
  fill(c);
  noStroke();
  ellipse(v.x, v.y, size, size);
  noFill();
}

//draw a lightning from source to dest
void drawLightning(PVector source, PVector dest) {
  //subtract dest from source to get the actual route vector
  PVector route = PVector.sub(dest, source);
  //create a 90deg rotated normalized vector to shift the segments
  PVector displace = route.copy();
  displace.rotate(HALF_PI);
  displace.normalize();

  //the length of the route
  float tlength = route.mag();


  //split the route into parts
  int size = floor(tlength / 4);
  if (size == 0)
    size=1;

  float[] positions = new float[size];
  positions[0]=0;

  for (int i = 1; i< size-1; i++)
    positions[i]=random(0, 1);

  //sort the array from smal to big values to have a list of positions to use as segments
  //if we do not sort, we can't draw segment by segment.
  positions = sort(positions);

  //the power of the rocking
  float Sway = 80;
  //how jagged should it be
  float Jaggedness = 1 / Sway;

  //where to start the segment
  PVector prevPoint = source;
  //last factor to smoothen the amplitude
  float prevDisplacefactor = 0.0;

  for (int i = 1; i <= positions.length-1; i++)
  {
    //current segment position
    float pos = positions[i];

    // used to prevent sharp angles by ensuring very close positions also have small perpendicular variation.
    float scale = (tlength * Jaggedness) * (pos - positions[i - 1]);
    // defines an envelope. Points near the middle of the bolt can be further from the central line.
    float envelope = pos > 0.95 ? 20 * (1 - pos) : 1;
    //calculate the displacement from -sway to sway so we can go in both directions
    float displacefactor = random(-Sway, Sway);
    displacefactor -= (displacefactor - prevDisplacefactor) * (1 - scale);
    displacefactor *= envelope;

    //calculate the distance on the rotated vector by multiplying
    PVector ndis = new PVector();
    ndis = PVector.mult(displace, displacefactor);
    
    //this is the calculated endpoint of the current segment
    PVector point = PVector.lerp(source, dest, pos).add(ndis);
    //randomize the stroke a bit to have a more random look for the segment
    strokeWeight(random(2, 6));
    //now draw the current segment
    line(prevPoint.x, prevPoint.y, point.x, point.y);
    //save the point to start the next segment with it
    prevPoint = point.copy();
    prevDisplacefactor = displacefactor;
  }
  //draw the last segment to the mouse position
  line(prevPoint.x, prevPoint.y, dest.x, dest.y);
}