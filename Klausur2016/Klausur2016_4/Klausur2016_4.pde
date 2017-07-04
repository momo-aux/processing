Floater[] floaters;
int anzahl;

void setup() {
  anzahl = 4;
  floaters = new Floater[anzahl];
  for (int i = 0; i < anzahl; i++) {
    floaters[i]= new Floater((i < anzahl/2));
  }
}

void draw() {
  background(0);
  for (Floater fl : floaters) {
    fl.update();
    fl.render();
  }
}

class Floater {
  float x;
  float y;
  float s;
  boolean horizontal;

  Floater(boolean horizontal) {
    this.horizontal = horizontal;
    this.x = random(0, 80);
    this.y = random(0, 80);
    this.s = random(-3, 3);
  }

  void render() {
    rect(x, y, 20, 20);
  }
  void update() {
    if (horizontal) {
      if ((x < 0) || (x>80)) {
        s*=-1;
      }
      x = x + s;
    } else {
      if ((y < 0) || (y>80)) {
        s*=-1;
      }
      y = y + s;
    }
  }
}

void mouseClicked() {
  for (Floater fl : floaters)
    fl.horizontal=!fl.horizontal;
}