template<typename T>
T myMax(T x, T y){
  return (x > y) ? 3 : 6;
}

int main() {

  myMax<int>(4, 7);
  myMax<char>('a','g');
  
}