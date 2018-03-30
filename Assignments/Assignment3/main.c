#include <stdio.h>



int nextsquare(int a, int b);

int main () {

  int n, n2;

  printf("Please enter a number greater than 0: ");
  scanf ("%d", &n);
  
  n2 = n * n;
  
  for(int i = 1; i <=5; i++) {
    n2 = nextsquare(n, n2);
    n++;
    printf("%d^2 = %d", n, n2);
  }

  return 0;
}
