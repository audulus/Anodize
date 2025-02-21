
import Foundation
import Metal

public final class MutableGPUArray<Element>: GPUArray<Element>, MutableGPUBufferProvider, @unchecked Sendable {

    public override init(
            length: Int,
            options: MTLResourceOptions = [.storageModeShared],
            label: String? = nil,
            heap: MTLHeap? = nil
    ) throws {
        try super.init(length: length, options: options, heap: heap)
    }

    public override init(data: [Element], label: String? = nil, heap: MTLHeap? = nil) throws {
        try super.init(data: data, label: label, heap: heap)
    }

    @inline(__always) @inlinable
    public override subscript(index: Int) -> Element {
        get {
            assert(index < mutablePointer.count)
            return self.mutablePointer[index]
        }
        set {
            assert(index < mutablePointer.count)
            self.mutablePointer[index] = newValue
        }
    }

    public var baseAddress: UnsafeMutablePointer<Element> {
        mutablePointer.baseAddress!
    }

    /// Ensure we have enough capacity.
    public func reserveCapacity(_ newCapacity: Int) -> Bool {

        if newCapacity > capacity {
            var sz = capacity
            while sz < newCapacity {
                sz *= 2
            }
            guard let newBuffer = buffer.device.makeBuffer(length: sz * MemoryLayout<Element>.size) else {
                return false
            }
            let raw = UnsafeMutableRawBufferPointer(start: newBuffer.contents(), count: newBuffer.length)
            let newPointer = raw.bindMemory(to: Element.self)

            for i in 0..<capacity {
                newPointer[i] = mutablePointer[i]
            }

            buffer = newBuffer
            mutablePointer = newPointer
        }

        return true
    }

    /// Shift elements such that indices are removed.
    public func remove(elementsAtIndices indicesToRemove: [Int]) {
        guard !indicesToRemove.isEmpty else {
            return
        }

        var shouldRemove: [Bool] = .init(repeating: false, count: capacity)

        for ix in indicesToRemove {
            shouldRemove[ix] = true
        }

        // Compact the array
        var j = 0
        for i in 0..<capacity where !shouldRemove[i] {
            if i != j {
                self[j] = self[i]
            }
            j+=1
        }
    }

}
