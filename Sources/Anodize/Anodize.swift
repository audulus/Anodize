
import Foundation
import ArgumentParser
import Metal

@discardableResult
func shell(_ args: [String]) -> Int32 {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
}

func computePipelineReflection(function: MTLFunction) -> MTLComputePipelineReflection {

    let device = MTLCreateSystemDefaultDevice()!
    let computeDesc = MTLComputePipelineDescriptor()
    computeDesc.computeFunction = function
    return try! device.makeComputePipelineState(descriptor: computeDesc, options: [.bindingInfo, .bufferTypeInfo]).1!
}

@main
struct Anodize: ParsableCommand {

    @Argument(help: "A list of input file paths.")
    var inputFiles: [String]

    @Option(name: [.short, .customLong("output")], help: "File to write generated wrapper code.")
    var outputFile: String

    mutating func run() throws {
        // print("args: \(args)")

        let mgr = FileManager.default
        let device = MTLCreateSystemDefaultDevice()!

        let library: MTLLibrary

        if let file = inputFiles.first, file.hasSuffix(".metallib") {
            library = try! device.makeLibrary(URL: URL(filePath: file))
        } else {

            shell(["xcrun", "-sdk", "macosx", "metal", "-c"] + inputFiles)

            let airFiles = inputFiles.map { URL(filePath: $0).deletingPathExtension().appendingPathExtension("air").lastPathComponent }

            // print("airfiles: \(airFiles)")

            shell(["xcrun", "-sdk", "macosx", "metallib", "-o", "anodize.metallib"] + airFiles)


            for file in airFiles { try! mgr.removeItem(atPath: file) }

            library = try! device.makeLibrary(URL: URL(filePath: "anodize.metallib"))
        }

        var contents = ""
        contents += "//  This file is generated by Anodize. DO NOT EDIT.\n"
        contents += "import Metal\n"
        contents += "import AnodizeUtil\n"

        var count = 0
        for name in library.functionNames {
            let function = library.makeFunction(name: name)

            if let function, function.functionType == .kernel {
                // print("found kernel function: \(name)")

                let reflection = computePipelineReflection(function: function)

                contents += reflection.kernelWrapper(name: name, functionName: name)
                count += 1
            }
        }

        print("🤘 anodized \(count) kernel functions")

        try! contents.write(to: URL(filePath: outputFile), atomically: true, encoding: .utf8)

        if mgr.fileExists(atPath: "anodize.metallib") {
            try! mgr.removeItem(atPath: "anodize.metallib")
        }
    }
}
