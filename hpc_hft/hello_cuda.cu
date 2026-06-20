#include <cstdio>
#include <cuda_runtime.h>

__global__ void  helloCuda() {
    int threadId = threadIdx.x;
    int blockId = blockIdx.x;
    printf("Hello from the GPU! This is thread %d from the block %d\n", threadId, blockId);
}

int main(void) {
    printf("This is the CPU talking to you now! Handing over the load to the GPU...\n");
    helloCuda<<<1, 5>>>();
    cudaDeviceSynchronize();
    printf("The GPU workload is complete. Basically Shit is done.\n");
    printf("<CPU in control now>\n");
    return 0;
}