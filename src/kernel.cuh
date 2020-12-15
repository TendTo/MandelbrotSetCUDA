#ifndef __KERNEL_CUDA
#define __KERNEL_CUDA

#include <stdio.h>

#include <cuda_runtime.h>
#include <device_launch_parameters.h>

////////////////////////////////////////////////////////////
///
/// Starts the CUDA kernel with the given inputs
///
/// \param nrows       Number of rows (height)
/// \param ncols       Number of columns (width)
/// \param max_iter    Max number of iterations per pixel
/// \param startX      Horizontal offset
/// \param startY      Vertical offset
/// \param zoom        Zoom coefficient
/// 
/// \return Array of size (nrows * ncols) containing the number of iteration per point if it is less than max_iter, 0 otherwise
///
////////////////////////////////////////////////////////////
int* mendelbrot_kernel(int nrows, int ncols, int max_iter, double startX, double startY, double zoom);

#endif // __KERNEL_PRO_