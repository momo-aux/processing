class World {
  int width;
  int height;
  PVector gravity = new PVector(0, 0.3);
  float bounce = 0.4;
  float friction = 0.99;
  ArrayList<Box> boxes= new ArrayList<Box>();
  boolean buildMode = false;

  World(int width, int height) {
    this.width = width;
    this.height = height;
  }

  Box mouseColission() {
    Box hit = null;
    for (Box box : boxes) {
      box.highlite=false;
      box.resize=false;
      PVector ru = PVector.sub(new PVector(mouseX, mouseY), new PVector(box.position.x+box.w, box.position.y+box.h));
      if (ru.magSq()<25) {
        map.beginDraw();
        map.fill(#FF0000);
        map.ellipse(box.position.x+box.w, box.position.y+box.h, 5, 5);
        map.endDraw();
        box.resize=true;
        hit = box;
      } else if ((mouseX > box.position.x) && (mouseX < box.position.x+box.w) && (mouseY>box.position.y) && (mouseY<box.position.y+box.h)) {
        box.highlite=true;
        hit = box;
      }
    }
    return hit;
  }

  void draw(PGraphics map) {
    map.beginDraw();
    map.background(255-(lightradius/(200-60)*150));
    collision(flea, map);
    if (buildMode) {
      selectedBox=mouseColission();
    }
    map.endDraw();


    darkness.beginDraw();
    darkness.background(#00FF00);
    darkness.endDraw();

    light.beginDraw();
    light.background(#FF0000);
    light.ellipse(mouseX, mouseY, lightradius, lightradius);
    light.endDraw();

    if (!buildMode) {
      map.mask(light);
    }
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