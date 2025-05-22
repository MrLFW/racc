#include "stdio.h"

void mm(int m, int n, int* m1, int*  m2, int*  res){
 int  x, y, k;
 for(x = 0; x < m; x++){
    for(y = 0; y < n; y++){
      int sum = 0;
      for(k = 0; k < n; k++){
        sum += m1[k + x*n] * m2[k * m + y];
      }
      res[x * m + y ] = sum;
    }
  }
}


int main(){
  int m1[6] = { 1, 2, 3, 4, 5, 6};
  int m2[6] = { 0, 1, 1, 1, 2, 2};
  int res[4] = {};

  mm(2, 3, m1, m2, res);
 
  int i,j;
  for(i = 0; i < 2; i++) {
     for (j=0; j <2; j++) {
      printf("%d ", res[i*2+j]);
    }
    printf("\n");
  }

  return 0;
}
