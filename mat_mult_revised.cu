#include <cstdio>
#include <iostream>
#include <cuda_runtime.h>
#include <chrono>
#include <random>

void print_arr(float *arr, size_t size) {
    for(size_t i = 0; i < size; i++) {
        for(size_t j = 0; j < size; j++) {
            
        }
    }
}

int main(void) {
    size_t size = 0;
    std::cout << "Enter the size of the square matrix (either the row or the column...)" << std::endl;
    std::cin >> size;
    std::cout << "Confirmation of the size : " << size << std::endl;

    // creating the random device here. (from the random library.)
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_real_distribution<float>random(1, 50);

    // defining the arrays by dynamic allocation to global memory.
    float *arr1 = (float *)malloc(size*size*sizeof(float));
    float *arr2 = (float *)malloc(size*size*sizeof(float));
    float *product = (float *)malloc(size*size*sizeof(float));


    // writing random values to the arrays
    for(size_t i = 0; i < size; i++) {
        arr1[i] = random(gen);
        arr2[i] = random(gen);
        product[i] = 0;
    }
    return 0;
}