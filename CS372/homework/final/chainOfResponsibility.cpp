//Thatcher Lane
//CS 372 Take Home Final
//Chain of Responsibility Example
//Adapted from example found at https://sourcemaking.com/design_patterns/chain_of_responsibility/cpp/1

#include <iostream>
#include <vector>
#include <ctime>

class Base {
private:
  Base *next;
public:
  Base() {
    next = 0;
  }
  void setNext(Base *n) {
    next = n;
  }
  void add(Base *n) {
    if(next){
      next->add(n);
    }
    else {
      next = n;
    }
  }
  virtual void handle(int i) {
    next->handle(i);
  }
};

class Handler1: public Base {
public:
  void handle(int i) {
    if(rand() % 4) {
      std::cout << "handler1 passed " << i << " ";
      Base::handle(i);
    }
    else {
      std::cout << "handler1 handled " << i << " ";
    }
  }
};

class Handler2: public Base {
public:
  void handle(int i) {
    if(rand() % 3) {
      std::cout << "handler2 passed " << i << " ";
      Base::handle(i);
    }
    else {
      std::cout << "handler2 handled " << i << " ";
    }
  }
};

class Handler3: public Base {
public:
  void handle(int i) {
    if(rand() % 2) {
      std::cout << "handler3 passed " << i << " ";
      Base::handle(i);
    }
    else {
      std::cout << "handler3 handled " << i << " ";
    }
  }
};

int main() {
  srand(std::time(0));

  Handler1 one;
  Handler2 two;
  Handler3 three;

  one.add(&two);
  one.add(&three);
  three.setNext(&one);
  
  for (int i = 1; i < 5; i++){
    one.handle(i);
    std::cout << "\n";
  }
}
