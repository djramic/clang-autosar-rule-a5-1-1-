//RUN: %clang_cc1 -fsyntax-only %s -Wno-everything -Wautosar -verify

void foo(){
  int a = 10;
  float b = 10.0f;
  int * ptr = nullptr;
  char* str = "test";

  for(int i = 0 ; i < 10; i++) {}
  //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}

  for(int i = 0; i < a ; i+=5) {}

  if(5.0f < b) {}
  //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}

  if(true) {}
  //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}

  if(ptr == nullptr) {}
  //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}

  if(10 - 10) {}
  //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
  //expected-warning@-2 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}

  while(a < 10){
    //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
    a += 1;
  }
}