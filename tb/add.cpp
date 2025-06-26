#include<iostream>
#include<svdpi.h>

using namespace std;

extern "C" svBitVecVal add(svBitVecVal* a, svBitVecVal* b);

svBitVecVal add(svBitVecVal* a, svBitVecVal* b){
  cout << "a from ref model: " << *a << endl;
  cout << "b from ref model: " << *b << endl;
  return (*a + *b);
}