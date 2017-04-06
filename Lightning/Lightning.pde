void setup() {
  size(600, 600);
}

void draw() {
  background(#000000);
  color lightningcolor = #ffffff;
  color dotcolor = #ffffff;
  color activedotcolor = #ffa0a0;

  int raster = 150;
  int dotsize = 10;
  ArrayList<PVector> dots = new ArrayList<PVector>();

  for (int i = 0; i <= pixelWidth; i+=raster) {
    for (int j = 0; j <= pixelWidth; j+=raster) {
      PVector currentDot = new PVector(i, j);
      dots.add(currentDot);
      drawDot(currentDot, dotsize, dotcolor);
    }
  }

  PVector mouseV = new PVector(mouseX, mouseY);

  for (PVector dot : dots) {
    if (PVector.dist(dot, mouseV) < raster) {
      stroke(lightningcolor);
      drawLightning(dot, mouseV);
      drawDot(dot, dotsize*2, activedotcolor);
    }
  }
}

void drawDot(PVector v, int size, color c) {
  fill(c);
  noStroke();
  ellipse(v.x, v.y, size, size);
  noFill();
}

void drawLightning(PVector source, PVector dest) {
  PVector route = PVector.sub(dest, source);
  PVector displace = route.copy();
  displace.rotate(HALF_PI);
  displace.normalize();

  float tlength = route.mag();

  int size = floor(tlength / 4);
  if (size == 0)
    size=1;

  float[] positions = new float[size];
  positions[0]=0;

  for (int i = 1; i< size-1; i++)
    positions[i]=random(0, 1);

  positions = sort(positions);

  float Sway = 80;
  float Jaggedness = 1 / Sway;

  PVector prevPoint = source;
  float prevDisplacefactor = 0.0;

  for (int i = 1; i <= positions.length-1; i++)
  {
    float pos = positions[i];

    // used to prevent sharp angles by ensuring very close positions also have small perpendicular variation.
    float scale = (tlength * Jaggedness) * (pos - positions[i - 1]);
    // defines an envelope. Points near the middle of the bolt can be further from the central line.
    float envelope = pos > 0.95 ? 20 * (1 - pos) : 1;
    float displacefactor = random(-Sway, Sway);
    displacefactor -= (displacefactor - prevDisplacefactor) * (1 - scale);
    displacefactor *= envelope;

    PVector ndis = new PVector();
    ndis = PVector.mult(displace, displacefactor);
    PVector point = PVector.lerp(source, dest, pos).add(ndis);//.add(ndis);
    strokeWeight(random(2,6));
    line(prevPoint.x, prevPoint.y, point.x, point.y);
    prevPoint = point.copy();
    prevDisplacefactor = displacefactor;
  }
  line(prevPoint.x, prevPoint.y, dest.x, dest.y);
}