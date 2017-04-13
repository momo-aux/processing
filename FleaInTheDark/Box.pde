class Box {
  PVector position;
  float w;
  float h;
  color c;
  boolean highlite;
  boolean resize;
  int index;

  Box(int x, int y, float w, float h, int index) {
    this(new PVector(x, y), w, h, color(#FFFFFF),index);
  }
  Box(int x, int y, float w, float h, color c,int index) {
    this(new PVector(x, y), w, h, c,index);
  }

  Box(PVector position, float w, float h, color c, int index) {
    this.highlite=false;
    this.resize=false;
    this.position = position;
    this.w=w;
    this.h=h;
    this.c = c;
    this.index = index;
  }

  void draw(PGraphics map) {
    if (this.highlite)
      map.fill(color(#FF8000));
    else
      map.fill(c);
    map.rect(position.x, position.y, w, h);
  }
}