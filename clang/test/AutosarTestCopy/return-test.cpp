//RUN: %clang_cc1 -fsyntax-only %s -Wno-everything -Wautosar -verify
// expected-no-diagnostics
#define EXIT_SUCCESS 0

int main(void) { return EXIT_SUCCESS; }