
import Metal

public protocol GPUBufferProvider<Element> {

    associatedtype Element

    var buffer: MTLBuffer { get }
    var offset: Int { get }
    var capacity: Int { get }
}

public protocol MutableGPUBufferProvider<Element>: GPUBufferProvider {

}
