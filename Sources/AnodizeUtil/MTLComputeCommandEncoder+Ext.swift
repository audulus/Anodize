//
//  MTLComputeCommandEncoder+Ext.swift
//  Anodize
//
//  Created by Taylor Holliday on 2/21/25.
//

import Foundation
import Metal

public extension MTLComputeCommandEncoder {
    func setBytes<T>(_ value: T, index: Int) {
        var copy = value
        withUnsafeMutableBytes(of: &copy) { ptr in
            setBytes(ptr.baseAddress!, length: MemoryLayout<T>.size, index: index)
        }
    }

    func setBytes<T>(_ value: T, index: Int32) {
        var copy = value
        withUnsafeMutableBytes(of: &copy) { ptr in
            setBytes(ptr.baseAddress!, length: MemoryLayout<T>.size, index: Int(index))
        }
    }

    func setBytes<T, Index: RawRepresentable<UInt32> >(_ value: T, index: Index) {
        var copy = value
        withUnsafeMutableBytes(of: &copy) { ptr in
            setBytes(ptr.baseAddress!, length: MemoryLayout<T>.size, index: Int(index.rawValue))
        }
    }

    func setBuffer(_ buffer: MTLBuffer, index: Int32) {
        setBuffer(buffer, offset: 0, index: Int(index))
    }

    func setBuffer<Element>(_ buffer: some GPUBufferProvider<Element>, index: Int32, offset: Int = 0) {
        setBuffer(buffer.buffer, offset: buffer.offset + offset * MemoryLayout<Element>.stride, index: Int(index))
    }

    func setBuffer<Element, Index: RawRepresentable<UInt32> >(_ buffer: some GPUBufferProvider<Element>,
                                                             index: Index,
                                                             offset: Int = 0) {
        setBuffer(buffer.buffer,
                  offset: buffer.offset + offset * MemoryLayout<Element>.stride,
                  index: Int(index.rawValue))
    }

    func setTexture(_ texture: MTLTexture?, index: Int32) {
        setTexture(texture, index: Int(index))
    }

    func setTexture<Index: RawRepresentable<UInt32> >(_ texture: MTLTexture?, index: Index) {
        setTexture(texture, index: Int(index.rawValue))
    }
}
