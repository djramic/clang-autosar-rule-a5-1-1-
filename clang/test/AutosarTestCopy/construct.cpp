//RUN: %clang_cc1 -fsyntax-only %s -Wno-everything -Wautosar -verify
struct S 
{
  int n = 1;
  S() : n(7) {}
};

class A
{
private:
  int m_a {};
  float m_b {};
public:
  A() : m_a { 1 }, m_b { 2.5f } {}
  A(int a, float b) : m_a { a }, m_b { b } {}
};

int f(){
  A a{};

  A b{2, 3.5f};
  return 0;
  //expected-warning@-1 {{Autosar[A5-1-1]: Use symbolic names instead of literal values in code.}}
}