int factor = 8;
PVector defaultBallSize;
PVector screenDiag;
ArrayList<Ball> balls = new ArrayList<Ball>();
void setup() {
  size(500, 500);
  defaultBallSize = new PVector(100, 100);
  screenDiag = new PVector(pixelWidth, pixelHeight);
  balls.add(new Ball(100, 300, 100, #0000FF, #FF0000, true));
  balls.add(new Ball(100, 300, 180, #00FFFF, #00FF00, true));
}

void draw() {
  background(#000000);
  for (int i=0; i<balls.size(); i++) {
    Ball ball = balls.get(i);
    ball.calc();
    ball.draw();
    for (int j=0; j<balls.size(); j++) {
      if (i!=j) {
        Ball other = balls.get(j);
        ball.collision = ball.collision(other);
        if (ball.collision) {
          PVector hit = PVector.sub(other.position, ball.position);

          hit.normalize();
          hit.mult(PVector.sub(ball.position, other.position).mag()-(ball.sizeH.mag()/2));


          hit.add(ball.position);
          println("h: " + hit);
          if (ball.sc) {
            line(hit.x, hit.y, ball.position.x, ball.position.y);
          }
        }
      }
    }
  }
}


void mouseDragged() {
  if (mouseButton == LEFT) {
    balls.get(0).position = new PVector(mouseX, mouseY);
  }
}

class Ball {
  PVector position;
  PVector sizeH;
  PVector sizeV;
  PVector power;
  PVector movement;
  boolean collision;
  color c;
  color cc;
  boolean sc;

  Ball(float size, int x, int y, color col, color collisioncolor, boolean showCollision) {
    collision = false;
    position = new PVector(x, y);
    sizeH = new PVector(size, 0);
    sizeV = new PVector(0, size);
    power = new PVector(1, 1);
    movement = new PVector(0, 0);
    c = col;
    cc = collisioncolor;
    sc = showCollision;
  }

  void calc() {
    //position.add(movement);
    float lengthV = PVector.mult(sizeV, .5).mag();
    float lengthH = PVector.mult(sizeH, .5).mag();

    if (position.x<lengthV)
      position.x=lengthV;
    if (position.y<lengthH)
      position.y=lengthH;
    if (position.x>pixelWidth-lengthV)
      position.x=pixelWidth-lengthV;
    if (position.y>pixelHeight-lengthH)
      position.y=pixelHeight-lengthH;
  }

  boolean collision(Ball other) {
    return (other.position.copy().sub(this.position).mag())-sizeH.mag() < 0;
  }

  void draw() {

    noFill();
    if ((collision) && (sc))
      stroke(cc);
    else
      stroke(c);

    ellipse(position.x, position.y, sizeV.mag(), sizeH.mag());
  }
  void drop() {
    position = new PVector(mouseX, mouseY);
  }
}