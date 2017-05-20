# usage
cd lab3  
cp -f ../utils/* .  
nvcc -std=c++11 -D_MWAITXINTRIN_H_INCLUDED -D__STRICT_ANSI__ main.cu lab3.cu pgm.cpp  
./a.out img_background.ppm img_target.ppm img_mask.pgm 130 600 output.ppm
