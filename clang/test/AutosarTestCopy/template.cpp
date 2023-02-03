//RUN: %clang_cc1 -fsyntax-only %s -Wno-everything -Wautosar -verify
template<typename T>
T myMax(T x, T y){
  return (x > y) ? 3 : 6;
  //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
  //expected-warning@-2 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
}

int main() {

  myMax<int>(4, 7);
  //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
  //expected-warning@-2 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
  myMax<char>('a','g');
  //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
  //expected-warning@-2 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
  
  return 0;
  //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
}