int factor = 8;
float defaultBallRadius;

float spring = 0.03;
float gravity = 1;
float friction = 0.95;
float bounce = 0.9;

ArrayList<Physical> objects = new ArrayList<Physical>();
void setup() {
  size(500, 500);
  defaultBallRadius = 25;
  objects.add(new Ball(defaultBallRadius, 300, 100, #0000FF, #FF0000, new PVector(), true));
  objects.get(0).mass=5;
  //
  for (int i = 1; i <= 1; i++) {
    for (int j = 1; j <= 2; j++) {
      //objects.add(new Ball(defaultBallRadius, i*50, j*50, #FFFF00, #00FF00, new PVector(random(-.5, .5), random(-.5, .5)), true));
      objects.add(new Ball(defaultBallRadius, i*50+10*j, j*50, #FFFF00, #00FF00, new PVector(), true));
    }
  }
  /*/
   int i = 1;
   int j = 1;
   objects.add(new Ball(defaultBallRadius, i*50, j*50, #FFFF00, #00FF00, new PVector(.5, .5), true));
   //*/
}

void draw() {
  background(#000000);
  for (int i=0; i<objects.size(); i++) {
    Physical phy = objects.get(i);
    phy.calc();
    for (int j=0; j<objects.size(); j++) {
      if (i!=j) {
        Physical other = objects.get(j);

        if (phy.collision(other)) {
          phy.resolveCollision(other);
          PVector hit = PVector.sub(other.position, phy.position);

          hit.normalize();
          hit.mult(PVector.sub(phy.position, other.position).mag()-phy.radius);


          hit.add(phy.position);
          if (phy.sc) {
            line(hit.x, hit.y, phy.position.x, phy.position.y);
          }
        }
      }
    }
    phy.draw();
  }
}


void mouseDragged() {
  if (mouseButton == LEFT) {
    objects.get(0).position = new PVector(mouseX, mouseY);
    objects.get(0).velocity =  new PVector();
  }
}
void mousePressed() {
  if (mouseButton == LEFT) {
    objects.get(0).dragged=true;
    objects.get(0).position = new PVector(mouseX, mouseY);
  }
}
void mouseReleased() {
  if (mouseButton == LEFT) {
    objects.get(0).dragged=false;
    objects.get(0).velocity =  PVector.sub(new PVector(mouseX, mouseY), new PVector(pmouseX, pmouseY));
  }
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

  Ball(float radius, int x, int y, color col, color collisioncolor, PVector velocity, boolean showCollision) {
    this.dragged=false;
    this.mass = 1;
    this.inv_mass = 1/mass;
    this.restitution = .1;
    this.position = new PVector(x, y);
    this.radius = radius;
    this.velocity = velocity;
    this.c = col;
    this.cc = collisioncolor;
    this.sc = showCollision;
    this.diameter = radius*2;
  }

  void calc() {
    if (!dragged) {
      velocity.y = velocity.y + (0.5*mass*gravity);
      if (position.y == height - radius) {
        velocity.mult(friction);
      }
      position.add(velocity);
    }

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
  }
}