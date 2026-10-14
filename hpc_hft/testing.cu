#include <cuda_runtime_api.h>
#include <iostream>
#include <cmath>
#include <cuda_runtime.h>

__global__ void add(int n, float *x, float *y) {
    for(int i = 0; i < n; i++) {
        y[i] = x[i] + y[i];
    }
}

int main(void) {
    int N = 1<<20;
    float *x, *y, *sum;
    cudaMallocManaged(&x, N*sizeof(float));
    cudaMallocManaged(&y, N*sizeof(float));

    for(int i {}; i < N; i++) {
        x[i] = 1.0f;
        y[i] = 2.0f;
    }

    add<<<1, 1>>>(N, x, y); // this is run on the CPU

    cudaDeviceSynchronize();

    float maxError = 0.0f;
    for(int i = 0; i < N; i++) {
        maxError = fmax(maxError, fabs(y[i] - 3.0f));
    }
    std::cout << "The maximum error is " << maxError << std::endl;

    cudaFree(x);
    cudaFree(y);

    return 0;
}
