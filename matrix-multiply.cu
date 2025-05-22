#include <stdio.h>
#include <cuda_runtime.h>
//multiplication of a MxN matrix by a NxP matrix
#define N 3
#define M 2
#define P 2
#define BLOCK_SIZE 16

__global__ void matrixMultiply(int *a, int *b, int *c) {
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;
    

    if (row < M && col < P) {
        int sum = 0;
        for (int k = 0; k < N; k++) {
            sum += a[row * N + k] * b[k * P + col];
        }
        c[row * P + col] = sum;
    }
}

int main() {
    int a[M][N] = {{1, 2, 3}, {4, 5, 6}};
    int b[N][P] = {{1, 0 }, { 1, 0}, {1, 1}};
    int c[M][P] = {0};

    int *dev_a, *dev_b, *dev_c;
    cudaMalloc((void **)&dev_a, M * N * sizeof(int));
    cudaMalloc((void **)&dev_b, N * P * sizeof(int));
    cudaMalloc((void **)&dev_c, M * P * sizeof(int));

    cudaMemcpy(dev_a, a, M * N * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(dev_b, b, N * P * sizeof(int), cudaMemcpyHostToDevice);

    dim3 threadsPerBlock(BLOCK_SIZE, BLOCK_SIZE);
    dim3 numBlocks( (P + threadsPerBlock.x - 1)/threadsPerBlock.x, (M + threadsPerBlock.y - 1)/threadsPerBlock.y );

    matrixMultiply<<<numBlocks, threadsPerBlock>>>(dev_a, dev_b, dev_c);


    cudaError_t err = cudaGetLastError();
    if (err != cudaSuccess) {
       printf ("Kernel launch error: %s\n", cudaGetErrorString(err));
       return 1;
    }


 
    cudaMemcpy(c, dev_c, M * P * sizeof(int), cudaMemcpyDeviceToHost);

    
    printf("Result:\n");
    for (int i = 0; i < M; i++) {
        for (int j = 0; j < P; j++) {
            printf("%d ", c[i][j]);
        }
        printf("\n");
    }

    cudaFree(dev_a);
    cudaFree(dev_b);
    cudaFree(dev_c);

    return 0;
}


