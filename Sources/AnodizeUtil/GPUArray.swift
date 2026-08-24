
import Foundation
import Metal

public class GPUArray<Element>: GPUBufferProvider, @unchecked Sendable {

    public var buffer: MTLBuffer

    @usableFromInline
    internal var mutablePointer: UnsafeMutableBufferPointer<Element>

    public init(data: [Element], label: String? = nil, heap: MTLHeap? = nil) throws {

        // If empty, just create a one element buffer.
        let count = data.count > 0 ? data.count : 1

        if let heap {
            guard let buffer = heap.makeBuffer(length: count * MemoryLayout<Element>.size,
                                               options: .storageModeShared) else {
                throw AnodizeError.bufferOOM
            }
            self.buffer = buffer
            let raw = UnsafeMutableRawBufferPointer(start: buffer.contents(), count: buffer.length)
            self.mutablePointer = raw.bindMemory(to: Element.self)

            // One bulk copy rather than a store per element: the loop this replaces
            // cost most of a second on a multi-million-vertex mesh. `update` keeps that
            // loop's semantics exactly, and for the trivial types this holds it is a
            // memcpy.
            if let dst = self.mutablePointer.baseAddress {
                data.withUnsafeBufferPointer { src in
                    if let base = src.baseAddress {
                        dst.update(from: base, count: data.count)
                    }
                }
            }

        } else {
            let device = MTLCreateSystemDefaultDevice()!

            guard let buffer = data.withUnsafeBytes({ ptr in
                device.makeBuffer(bytes: ptr.baseAddress!, length: count * MemoryLayout<Element>.size, options: .storageModeShared)
            }) else {
                throw AnodizeError.bufferOOM
            }
            self.buffer = buffer
            let raw = UnsafeMutableRawBufferPointer(start: buffer.contents(), count: buffer.length)
            self.mutablePointer = raw.bindMemory(to: Element.self)
        }

        self.buffer.label = label
    }

    internal init(length: Int, options: MTLResourceOptions, label: String? = nil, heap: MTLHeap? = nil) throws {
        if length == 0 {
            throw AnodizeError.logicError("Empty GPUArray")
        }

        if let heap {
            guard let buffer = heap.makeBuffer(length: length * MemoryLayout<Element>.size, options: options) else {
                throw AnodizeError.bufferOOM
            }
            self.buffer = buffer
        } else {
            let device = MTLCreateSystemDefaultDevice()!

            guard let buffer = device.makeBuffer(length: length * MemoryLayout<Element>.size, options: options) else {
                throw AnodizeError.bufferOOM
            }
            self.buffer = buffer
        }

        let raw = UnsafeMutableRawBufferPointer(start: buffer.contents(), count: buffer.length)
        self.mutablePointer = raw.bindMemory(to: Element.self)
        self.buffer.label = label
    }

    public init(buffer: MTLBuffer) {
        self.buffer = buffer
        let raw = UnsafeMutableRawBufferPointer(start: buffer.contents(), count: buffer.length)
        self.mutablePointer = raw.bindMemory(to: Element.self)
    }

    @inline(__always) @inlinable
    public subscript(index: Int) -> Element {
        assert(index < mutablePointer.count)
        return self.mutablePointer[index]
    }

    @inline(__always) @inlinable
    public subscript(index: UInt32) -> Element {
        assert(index < mutablePointer.count)
        return self.mutablePointer[Int(index)]
    }

    public var capacity: Int {
        mutablePointer.count
    }

    public var data: Data {
        Data(bytes: buffer.contents(), count: buffer.length)
    }

    public var array: [Element] {
        .init(mutablePointer)
    }

    public var offset: Int { 0 }

    public var pointer: UnsafePointer<Element> {
        .init(mutablePointer.baseAddress!)
    }
}
