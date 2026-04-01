//
//  OverlayComputer.swift
//
//
//  Created by Shota Shimazu on 2022/06/08.
//

import Foundation
import OverlayFundation

open class OverlayComputer {
    /// storedObject is gathered instance
    var storedObject = OverlayComputerSharedInstances(runnder: [:], receivers: [:], servers: [:])
    var package: URL?

    public init() {
        storedObject.receivers.updateValue(1234, forKey: "genesis")
        storedObject.servers.updateValue(1235, forKey: "genesis")
        package = nil
    }

    public init(location: URL) {
        storedObject.receivers.updateValue(1234, forKey: "genesis")
        storedObject.servers.updateValue(1235, forKey: "genesis")
        package = location
    }

    public func configure() {
        COLogger.info("Not implemented")
    }

    public func start() {
        COLogger.info("Starting CoreOverlay internal server...")

        //let wasm = try WASMModule(module: package!)
        //try wasm.execute("main")
    }

    public func shutdown() {
        COLogger.info("Shutting down server...")
    }

    public func registerArtifacts(url: URL) {
        package = url
    }
}

public struct OverlayComputerSharedInstances {
    var runnder: [String: Any]
    var receivers: [String: Int]
    var servers: [String: Int]
}
