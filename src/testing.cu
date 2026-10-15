#include <cuda_runtime_api.h>
#include <cstdio>
#include <cmath>
#include <cuda_runtime.h>

__global__ void add(int n, float *x, float *y, float *sum) {
    int index = blockIdx.x * blockDim.x + threadIdx.x;
    int stride = blockDim.x * gridDim.x;
    for(int i = index; i < n; i += stride) {
        sum[i] = x[i] + y[i];
    }
}

int main(void) {
    int N = 1<<20;
    float *x, *y, *sum;
    cudaMallocManaged(&x, N*sizeof(float));
    cudaMallocManaged(&y, N*sizeof(float));
    cudaMallocManaged(&sum, N*sizeof(float));

    for(int i {}; i < N; i++) {
        x[i] = 1.0f;
        y[i] = 2.0f;
    }

    int blockSize = 256;
    int numBlocks = (N+blockSize-1)/blockSize;

    add<<<numBlocks, blockSize>>>(N, x, y, sum); // this is run on the CPU

    cudaDeviceSynchronize();

    float maxError = 0.0f;
    for(int i = 0; i < N; i++) {
        maxError = fmax(maxError, fabs(sum[i] - 3.0f));
    }
    printf("The maximum error is %f\n", maxError);

    cudaFree(x);
    cudaFree(y);
    cudaFree(sum);

    return 0;
}
