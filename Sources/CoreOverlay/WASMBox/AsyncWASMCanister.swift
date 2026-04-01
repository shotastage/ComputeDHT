//
//  AsyncWASMBox.swift
//  
//
//  Created by Shota Shimazu on 2023/03/20.
//

import Foundation

actor WasmBoxActor {
    private var internalValue: Int

    init(value: Int) {
        self.internalValue = value
    }
}

extension WasmBoxActor {
    func asyncOperation() async -> Int {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        internalValue += 1
        return internalValue
    }
}
