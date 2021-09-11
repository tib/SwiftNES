//
//  Memory.swift
//  SwiftNES
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
    private var storage: [Byte]

    init(size: Int) {
        guard size > 0 else {
            fatalError("Invalid memory size")
        }
        self.size = size
        self.storage = [Byte](repeating: 0, count: size)
        
//        // LDA
//        storage[0x00] = 0xa9
//        storage[0x01] = 0x42

//        // LDA ZP
//        storage[0x00] = 0xa5
//        storage[0x01] = 0x42
//        storage[0x42] = 11

        // JMP
        storage[0x00] = 0x20
        storage[0x01] = 0x11
        storage[0x02] = 0x00
        storage[0x0011] = 0xa9
        storage[0x0012] = 0xcf
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
