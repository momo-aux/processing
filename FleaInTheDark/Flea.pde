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