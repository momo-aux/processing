Flea flea;
World world;

PGraphics darkness;
PGraphics light;
float lightradius=100;
PGraphics map;
boolean showText = true;

void setup() {
  size(500, 500);
  world = new World(500, 500);
  darkness = createGraphics(500, 500);
  map = createGraphics(500, 500);
  light = createGraphics(500, 500);
  flea = new Flea(new PVector(500/2, 500-2), new PVector(), 2, world);
  world.boxes.add(new Box(0, height-10, 100, 10));
  world.boxes.add(new Box(200, height-10, 100, 10, color(#AAFFAA)));
  world.boxes.add(new Box(400, height-10, 100, 10));
  world.boxes.add(new Box(100, 400, 100, 10));
  world.boxes.add(new Box(400, 350, 80, 10));
  world.boxes.add(new Box(90, 220, 200, 10));
  world.boxes.add(new Box(400, 100, 90, 10, color(#FFAAAA)));
  world.boxes.add(new Box(10, 100, 200, 10));
}

void draw() {
  background(#000000);
  flea.calc();
  world.draw(map);
  flea.draw();
  if (showText) {
    textSize(14);
    text("You are a flea in the dark, find your way with the flashlight (mouse).\nFocus the beam with the mouse wheel.\nMove with A,W,D or arrow keys.\nHide/show this text with right click.", 10, 30);
  }
}

class Box {
  PVector position;
  float w;
  float h;
  color c;

  Box(int x, int y, int w, int h) {
    this(new PVector(x, y), w, h, color(#FFFFFF));
  }
  Box(int x, int y, int w, int h, color c) {
    this(new PVector(x, y), w, h, c);
  }

  Box(PVector position, int w, int h, color c) {
    this.position = position;
    this.w=w;
    this.h=h;
    this.c = c;
  }

  void draw(PGraphics map) {
    map.fill(c);
    map.rect(position.x, position.y, w, h);
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

  void draw(PGraphics map) {

    map.beginDraw();
    map.background(255-(lightradius/(200-60)*150));
    collision(flea, map);
    map.endDraw();

    darkness.beginDraw();
    darkness.background(#00FF00);
    darkness.endDraw();

    light.beginDraw();
    light.background(#FF0000);
    light.ellipse(mouseX, mouseY, lightradius, lightradius);
    light.endDraw();

    map.mask(light);
    image(map, 0, 0);
  }
  void collision(Flea flea, PGraphics map) {
    for (Box box : boxes) {
      box.draw(map);
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
    if (key == 'a') {
      flea.left=0;
    } else if (key == 'd') {
      flea.right=0;
    }
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
    if (key == 'w') {
      if (!flea.airborne) {
        flea.velocity.y+= -flea.jump;
        flea.airborne=true;
      }
    } else if (key == 'a') {
      flea.left=-1;
    } else if (key == 'd') {
      flea.right=1;
    }
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  lightradius += e*-10;
  if (lightradius > 200)
    lightradius=200;
  if (lightradius < 40)
    lightradius=40;
}

void mousePressed() {
  if (mouseButton == RIGHT) {
    showText = !showText;
  }
}