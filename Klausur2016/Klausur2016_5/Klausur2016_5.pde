int[] a = {1, 2, 3, 4};
int[] b = {10, 20, 30, 40};
int[] c;
void setup() {
  c = new int[a.length * 2];
  int j = 0;
  for (int i = 0; i < a.length; i++) {
    c[j++]=a[i];
    c[j++]=b[i];
  }

  printArray(c);
}