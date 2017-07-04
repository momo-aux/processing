float ballX;
float ballY;
float speedX;
float speedY;

void setup() {
  splitBoxSpalte(10, 5, 6);
}

void splitBoxSpalte(int breite, int hoehe, int spalte) {
  char zeichen = '#';
  for (int i = 0; i < hoehe; i++) {
    for (int j = 0; j < breite; j++) {
      if (j >= spalte) {
        zeichen = '.';
      } else {
        zeichen = '#';
      }
      print(zeichen);
    }
    print("\n");
  }
}