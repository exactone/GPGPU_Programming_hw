#include "counting.h"
#include <cstdio>
#include <cassert>
#include <thrust/scan.h>
#include <thrust/transform.h>
#include <thrust/functional.h>
#include <thrust/device_ptr.h>
#include <thrust/execution_policy.h>
#include <thrust/device_ptr.h>
#include <thrust/device_vector.h>


__device__ __host__ int CeilDiv(int a, int b) { return (a-1)/b + 1; }
__device__ __host__ int CeilAlign(int a, int b) { return CeilDiv(a, b) * b; }

__global__ void init(const char *Gtext, int *Gpos, int Gtext_size, int *lastpos) 
{
	int idx = blockIdx.x * blockDim.x + threadIdx.x;
	if(idx < Gtext_size){	
		//initialize	
		if(Gtext[idx]== '\n'){
			Gpos[idx] = 0;
			lastpos[idx] = 0;
		}
		else{
			Gpos[idx] = 1;
			lastpos[idx] = 1;
		}		
	}
}

__global__ void posParallel(int *Gpos, int Gtext_size, int *lastpos, int i, int j) 
{
	int idx = blockIdx.x * blockDim.x + threadIdx.x;
	if(idx < Gtext_size){	
		if(idx > 0 && (idx - j >= 0))
			if(lastpos[idx] != 0 && (lastpos[idx-1] == lastpos[idx]))
				Gpos[idx] += lastpos[idx-j] ;
	}
}

__global__ void copy(int *Gpos, int Gtext_size, int *lastpos, int j) 
{
	int idx = blockIdx.x * blockDim.x + threadIdx.x;
	if(idx < Gtext_size){	
		if(idx > 0 && (idx - j >= 0))
			lastpos[idx] = Gpos[idx];		
		
	}
}



struct nl_equal
{
    __host__ __device__
        int operator()(const char& c) {
            return c == '\n' ? 0 : 1;
        }
};

struct p_eq_l
{
    __host__ __device__
        int operator()(const int& p, const int& l){
            if(p == l && p != 0)
                return 1;
            else
                return 0;

        }
};

void CountPosition1(const char *text, int *pos, int text_size)
{
    thrust::device_ptr<const char> Gtext(text);
    thrust::device_ptr<int> Gpos(pos);
    thrust::device_ptr<int> lastpos = thrust::device_malloc<int>(text_size);
    thrust::device_ptr<int> add = thrust::device_malloc<int>(text_size);
    thrust::transform(Gtext, Gtext+text_size, Gpos, nl_equal());

    int i =0, j=0, k = 0;
	for(i=0;i<9;i++){
        thrust::copy(Gpos, Gpos+text_size-1, lastpos+1);
        lastpos[0] = 0;

        
		j = (1 << i);
        if(j < text_size){
            thrust::copy(Gpos, Gpos+text_size-j, add+j);

            for(k=0;k<j;k++)
                add[k] = 0;
        }
        
        thrust::transform(Gpos, Gpos+text_size, lastpos, lastpos, p_eq_l());
        thrust::transform(lastpos, lastpos+text_size, add, add, thrust::multiplies<int>());
        thrust::transform(Gpos, Gpos+text_size, add, Gpos, thrust::plus<int>());
	}	

}

void CountPosition2(const char *text, int *pos, int text_size)
{
	int blocksize = 1024;
    int i, j;
	int *lastpos;
	size_t poslen = text_size * sizeof(int);

	
	cudaMalloc((void **) &lastpos, poslen);
    dim3 DimGrid((text_size-1)/blocksize + 1, 1, 1);
    dim3 DimBlock(blocksize, 1, 1);

	init<<<DimGrid, DimBlock>>>(text, pos, text_size, lastpos);  // initialize
	cudaDeviceSynchronize();
	
	for(i=0;i<9;i++){
		j = (1 << i);
		posParallel<<<DimGrid, DimBlock>>>(pos, text_size, lastpos, i, j); 
		cudaDeviceSynchronize();	
		if(i != 8){
			copy<<<DimGrid, DimBlock>>>(pos, text_size, lastpos, j); 
			cudaDeviceSynchronize();		
		}
	}	
	cudaFree(lastpos);

}
