//RUN: %clang_cc1 -fsyntax-only %s -Wno-everything -Wautosar -verify
struct S
{
    char name[50];
    int roll;
    float marks;

} s[10];

void foo(){

    s[3].roll = 10;
    //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}

}
