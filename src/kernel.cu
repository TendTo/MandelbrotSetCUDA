#include "kernel.cuh"

void error(char const* str)
{
	fprintf(stderr, "%s\n", str);
	exit(1);
}

void cuda_check(cudaError_t err, char const* str)
{
	if (err != cudaSuccess) {
		fprintf(stderr, "%s: CUDA error %d (%s)\n",
			str, err, cudaGetErrorString(err));
	}
}

__global__ void fractal(int nrows, int ncols, int max_iter, double startX, double startY, double zoom, int* result) //373 - 326
{
	const int x_idx = threadIdx.x + blockIdx.x * blockDim.x;
	const int y_idx = threadIdx.y + blockIdx.y * blockDim.y;
	if (x_idx >= ncols || y_idx >= nrows)
		return;

	int l = x_idx + y_idx * ncols;
	double x = ((x_idx - ncols / 2) * zoom + startX) / ncols * 3.5 - 0.75;
	double y = ((y_idx - nrows / 2) * zoom + startY) / nrows * 2.0;
	double re = x, im = y;
	for (int i = 1; i < max_iter; ++i)
	{
		if (re * re + im * im >= 4)
		{
			result[l] = i;
			return;
		}
		double reTemp = re * re - im * im + x;
		im = 2 * re * im + y;
		re = reTemp;
	}
	result[l] = 0;
}

#if __DEBUG
__global__ void fractal_old(int nrows, int ncols, int* result) //398.86642 - 343.53
{
	int x_idx = threadIdx.x + blockIdx.x * blockDim.x;
	int y_idx = threadIdx.y + blockIdx.y * blockDim.y;
	if (x_idx >= nrows || y_idx >= ncols)
		return;

	int l = x_idx * ncols + y_idx;
	double x = (double)x_idx / nrows * 3.5 - 2.5;
	double y = (double)y_idx / ncols * 2.0 - 1.0;
	double re = x, im = y;
	for (int i = 1; i < MAX_ITERATIONS; ++i)
	{
		if (re * re + im * im >= 4)
		{
			result[l] = i;
			return;
		}
		double reTemp = re * re - im * im + x;
		im = 2 * re * im + y;
		re = reTemp;
	}
	result[l] = 0;
}
#endif

int* mendelbrot_kernel(int nrows, int ncols, int max_iter, double startX, double startY, double zoom)
{
	cudaError_t err;
	cudaEvent_t start, end;
	int* d_result, * h_result;
	size_t res_size = nrows * ncols * sizeof(int);
	float time;

	err = cudaMalloc(&d_result, res_size);
	cuda_check(err, "cudaMalloc");
	err = cudaMallocHost(&h_result, res_size);
	cuda_check(err, "cudaMallocHost");

	cudaEventCreate(&start);
	cudaEventCreate(&end);

	dim3 dimBlock(32, 32);
	dim3 dimGrid((ncols + 31) / 32, (nrows + 31) / 32);

	cudaEventRecord(start);
	fractal << <dimGrid, dimBlock >> > (nrows, ncols, max_iter, startX, startY, zoom, d_result);
	cudaEventRecord(end);


	err = cudaMemcpy(h_result, d_result, res_size, cudaMemcpyDeviceToHost);
	cuda_check(err, "cudaMalloc");

	err = cudaEventSynchronize(end);
	cuda_check(err, "sync");

	cudaEventElapsedTime(&time, start, end);
	//printf("Tempo passato = %f\n", time);

	err = cudaFree(d_result);
	cuda_check(err, "cudaFree");

	return h_result;
}

#if __DEBUG
int main()
{
	int* result = kernel_start(12000, 8000);
	//int* result = kernel_start();

	// for (int j = NCOLS - 1; j >= 0; --j)
	// {
	// 	for (int i = 0; i < NROWS; i++)
	// 	{
	// 		printf("%d ", result[i * NCOLS + j]);
	// 	}
	// 	printf("\n");
	// }

	// for (int j = 0; j < NROWS; ++j)
	// {
	// 	for (int i = 0; i < NCOLS; ++i)
	// 	{
	// 		printf("%d ", result[j * NCOLS + i]);
	// 	}
	// 	printf("\n");
	// }
	return 0;
}
#endif