Flea flea;

int worldwidth=500;
int worldheight=500;
World world = new World(worldwidth, worldheight);
float startsize = 2;
PVector startpos = new PVector(worldwidth/2, worldheight-startsize);
PVector startvelo = new PVector();

void setup() {
  size(500, 500);

  flea = new Flea(startpos, startvelo, startsize, world);
  world.boxes.add(new Box(new PVector(0, height-10), 100, 10));
  world.boxes.add(new Box(new PVector(200, height-10), 100, 10));
  world.boxes.add(new Box(new PVector(400, height-10), 100, 10));
  world.boxes.add(new Box(new PVector(100, 400), 100, 10));
  world.boxes.add(new Box(new PVector(400, 350), 80, 10));
  world.boxes.add(new Box(new PVector(90, 220), 200, 10));
  world.boxes.add(new Box(new PVector(400, 100), 90, 10));
  world.boxes.add(new Box(new PVector(10, 100), 200, 10));
}

void draw() {
  background(#000000);
  flea.calc();
  world.draw();
  flea.draw();
}

class Box {
  PVector position;
  float w;
  float h;

  Box(int x, int y, int w, int h) {
    this(new PVector(x, y), w, h);
  }

  Box(PVector position, int w, int h) {
    this.position = position;
    this.w=w;
    this.h=h;
  }

  void draw() {
    noStroke();
    fill(#ffffff);
    rect(position.x, position.y, w, h);
  }
}

class World {
  int width;
  int height;
  PVector gravity = new PVector(0, 0.3);
  float bounce = 0.4;
  float friction = 0.99;
  ArrayList<Box> boxes= new ArrayList<Box>();

  World(int width, int height) {
    this.width = width;
    this.height = height;
  }

  void draw() {
    collision(flea);
  }
  void collision(Flea flea) {
    for (Box box : boxes) {
      box.draw();
      if (intersects(box, flea)) {
        handleCollision(box, flea);
      }
    }
  }
  void handleCollision(Box box, Flea flea) {
    flea.position.add(PVector.mult(flea.velocity.copy().normalize(), -3));
    //unten
    if (flea.velocity.y<0) {
      flea.velocity.y *= -world.bounce;
      flea.position.y = box.position.y+box.h + flea.size;
    }
    //Oben 
    else if (flea.velocity.y>0) { 
      flea.position.y = box.position.y - flea.size;
      flea.velocity.y *= -world.bounce;
      flea.airborne=false;
    } 
    //*/
  }
  boolean intersects(Box box, Flea flea) {
    // get box closest point to sphere center by clamping
    float x = Math.max(box.position.x, Math.min(flea.position.x, box.position.x+box.w));
    float y = Math.max(box.position.y, Math.min(flea.position.y, box.position.y+box.h));

    PVector distance = PVector.sub(flea.position, new PVector (x, y));
    return (distance.magSq() < pow(flea.size, 2));
  }
}




class Flea {
  PVector position;
  PVector velocity;
  float size;
  World world;
  float speed=6;
  float jump = 10;
  boolean airborne = false;
  int left, right;

  Flea(PVector position, PVector velocity, float size, World world) {
    this.position = position;
    this.velocity = velocity;
    this.size = size;
    this.world = world;
    left = right = 0;
  }

  void draw() {
    noStroke();
    fill(#FFFFFF);
    ellipse(position.x, position.y, size, size);
  }

  void calc() {
    this.velocity.add(world.gravity);
    velocity = velocity.mult(world.friction);
    this.position.add(this.velocity);
    this.position.x += (left + right) * speed;
    if (flea.position.y > height)
      flea.position.y = 0;
    if (flea.position.x < 0)
      flea.position.x = width;
    if (flea.position.x > width)
      flea.position.x = 0;
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      flea.left=0;
    } else if (keyCode == RIGHT) {
      flea.right=0;
    }
  } else {
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      if (!flea.airborne) {
        flea.velocity.y+= -flea.jump;
        flea.airborne=true;
      }
    } else if (keyCode == LEFT) {
      flea.left=-1;
    } else if (keyCode == RIGHT) {
      flea.right=1;
    }
  } else {
  }
}