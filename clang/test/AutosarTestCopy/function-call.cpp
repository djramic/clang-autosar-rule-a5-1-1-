//RUN: %clang_cc1 -fsyntax-only %s -Wno-everything -Wautosar -verify

template<class T>
constexpr T clone(const T& t)
{
    return t;
}

void g(int*){}

void f(int a, float b, double c, char* d, int* e){}

void f1(int a){}

void foo(){
  int a = 10;
  float b = 55.5;
  double c = 77;
  char* d = "test";
  int * pointer = nullptr;

  f(5,b,c,d,pointer);
  //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
  f(a,42.5f,c,d,pointer);
  //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
  f(a,b,98.5L,d,pointer);
  //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
  f(a,b,c,"test-text",pointer);
  //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
  f(a,b,c,d,nullptr);
  //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
  f(a,b,c,d,pointer);

  f(4,48.5f,99.9l,"text",nullptr);
  //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
  //expected-warning@-2 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
  //expected-warning@-3 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
  //expected-warning@-4 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
  //expected-warning@-5 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}

  f1((int) a); 

  f1((int) 55);
  //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}

  f1(a = 4);

  g(nullptr);   
  //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}  

  g(0);   
  //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}           
 
  g(clone(nullptr));
  //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}

  g(pointer);  

  g((int*) pointer); 

  g((int *) nullptr);
  //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
}