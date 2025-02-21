# Anodize

Type safety for Metal.

Suppose I've got the following MSL kernel:

```Metal
kernel void MyCoolKernel(device float* buffer,
                         constant float& value,
                         uint tid [[thread_position_in_grid]]) {
    buffer[tid] += value;
}
```

I do `swift run Anodize MyCoolKernel.metal` and get `Anodized.swift`

Then I can do the following:

```Swift

let device = MTLCreateSystemDefaultDevice()!
let kernel = MyCoolKernel(device: device)

let array = try! MutableGPUArray<Float>(data: [1,2,3])

let queue = device.makeCommandQueue()!
let buf = queue.makeCommandBuffer()!

try kernel
    .begin(buf)
    .buffer(array)
    .value(bytes: 1)
    .dispatch(threads: 3, threadsPerThreadgroup: 1)
    .end()

buf.commit()
buf.waitUntilCompleted()
        
```
