//RUN: %clang_cc1 -fsyntax-only %s -Wno-everything -Wautosar -verify
using namespace std;

long double operator"" _a(long double x){return x * 10;}
 //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
long double operator"" _b(long double x){return x * 1000;}
 //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
long double operator"" _c(long double x){return x;}

int main() {
    long double a = 3.4_a;
    
    long double b = 5.7_b;
     

    if(a == 6.5_a){}
    //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
    if(b != 12.5_b){}
    //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}

    for(int i = 100.0_a; i < 1.0_b; i+=100.0_a){}
    //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
}