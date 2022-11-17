//RUN: %clang_cc1 -fsyntax-only %s -Wno-everything -Wautosar -verify
void foo(){
  int a[4] = {1,2,3,4};
  a[3] = 2;
  //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}


  int b = a[1];
  //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}

  int a4 = 4;
  b = a[a4];

  int pp = 2;
  int qq = pp;

  int c[5][2] = {1,2,3,4,5,6,7,8,9,10};
  int d = c[2][1]; 
  //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
  //expected-warning@-2 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}

  for(int i = 0; i < 5; i++){
  //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
    for(int j = 0 ; j < 2; j++){
    //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
      if(c[i][j] == c[1][1]){
      //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
      //expected-warning@-2 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
      }
    }
  }
}