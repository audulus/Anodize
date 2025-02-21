//
//  AnodizeDemoApp.swift
//  AnodizeDemo
//
//  Created by Taylor Holliday on 2/21/25.
//

import SwiftUI
import AnodizeUtil

func runMyKernel() {

    do {
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

        print("array: \(array.array)")

    } catch {
        print("⚠️ error: \(error)")
    }
}

@main
struct AnodizeDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    runMyKernel()
                }
        }
    }
}
