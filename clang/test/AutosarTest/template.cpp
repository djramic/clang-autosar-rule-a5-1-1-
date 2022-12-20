#include <iostream>

template<typename T>
T myMax(T x, T y){
  return (x > y) ? 3 : 6;
}

int main() {

  std::cout<< myMax<int>(4, 7) << "\n";
  std::cout<< myMax<char>('a','g')<<"\n";

}