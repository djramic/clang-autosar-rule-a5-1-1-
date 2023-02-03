//RUN: %clang_cc1 -fsyntax-only %s -Wno-everything -Wautosar -verify

int foo()
{
  auto b = [](int x) {
    return x;
  }(4);
    //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}

  auto add = [] (int a, int b) {
    return a + b;
  };

  add(4,5);
  //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
  //expected-warning@-2{{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}

  auto operation = []  (int a, int b,  char* op) -> double {
  if (op == "sum") {
  //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
    return a + b;
  } 
  else {
    return (a + b) / 2.0;   
    //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
  }
};

  operation(4,5,"sum");
  //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
  //expected-warning@-2 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
  //expected-warning@-3 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
  operation(5,6,"avg");
  //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
  //expected-warning@-2 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
  //expected-warning@-3 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}

}