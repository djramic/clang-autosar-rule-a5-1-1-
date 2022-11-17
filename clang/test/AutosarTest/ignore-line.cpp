//RUN: %clang_cc1 -fsyntax-only %s -Wno-everything -Wautosar -verify
void foo(){

if(true){}
//expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}

//IGNORE:autosar[A5-1-1]
if(true){}

//IgNoRe:autoSar[a5-1-1]
if(true){}

//   ignore  : autosar [a5-1-1]
if(true){}
}