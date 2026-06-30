#include <cstdio>
#include <cuda_runtime.h>
#include <stdexcept>

__global__ void  matrixMultiplication_Kernel(double *ad, double *bd, double *pd, size_t size) {
    auto tx = threadIdx.x;
    auto ty = threadIdx.y;
    auto bx = blockIdx.x;
    auto by = blockIdx.y;
    double sum {};
    for(size_t i{}; i < size; i++) {
        double x = ad[tx*size + i];
        double y = bd[i*size + ty];
        sum += x*y;
    }
    pd[tx*size + ty] = sum;
}

void matrixMath(double *a, double *b, double *p, size_t size) {
    double *ad, *bd, *pd;
    auto size_arr = sizeof(double)*size*size;
    cudaMalloc((void**)ad, size_arr);
    cudaMemcpy(ad, a, size_arr, cudaMemcpyHostToDevice);
    cudaMalloc((void**)bd, size_arr);
    cudaMemcpy(bd, b, size_arr, cudaMemcpyHostToDevice);
    cudaMalloc((void**)pd, size_arr);
    matrixMultiplication_Kernel(ad, bd, pd, size);
    cudaMemcpy(p, pd, size_arr, cudaMemcpyDeviceToHost);
}

int main(void) {

    return 0;
}