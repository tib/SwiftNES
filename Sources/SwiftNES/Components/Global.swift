//
//  Global.swift
//  SwiftNES
//
//  Created by Tibor Bodecs on 2021. 09. 08..
//

/// http://archive.nes.science/nesdev-forums/f2/t7767.xhtml
typealias Byte = UInt8
typealias Word = UInt16
typealias Address = Word

extension Bool {
    var byteValue: Byte { self ? 1 : 0 }
}

fileprivate extension String {
    
    func leftPad(with character: Character, length: UInt) -> String {
        let maxLength = Int(length) - count
        guard maxLength > 0 else {
            return self
        }
        return String(repeating: String(character), count: maxLength) + self
    }
}

extension Byte {
    var hex: String {
        String(format:"%02X", self)
    }

    var bin: String {
        String(self, radix: 2).leftPad(with: "0", length: 8)
    }
}

extension Word {
    var hex: String {
        String(format:"%04X", self)
    }
    
    var bin: String {
        String(self, radix: 2).leftPad(with: "0", length: 16)
    }
}
