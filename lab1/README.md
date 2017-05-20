# useage
cd lab1  
cp -f ../utils/* .  
nvcc -std=c++11 main.cu lab1.cu PerlinNoise.cpp -o a.out  
./a.out  
avconv -i result.y4m result.mkv  

