//
//  Memory.swift
//  SwiftNes
//
//  Created by Tibor Bodecs on 2021. 09. 08..
//

import Foundation

fileprivate extension Array where Element == Byte {

    subscript(index: Address) -> Element {
        get {
            self[Int(index)]
        }
        set {
            self[Int(index)] = newValue
        }
    }
}

final class Memory {

    let size: Int
    var storage: [Byte]

    init(size: Int) {
        guard size > 0 else {
            fatalError("Invalid memory size")
        }
        self.size = size
        self.storage = [Byte](repeating: 0, count: size)
    }

    func reset() {
        storage = [Byte](repeating: 0, count: size)
    }
    
}

extension Memory: BusDevice {

    func readByte(from address: Address) -> Byte {
        guard address <= size else {
            return 0
        }
        return storage[address]
    }

    func writeByte(_ data: Byte, to address: Address) {
        guard address <= size else {
            return
        }
        storage[address] = data
    }
}
