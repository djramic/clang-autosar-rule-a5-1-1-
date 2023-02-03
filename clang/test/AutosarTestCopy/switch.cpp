//RUN: %clang_cc1 -fsyntax-only %s -Wno-everything -Wautosar -verify

int main(){
    int day = 4;
    int a = 0;
    switch (3) {
    //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
    case 1:
    //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
        a = 1;
        break;
    case 2:
    //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
         a = 2;
        break;
    case 3:
    //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
         a = 3;
        break;
    case 4:
    //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
         a = 4;
        break;
  }
    return 0;
    //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
}