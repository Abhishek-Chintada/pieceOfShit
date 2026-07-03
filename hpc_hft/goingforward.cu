#include <cstdio>
#include <cuda_runtime.h>
#include <stdexcept>
#include <random>

constexpr size_t SIZE = 16;// Compile time constant should be defined like this.
constexpr size_t TILE_WIDTH = 2;

__global__ void kernel(double *ad, double *bd, double *pd) {
    auto row = blockIdx.y*TILE_WIDTH + threadIdx.y;
    auto column = blockIdx.x*TILE_WIDTH + threadIdx.x;
    double Pvalue {};
    for(size_t k {}; k < SIZE; k++) {
        auto a = ad[row*SIZE + k];
        auto b = bd[k*SIZE + column];
        Pvalue = a*b;
    }
    pd[row*SIZE + column] = Pvalue;
}

void matrix_math(double *a, double *b, double *p) {
    double *ad, *bd, *pd;
    size_t size_in_bytes = sizeof(double)*SIZE*SIZE;
    cudaMalloc((void**)ad, size_in_bytes);
    cudaMemcpy(ad, a, size_in_bytes, cudaMemcpyHostToDevice);
    cudaMalloc((void**)bd, size_in_bytes);
    cudaMemcpy(bd, b, size_in_bytes, cudaMemcpyHostToDevice);
    cudaMalloc((void**)pd, size_in_bytes);
    // matrix_math kernel.
    cudaMemcpy(p, pd, size_in_bytes, cudaMemcpyDeviceToHost);
}

void print_arr(double *arr) {
    for(size_t i{}; i < SIZE; i++) {
        for(size_t j{}; j < SIZE; j++) {
            printf("%lf ", arr[i*SIZE + j]);
        }

    }
}

int main(void) {
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_real_distribution<double> distrib(0.0, 10.0);
    double *a = (double *)malloc(SIZE*SIZE*sizeof(double));
    double *b = (double *)malloc(SIZE*)
    return 0;
}