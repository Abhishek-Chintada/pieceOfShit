#include <cstdio>
#include <cuda_runtime.h>
#include <chrono>
#include <random>

// matrix multiplication kernel here.
__global__ void MatrixMultiplicationKernel(int *arr1d, int *arr2d, int *prod, size_t size) {
    auto tx = threadIdx.x;
    auto ty = threadIdx.y;  // tx -> i and ty -> j
    int Pvalue = 0;

    for(int k{}; k < size; k++) {
        auto a = arr1d[tx*size + k];
        auto b = arr2d[k*size + ty];
        Pvalue += a*b;
    }
    prod[tx*size + ty] = Pvalue;
}


void print_arr(int* arr, size_t size) {
    printf("[");
    for(size_t i{}; i < size; i++) {
        for(size_t j{}; j < size; j++) {
            printf("%d ,", arr[i*size + j]);
        }
        if(i != size-1) {
            printf("\n");
        }
    }
    printf("]\n");
}

void MatrixMultiplication(int* arr1, int* arr2, int* pro, int size) {
    for(size_t i{}; i < size; i++) {
        for(size_t j{}; j < size; j++) {
            int sum = 0;
            for(size_t k{}; k < size; k++) {
                int a = arr1[i*size + k];
                int b = arr2[k*size + j];
                sum = sum+(a*b);
            }
            pro[i*size + j] = sum;
        }
    }
}

void MatrixMultiplication_Revised(int* arr1, int* arr2, int* pro, size_t size) {
    auto arr_bytes = size*size*sizeof(int);
    int *arr1d, *arr2d, *prod;
    cudaMalloc((void**)&arr1d, arr_bytes);
    cudaMemcpy(arr1d, arr1, arr_bytes, cudaMemcpyHostToDevice);
    cudaMalloc((void**)&arr2d, arr_bytes);
    cudaMemcpy(arr2d, arr2, arr_bytes, cudaMemcpyHostToDevice);
    cudaMalloc((void**)&prod, arr_bytes);

    // Calculations
    dim3 dimBlock(size, size);
    dim3 dimGrid(1, 1);
    MatrixMultiplicationKernel<<<dimGrid, dimBlock>>>(arr1d, arr2d, prod, size);

    cudaMemcpy(pro, prod, arr_bytes, cudaMemcpyDeviceToHost);
    cudaFree(arr1d); cudaFree(arr2d); cudaFree(prod);
}


int main(void) {
    std::random_device rd; // Obtain a seed from hardware.
    std::mt19937 gen(rd());
    size_t size = 3; // size of the matrix
    std::uniform_int_distribution<int>random(1, 10);
    int* arr1 = (int *)malloc(size*size*sizeof(int)); // dynamically allocating an array.
    int* arr2 = (int *)malloc(size*size*sizeof(int));
    int* product = (int *)malloc(size*size*sizeof(int));
    for(size_t i{}; i < size; i++) {
        for(size_t j{}; j < size; j++) {
            arr1[i*size + j] = random(gen);
            arr2[i*size + j] = random(gen);
        }
    }
    print_arr(arr1, size);
    print_arr(arr2, size);
    // Carry out the multiplication.

    auto start_time = std::chrono::high_resolution_clock::now();
    MatrixMultiplication(arr1, arr2, product, size);
    print_arr(product, size); // Printing the product here.
    auto end_time = std::chrono::high_resolution_clock::now();
    std::chrono:duration<double, std::milli> time = start - end;
    printf("This the time taken for normal execution : %lf\n", time);

    // Enter the device T4.
    MatrixMultiplication_Revised(arr1, arr2, product, size);

    free(arr1);
    free(arr2);
    return 0;
}