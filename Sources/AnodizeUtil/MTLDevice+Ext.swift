//
//  MTLDevice+Ext.swift
//  Anodize
//
//  Created by Taylor Holliday on 2/21/25.
//

import Metal

public extension MTLDevice {
    func makeBuffer<T>(_ array: [T]) -> MTLBuffer? {
        array.withUnsafeBytes { ptr in
            makeBuffer(bytes: ptr.baseAddress!, length: ptr.count)
        }
    }

    func makeComputePipeline(name: String) -> MTLComputePipelineState {
        let lib = makeDefaultLibrary()!

        let function = lib.makeFunction(name: name)!
        let computeDesc = MTLComputePipelineDescriptor()
        computeDesc.computeFunction = function
        computeDesc.label = name
        return try! makeComputePipelineState(descriptor: computeDesc, options: []).0
    }
}
