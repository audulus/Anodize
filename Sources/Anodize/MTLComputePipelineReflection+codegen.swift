//
//  MTLComputePipelineReflection+codegen.swift
//  Anodize
//
//  Created by Taylor Holliday on 2/21/25.
//

import Metal

extension MTLComputePipelineReflection {

    func kernelWrapper(name: String, functionName: String, asBytes: [String]) -> String {

        let asBytesSet = Set(asBytes)

        var result = "class " + name + " {\n"

        result += "    private var pipeline: MTLComputePipelineState\n"
        result += "    init(device: MTLDevice) { self.pipeline = device.makeComputePipeline(name: \"\(functionName)\") }\n"
        result += "    func begin(_ buf: MTLCommandBuffer) throws -> BindingWrapper {\n"
        result += "        guard let enc = buf.makeComputeCommandEncoder() else { throw SculpturaError.metalError(\"couldn't create MTLComputeCommandEncoder\") }\n"
        result += "        enc.label = \"\(functionName)\"\n"
        result += "        enc.setComputePipelineState(pipeline)\n"
        result += "        return .init(enc: enc)\n"
        result += "    }\n"
        result += "    struct BindingWrapper {\n"
        result += "        let enc: MTLComputeCommandEncoder\n"

        for binding in bindings {

            switch binding.type {
            case .buffer:
                result += "        func bind_\(binding.name)(_ buffer: MTLBuffer) -> Self {\n"
                result += "            enc.setBuffer(buffer, index: \(binding.index))\n"
                result += "            return self\n"
                result += "        }\n"

                let bufferBinding = binding as! MTLBufferBinding

                if asBytesSet.contains(binding.name) {

                    if let swiftName = bufferBinding.bufferDataType.swiftName {
                        result += "        func \(binding.name)(_ value: \(swiftName)) -> Self {\n"
                        result += "            enc.setBytes(value, index: \(binding.index))\n"
                        result += "            return self\n"
                        result += "        }\n"
                    } else {
                        result += "        func \(binding.name)<T>(_ value: T) -> Self {\n"
                        result += "            enc.setBytes(value, index: \(binding.index))\n"
                        result += "            return self\n"
                        result += "        }\n"
                    }

                } else if let swiftName = bufferBinding.bufferDataType.swiftName {

                    switch binding.access {
                    case .readOnly:
                        result += "        func \(binding.name)(_ array: any GPUBufferProvider<\(swiftName)>) -> Self {\n"
                        result += "            enc.setBuffer(array, index: \(binding.index))\n"
                        result += "            return self\n"
                        result += "        }\n"
                    case .readWrite, .writeOnly:
                        result += "        func \(binding.name)(_ array: any MutableGPUBufferProvider<\(swiftName)>) -> Self {\n"
                        result += "            enc.setBuffer(array, index: \(binding.index))\n"
                        result += "            return self\n"
                        result += "        }\n"
                    default:
                        fatalError()
                    }

                } else {

                    switch binding.access {
                    case .readOnly:
                        result += "        func \(binding.name)<T>(_ array: any GPUBufferProvider<T>) -> Self {\n"
                        result += "            assert(MemoryLayout<T>.size == \(bufferBinding.bufferDataSize))\n"
                        result += "            enc.setBuffer(array, index: \(binding.index))\n"
                        result += "            return self\n"
                        result += "        }\n"
                    case .readWrite, .writeOnly:
                        result += "        func \(binding.name)<T>(_ array: any MutableGPUBufferProvider<T>) -> Self {\n"
                        result += "            assert(MemoryLayout<T>.size == \(bufferBinding.bufferDataSize))\n"
                        result += "            enc.setBuffer(array, index: \(binding.index))\n"
                        result += "            return self\n"
                        result += "        }\n"
                    default:
                        fatalError()
                    }
                }

            case .texture:
                result += "        func \(binding.name)(_ texture: MTLTexture) -> Self {\n"
                result += "            enc.setTexture(texture, index: \(binding.index))\n"
                result += "            return self\n"
                result += "        }\n"
                
            default:
                print("unknown binding type for function \(functionName)")
            }
        }

        result += "        func wait(_ fence: MTLFence) -> Self {\n"
        result += "            enc.waitForFence(fence)\n"
        result += "            return self\n"
        result += "        }\n"

        result += "        func update(_ fence: MTLFence) -> Self {\n"
        result += "            enc.updateFence(fence)\n"
        result += "            return self\n"
        result += "        }\n"

        result += "        func dispatch(threadgroups: MTLSize, threadsPerThreadgroup: MTLSize) -> Self {\n"
        result += "            enc.dispatchThreadgroups(threadgroups, threadsPerThreadgroup: threadsPerThreadgroup)\n"
        result += "            return self\n"
        result += "        }\n"

        result += "        func dispatch(threadgroups: Int, threadsPerThreadgroup: Int) -> Self {\n"
        result += "            enc.dispatchThreadgroups(MTLSizeMake(threadgroups, 1, 1), threadsPerThreadgroup: MTLSizeMake(threadsPerThreadgroup, 1, 1))\n"
        result += "            return self\n"
        result += "        }\n"
        result += "        func dispatch(threads: Int, threadsPerThreadgroup: Int) -> Self {\n"
        result += "            enc.dispatchThreadgroups(MTLSizeMake(Int(ceil(Double(threads)/Double(threadsPerThreadgroup))), 1, 1), threadsPerThreadgroup: MTLSizeMake(threadsPerThreadgroup, 1, 1))\n"
        result += "            return self\n"
        result += "        }\n"
        result += "        func end() { enc.endEncoding() } \n"

        result += "    }\n"

        result += "}\n"

        return result
    }
}
