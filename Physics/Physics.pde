int factor = 8;
float defaultBallRadius=20;
int sizeFactor = floor(defaultBallRadius/2);

float spring = 0.03;
float gravity = 1;
float friction = 0.95;
float bounce = 0.9;
Physical selectedPhy; 
int ballx = 5;
int bally = 2;
PFont boldFont;

ArrayList<Physical> objects = new ArrayList<Physical>();
void setup() {
  size(500, 500);
  boldFont = createFont("Arial Bold", 18);
  //
  for (int i = 1; i <= ballx; i++) {
    for (int j = 1; j <= bally; j++) {
      //objects.add(new Ball(defaultBallRadius, i*50, j*50, #FFFF00, #00FF00, new PVector(random(-.5, .5), random(-.5, .5)), true));
      objects.add(new Ball(random(defaultBallRadius-sizeFactor, defaultBallRadius+sizeFactor), i*50+10*j, j*50, new PVector(), true, 1));
    }
  }
  /*/
   int i = 1;
   int j = 1;
   objects.add(new Ball(defaultBallRadius, i*50, j*50, #FFFF00, #00FF00, new PVector(.5, .5), true));
   //*/
}

void reset() {
  int i = 1;
  int j = 1;
  for (Physical phy : objects) {
    if (i > ballx) {
      i=1;
      j++;
    }
    phy.position.x=i*50+10*j;
    phy.position.y=j*50;
    phy.velocity = new PVector();
    i++;
  }
}
void helpText() {
  String text = "Linksklick: Ball greifen\nRechtklick: Zurücksetzen"; 
  textFont(boldFont);
  fill(#FFFFFF);
  text(text, 10, 10,width,50); 
  
}

void draw() {
  background(#000000);
  helpText();
  for (int i=0; i<objects.size(); i++) {
    Physical phy = objects.get(i);
    phy.calc();
    for (int j=0; j<objects.size(); j++) {
      if (i!=j) {
        Physical other = objects.get(j);

        if (phy.collision(other)) {
          phy.resolveCollision(other);
        }
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
  boolean collision(Physical col);
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
  abstract boolean collision(Physical col);
  abstract void resolveCollision(Physical other);
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
    this.restitution = .1;
    this.c = #FFFFFF;
    this.cc = #FF0000;
    this.sc = false;
    this.diameter = radius*2;
  }

  void calcColor() {
    this.c = color(this.velocity.mag()/20*255, 255-this.velocity.mag()/20*255, 0);
    /*/Debug colors
     int r = (this.c >> 16) & 0xFF;
     int g = (this.c >> 8) & 0xFF;
     int b = this.c & 0xFF;
     //*/
  }
  void calc() {
    if (!dragged) {
      velocity.y = velocity.y + (0.5*mass*gravity);
      if (position.y == height - radius) {
        velocity.mult(friction);
      }
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

  boolean collision(Physical other) {
    if (other instanceof Ball) {
      float rhoch2 = (this.radius + other.radius);
      rhoch2 = rhoch2*rhoch2;
      float abstandhoch2 = PVector.sub(other.position, this.position).magSq();
      return rhoch2 > abstandhoch2;
    }
    return false;
  }

  void resolveCollision(Physical target)
  {
    /*/
     // Calculate relative velocity
     PVector rv = PVector.sub(target.velocity, this.velocity);
     PVector normal = PVector.sub(target.position,this.position);
     normal.normalize();
     // Calculate relative velocity in terms of the normal direction
     float velAlongNormal = PVector.dot(rv,normal);
     
     println(velAlongNormal);
     // Calculate restitution
     
     // Do not resolve if velocities are separating
     if(velAlongNormal > 0)
     return;
     
     float e = min( this.restitution, target.restitution);
     float j = -(1 + e) * velAlongNormal;
     j = j / ( this.inv_mass + target.inv_mass );
     
     PVector impulse = rv.mult(j);
     this.velocity = PVector.sub(this.velocity,PVector.mult(impulse,this.inv_mass));
     target.velocity=PVector.add(target.velocity,PVector.mult(impulse,target.inv_mass));
     //*/
    PVector difference = PVector.sub(target.position, this.position);
    difference.normalize();
    this.velocity.sub(difference);
  }

  void draw() {
    noFill();
    stroke(c);
    ellipse(position.x, position.y, diameter, diameter);

    if (velocity.magSq() > 1) {
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
  }
}