//
//  AnodizeError.swift
//  Anodize
//
//  Created by Taylor Holliday on 2/21/25.
//

import Foundation
import Metal

public enum AnodizeError: Error, Equatable {
    case bufferOOM
    case logicError(String)
}
