// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import ArgumentParser

@discardableResult
func shell(_ args: [String]) -> Int32 {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
}

let args = ProcessInfo.processInfo.arguments

@main
struct Anodize {
  static func main() {
      print("args: \(args)")

      var files = args
      files.removeFirst()

      shell(["xcrun", "-sdk", "macosx", "metal", "-c"] + files)
  }
}
