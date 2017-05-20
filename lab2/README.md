# usage
nvcc --std=c++11 -arch sm_30 -D_MWAITXINTRIN_H_INCLUDED -D__STRICT_ANSI__  main.cu counting.cu
./a.out
