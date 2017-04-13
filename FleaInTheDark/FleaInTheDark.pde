Flea flea;
World world;
File file = new File();

PGraphics darkness;
PGraphics light;
float lightradius=100;
PGraphics map;
boolean showText = true;
Box selectedBox;

void setup() {
  size(500, 500);
  world = new World(500, 500);
  //world.buildMode=true;
  darkness = createGraphics(500, 500);
  map = createGraphics(500, 500);
  light = createGraphics(500, 500);
  flea = new Flea(new PVector(500/2, 500-2), new PVector(), 2, world);
  //
  world.boxes = file.JSONArrayToBoxes(loadJSONArray("Level1.json"));
  /*/
   world.boxes.add(new Box(0, height-10, 100, 10));
   world.boxes.add(new Box(200, height-10, 100, 10, color(#AAFFAA)));
   world.boxes.add(new Box(400, height-10, 100, 10));
   world.boxes.add(new Box(100, 400, 100, 10));
   world.boxes.add(new Box(400, 350, 80, 10));
   world.boxes.add(new Box(90, 220, 200, 10));
   world.boxes.add(new Box(400, 100, 90, 10, color(#FFAAAA)));
   world.boxes.add(new Box(10, 100, 200, 10));
   saveJSONArray(boxesToJSONArray(world.boxes),"data.json");
   //*/
}


void draw() {
  background(#000000);
  flea.calc();
  world.draw(map);
  flea.draw();
  if (showText) {
    textSize(14);
    String txt = "";
    if (world.buildMode) {
      txt="You are in build mode (change with *).\nAdd a box 'a',del boxes 'd', save world 's', drag boxes,\nresize boxes by snapping lower right.";
    } else {
      txt = "You are a flea in the dark, find your way with the flashlight (mouse).\nFocus the beam with the mouse wheel.\nMove with A,W,D or arrow keys.\nHide/show this text with right click.";
    }
    text(txt, 10, 30);
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
      if (!world.buildMode) {
        if (!flea.airborne) {
          flea.velocity.y+= -flea.jump;
          flea.airborne=true;
        }
      }
    } else if (key == 'a') {
      if (world.buildMode)
        world.boxes.add(new Box(mouseX, mouseY, 100, 10, color(#FFFFFF), world.boxes.size()));
      else  
      flea.left=-1;
    } else if (key == 'd') {
      if (world.buildMode) {
        if (selectedBox != null) {
          for (int i = 0; i < world.boxes.size(); i++) {
            if (world.boxes.get(i).index==selectedBox.index) {
              world.boxes.remove(i);
              selectedBox=null;
              return;
            }
          }
        }
      } else {
        flea.right=1;
      }
    } else if (key == 's') {
      file.save(world.boxes);
    } else if (key == '*') {
      world.buildMode=!world.buildMode;
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

void manipulateBox(Box selectedBox) {
  if (selectedBox == null)
    return;

  if (selectedBox.highlite) {
    selectedBox.position.add(new PVector(mouseX-pmouseX, mouseY-pmouseY));
    /*/
     if (selectedBox.position.x > width-selectedBox.w);
     selectedBox.position.x = width-selectedBox.w;
     if (selectedBox.position.y > height-selectedBox.h);
     selectedBox.position.y = height-selectedBox.h;
     //*/
  }
  if (selectedBox.resize) {
    selectedBox.w += mouseX-pmouseX;
    if (selectedBox.w <= 10) selectedBox.w = 10;
    selectedBox.h += mouseY-pmouseY;
    if (selectedBox.h <= 10) selectedBox.h = 10;
  }
}
void mousePressed() {
  if ((mouseButton == LEFT) && (world.buildMode)) {
    manipulateBox(selectedBox);
  }
  if (mouseButton == RIGHT) {
    showText = !showText;
  }
}
void mouseReleased() {
  if ((mouseButton == LEFT) && (world.buildMode)) {
    manipulateBox(selectedBox);
  }
  if (mouseButton == RIGHT) {
    showText = !showText;
  }
}

void mouseDragged() {
  if ((mouseButton == LEFT) && (world.buildMode)) {
    manipulateBox(selectedBox);
  }
}