//RUN: %clang_cc1 -fsyntax-only %s -Wno-everything -Wautosar -verify
void foo(){
    int i = 10;
    bool a = (i < 15) ? true : false;
    //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
    //expected-warning@-2 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
    //expected-warning@-3 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
    
    int b = 5;
    int c = 10;

    int max = (b > c) ? b : c;

}
