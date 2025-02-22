# Anodize

Type safety for Metal. 🤘

Used in [Sculptura](https://sculptura.app/)

Suppose we've got the following MSL kernel:

```Metal
kernel void MyCoolKernel(device float* buffer,
                         constant float& value,
                         uint tid [[thread_position_in_grid]]) {
    buffer[tid] += value;
}
```

We run `swift run Anodize MyCoolKernel.metal` which generates the file `Anodized.swift` which contains wrappers for our kernel(s).

And then we can call it from Swift with type safety, and without worrying about binding indices. 😎

```Swift

let device = MTLCreateSystemDefaultDevice()!
let kernel = MyCoolKernel(device: device)

let array = try MutableGPUArray<Float>(data: [1,2,3])

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

print("array: \(array.array)") // prints [2.0, 3.0, 4.0]
        
```
