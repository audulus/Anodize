//
//  MyCoolKernel.metal
//  AnodizeDemo
//
//  Created by Taylor Holliday on 2/21/25.
//

#include <metal_stdlib>
using namespace metal;

kernel void MyCoolKernel(device float* buffer,
                         constant float& value,
                         uint tid [[thread_position_in_grid]]) {
    buffer[tid] += value;
}
