void setup() {
  int[] a = {1, -5, 10, -3};
  int[] b = {-5, -3, -5};
  println(betragSumme(a));
  println(betragSumme(b));
  println();
  println(randomN(2));
  println();
  println(randomN(3));
}

int betragSumme(int[] arr) {
  int ret = 0;
  for (int i = 0;i<arr.length;i++) {
      ret = ret + abs(arr[i]);
  }
  return ret;
}
float[] randomN(int size) {
  float[] ret = new float[size];
  for (int i = 0; i < size; i++) {
    ret[i] = random(0,10);
  }
  return ret;
}