//
//  MTLDataType+swiftName.swift
//  Anodize
//
//  Created by Taylor Holliday on 2/21/25.
//

import Metal

extension MTLDataType {

    var swiftName: String? {
        switch self {

        case .none:
            return nil
        case .struct:
            return nil
        case .array:
            return nil
        case .float:
            return "Float"
        case .float2:
            return "SIMD2<Float>"
        case .float3:
            return "SIMD3<Float>"
        case .float4:
            return "SIMD4<Float>"
        case .float2x2:
            return "float2x2"
        case .float2x3:
            return "float2x3"
        case .float2x4:
            return "float2x4"
        case .float3x2:
            return "float3x2"
        case .float3x3:
            return "float3x3"
        case .float3x4:
            return "float3x4"
        case .float4x2:
            return "float4x2"
        case .float4x3:
            return "float4x3"
        case .float4x4:
            return "float4x4"
        case .half:
            return "Float16"
        case .half2:
            return "SIMD2<Float16>"
        case .half3:
            return "SIMD3<Float16>"
        case .half4:
            return "SIMD4<Float16>"
        case .half2x2:
            return nil
        case .half2x3:
            return nil
        case .half2x4:
            return nil
        case .half3x2:
            return nil
        case .half3x3:
            return nil
        case .half3x4:
            return nil
        case .half4x2:
            return nil
        case .half4x3:
            return nil
        case .half4x4:
            return nil
        case .int:
            return "Int32"
        case .int2:
            return "SIMD2<Int32>"
        case .int3:
            return "SIMD3<Int32>"
        case .int4:
            return "SIMD4<Int32>"
        case .uint:
            return "UInt32"
        case .uint2:
            return "SIMD2<UInt32>"
        case .uint3:
            return "SIMD3<UInt32>"
        case .uint4:
            return "SIMD4<UInt32>"
        case .short:
            return "Int16"
        case .short2:
            return "SIMD2<Int16>"
        case .short3:
            return "SIMD3<Int16>"
        case .short4:
            return "SIMD4<Int16>"
        case .ushort:
            return "UInt16"
        case .ushort2:
            return "SIMD2<UInt16>"
        case .ushort3:
            return "SIMD3<UInt16>"
        case .ushort4:
            return "SIMD4<UInt16>"
        case .char:
            return "Int8"
        case .char2:
            return "SIMD2<Int8>"
        case .char3:
            return "SIMD3<Int8>"
        case .char4:
            return "SIMD4<Int8>"
        case .uchar:
            return "UInt8"
        case .uchar2:
            return "SIMD2<UInt8>"
        case .uchar3:
            return "SIMD3<UInt8>"
        case .uchar4:
            return "SIMD4<UInt8>"
        case .bool:
            return "Bool"
        case .bool2:
            return "SIMD2<Bool>"
        case .bool3:
            return "SIMD3<Bool>"
        case .bool4:
            return "SIMD4<Bool>"
        default:
            return nil
        }
    }
}
