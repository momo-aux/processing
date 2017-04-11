int factor = 8;
float defaultBallRadius=20;
int sizeFactor = floor(defaultBallRadius/2);

float gravity = 1;
float friction = 0.97;
float bounce = 0.96;
Physical selectedPhy; 
int ballx = 6;
int bally = 1;
PFont boldFont;
float restitution = 0.95;

ArrayList<Physical> objects = new ArrayList<Physical>();
void setup() {
  size(500, 500);
  boldFont = createFont("Arial Bold", 18);
  //
  for (int i = 1; i <= ballx; i++) {
    for (int j = 1; j <= bally; j++) {
      //objects.add(new Ball(defaultBallRadius, i*50, j*50, #FFFF00, #00FF00, new PVector(random(-.5, .5), random(-.5, .5)), true));
      float factor = random(defaultBallRadius-sizeFactor, defaultBallRadius+sizeFactor);
      objects.add(new Ball(1*factor, i*50*j, j*50, new PVector(random(-5,5),0), true, floor(factor/8)));
    }
  }
  /*/
   int i = 1;
   int j = 1;
   objects.add(new Ball(defaultBallRadius, i*50, j*50, #FFFF00, #00FF00, new PVector(.5, .5), true));
   //*/
}

void reset() {
  println("----- RESET -----");
  objects = new ArrayList<Physical>();
  setup();
}
void helpText() {
  String text = "Linksklick: Ball greifen\nRechtklick: Zurücksetzen"; 
  textFont(boldFont);
  fill(#FFFFFF);
  text(text, 10, 10, width, 50);
}

void draw() {
  background(#000000);
  helpText();
  for (int i=0; i<objects.size(); i++) {
    Physical phy = objects.get(i);
    phy.calc();
    for (int j=0; j<objects.size(); j++) {
      if (i!=j) {
        phy.collideAndResolve(objects.get(j));
      }
    }
    phy.draw();
  }
}


void mouseDragged() {
  if (mouseButton == LEFT) {
    if (selectedPhy != null) {
      selectedPhy.position = new PVector(mouseX, mouseY);
      selectedPhy.velocity =  new PVector();
    }
  }
}
void mousePressed() {
  if (mouseButton == LEFT) {
    selectedPhy=mouseColission();
    if (selectedPhy != null) {
      selectedPhy.dragged=true;
      selectedPhy.position = new PVector(mouseX, mouseY);
    }
  }
}
void mouseReleased() {
  if (mouseButton == LEFT) {
    if (selectedPhy != null) {
      selectedPhy.dragged=false;
      selectedPhy.velocity =  PVector.sub(new PVector(mouseX, mouseY), new PVector(pmouseX, pmouseY));
    }
  }
  if (mouseButton == RIGHT) {
    reset();
  }
}

Physical mouseColission() {
  Physical hit = null;
  for (int i=0; i<objects.size(); i++) {
    Physical phy = objects.get(i); 
    if (phy instanceof Ball) {
      Ball b = (Ball)phy;
      if (PVector.sub(b.position, new PVector(mouseX, mouseY)).mag() < b.diameter)
        return phy;
    }
  }
  return hit;
}
interface Collidable {
  void collideAndResolve(Physical col);
}

abstract class Physical implements Collidable {
  color cc;
  boolean sc;
  float restitution;
  float mass;
  float inv_mass;
  PVector velocity;
  float radius;
  PVector position;
  boolean dragged;
  abstract void collideAndResolve(Physical other);
  abstract void calc();
  abstract void draw();
}


class Ball extends Physical {
  color c;
  float diameter;

  Ball(float radius, int x, int y, PVector velocity, boolean showCollision, float mass) {
    this(radius, x, y);
    this.mass = mass;
    this.inv_mass = 1/mass;
    this.velocity=velocity;
    this.sc=showCollision;
  }

  Ball(float radius, int x, int y) {
    this.position = new PVector(x, y);
    this.radius = radius;
    init();
  }

  void init() {
    this.dragged=false;
    this.mass = 1;
    this.inv_mass = 1/mass;
    this.restitution = .85;
    this.c = #FFFFFF;
    this.cc = #FF0000;
    this.sc = false;
    this.diameter = radius*2;
  }

  void calcColor() {
    this.c = color(this.velocity.mag()/10*255, 255-this.velocity.mag()/10*255, 0);
    /*/Debug colors
     int r = (this.c >> 16) & 0xFF;
     int g = (this.c >> 8) & 0xFF;
     int b = this.c & 0xFF;
     //*/
  }
  void calc() {
    if (!dragged) {
      velocity = velocity.mult(friction);
      velocity = velocity.add(new PVector(0,0.5));
      position.add(velocity);
    }

    calcColor();

    if (position.x - radius < 0) {
      position.x = radius;
      velocity.x *= -1;
    }
    if (position.x +radius > width) {
      position.x = width - radius;
      velocity.x *= -1;
    } 
    if (position.y - radius < 0) {
      position.y = radius;
      velocity.y *= -bounce;
    }
    if (position.y + radius > height) {
      position.y = height - radius;
      velocity.y *= -bounce;
    }
  }

  void collideAndResolve(Physical target) {

    if (target instanceof Ball) {
      float rhoch2 = (this.radius + target.radius);
      rhoch2 = pow(rhoch2, 2);
      float abstandhoch2 = PVector.sub(target.position, this.position).magSq();

      if (rhoch2 > abstandhoch2) {
        println("---RESOLVE---");

        PVector distance = PVector.sub(this.position, target.position);
        float d = distance.mag();
        // push-pull them apart based off their mass
        PVector move = distance.mult((this.radius+target.radius-d)/d);


        this.position = this.position.add(move.mult(this.inv_mass / (this.inv_mass + target.inv_mass)));
        target.position = target.position.sub(move.mult(target.inv_mass / (this.inv_mass + target.inv_mass)));

        // impact speed
        PVector v = (this.velocity.sub(target.velocity));
        //println("V:("+floor(v.x)+"|"+floor(v.y)+")");
        float vn = v.dot(distance.normalize());
        //println(vn);
        if (vn > 0.0f) return;
        // collision impulse
        float i = (-(1.0f + restitution) * vn)  / (this.inv_mass + target.inv_mass);
        PVector impulse = distance.normalize().mult(i);

        // change in momentum
        this.velocity = this.velocity.add(impulse.mult(this.inv_mass));
        target.velocity = target.velocity.sub(impulse.mult(target.inv_mass));
      }
    }
  }

  void resolveCollisionSimple(Physical target)
  {
    PVector difference = PVector.sub(target.position, this.position);
    difference.normalize();
    this.velocity.sub(difference);
  }

  void draw() {
    noFill();
    stroke(c);
    ellipse(position.x, position.y, diameter, diameter);
    if (velocity.magSq() > .5) {
      PVector dir = new PVector();
      velocity.normalize(dir);
      PVector spitze = PVector.mult(dir, radius).add(position);


      PVector start = PVector.sub(spitze, position);
      start.rotate(HALF_PI);
      start.normalize();
      PVector tri1 = PVector.mult(start, radius/2).add(position).lerp(spitze, 0.5);
      PVector tri2 = PVector.mult(start, -radius/2).add(position).lerp(spitze, 0.5);

      fill(c);
      beginShape();
      vertex(tri1.x, tri1.y);
      vertex(tri2.x, tri2.y);
      vertex(spitze.x, spitze.y);
      endShape(CLOSE);
      noFill();
    }
    fill(#FFFFFF);
    text(floor(mass), position.x-5, position.y+6);
  }
}