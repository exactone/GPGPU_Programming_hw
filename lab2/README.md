# usage
cd lab2  
cp -f ../utils/* .  
nvcc -std=c++11 -D_MWAITXINTRIN_H_INCLUDED -D__STRICT_ANSI__ main.cu counting.cu  
./a.out
