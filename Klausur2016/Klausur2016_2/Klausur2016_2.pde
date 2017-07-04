float ballX;
float ballY;
float speedX;
float speedY;

void setup() {
  ballX = 50;
  ballY = 50;
  speedX = random(-3, 3);
  speedY = random(-3, 3);
}

void draw() {
  background(0);
  noFill();
  stroke(255);
  rect(20, 10, 60, 80);
  fill(255);
  ballX = ballX + speedX;
  ballY = ballY + speedY;
  ellipse(ballX, ballY, 20, 20);
  if ((ballX < 30) || (ballX > 70)) {
    speedX *= -1;
  }
  if ((ballY < 20) || (ballY > 80)) {
    speedY *= -1;
  }
}