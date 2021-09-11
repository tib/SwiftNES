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

extension UInt8 {
    var hex: String {
        String(format:"%02X", self)
    }
}

extension UInt16 {
    var hex: String {
        String(format:"%04X", self)
    }
}
