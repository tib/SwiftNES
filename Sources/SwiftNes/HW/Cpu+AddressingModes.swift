//
//  Cpu+AddressingModes.swift
//  SwiftNes
//
//  Created by Tibor Bodecs on 2021. 09. 09..
//

import Foundation

extension Cpu {

    /// http://www.obelisk.me.uk/6502/addressing.html
    enum AddressingMode {
        case implicit
        case accumulator
        case immediate
        case zeroPage
        case zeroPageX
        case zeroPageY
        case absolute
        case absoluteX
        case absoluteY
        case relative
        case indirect
        case indexedIndirect
        case indirectIndexed
    }
}
