//
//  COLogger.swift
//
//
//  Created by Shota Shimazu on 2026/04/01.
//

import Foundation

public enum COLogger {
    public static func info(_ message: String) {
        NSLog("[CoreOverlay] \(message)")
    }
}
