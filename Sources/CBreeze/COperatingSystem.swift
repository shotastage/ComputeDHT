//
//  COperatingSystem.swift
//
//
//  Created by Shota Shimazu on 2023/09/01.
//

#if canImport(Darwin.C)
    // Darwin platforms (macOS, iOS, watchOS, tvOS)
    @_exported import Darwin.C
#elseif canImport(Glibc)
    // Linux and other platforms using glibc
    @_exported import Glibc
#elseif canImport(ucrt)
    // Windows with Universal C Runtime (UCRT)
    @_exported import ucrt
#elseif canImport(WinSDK)
    // Windows with WinSDK
    @_exported import WinSDK
#else
    #error("Unsupported platform: no known C runtime module")
#endif
