//
//  Cpu+Registers.swift
//  SwiftNes
//
//  Created by Tibor Bodecs on 2021. 09. 09..
//

import Foundation

extension Cpu {

    /// http://www.obelisk.me.uk/6502/registers.html
    struct Registers {
 
        /*
        0000 0001 - Carry Flag
        0000 0010 - Zero Flag
        0000 0100 - Interrupt Disable
        0000 1000 - Decimal Mode
        0001 0000 - Unused
        0010 0000 - Break Command
        0100 0000 - Overflow Flag
        1000 0000 - Negative Flag
        */
        
        /// status flags
        private var p: Byte
        /// accumulator
        var a: Byte
        /// index register x
        var x: Byte
        /// index register y
        var y: Byte
        /// program counter
        var pc: Address
        /// stack pointer
        var sp: Byte
        
        init() {
            self.p = 0b00100000
            self.a = 0
            self.x = 0
            self.y = 0
            self.pc = 0
            self.sp = 0xFF
        }
        
        /// resets the CPU internal state & pointers
        mutating func reset() {
            p = 0b00100000
            a = 0
            x = 0
            y = 0
            pc = 0
            sp = 0xFF
        }

        // MARK: - status flags

        var carryFlag: Bool {
            get {
                (p & 0b00000001) == 1
            }
            set {
                p = (p & 0b11111110) | newValue.byteValue
            }
        }
        
        var zeroFlag: Bool {
            get {
                ((p & 0b00000010) >> 1) == 1
            }
            set {
                p = (p & 0b11111101) | newValue.byteValue << 1
            }
        }
        
        var interruptFlag: Bool {
            get {
                ((p & 0b00000100) >> 2) == 1
            }
            set {
                p = (p & 0b11111011) | newValue.byteValue << 2
            }
        }
        
        var decimalFlag: Bool {
            get {
                ((p & 0b00001000) >> 3) == 1
            }
            set {
                p = (p & 0b11110111) | newValue.byteValue << 3
            }
        }
        
        var breakFlag: Bool {
            get {
                ((p & 0b00010000) >> 4) == 1
            }
            set {
                p = (p & 0b11101111) | newValue.byteValue << 4
            }
        }
        
        var overflowFlag: Bool {
            get {
                ((p & 0b01000000) >> 6) == 1
            }
            set {
                p = (p & 0b10111111) | newValue.byteValue << 6
            }
        }
        
        var signFlag: Bool {
            get {
                ((p & 0b10000000) >> 7) == 1
            }
            set {
                p = (p & 0b01111111) | newValue.byteValue << 7
            }
        }
    }
}

extension Cpu.Registers: CustomDebugStringConvertible {
    
    var debugDescription: String {
        """
        Registers
            P: 0x\(p.hex) - 0b\(p.bin)
             - Carry: \(carryFlag)
             - Zero: \(zeroFlag)
             - Interrupt: \(interruptFlag)
             - Decimal: \(decimalFlag)
             - Break: \(breakFlag)
             - Overflow: \(overflowFlag)
             - Sign: \(signFlag)
            
            A: 0x\(a.hex)
            X: 0x\(x.hex)
            Y: 0x\(y.hex)
            
            PC: 0x\(pc.hex)
            SP: 0x\(sp.hex)
        """
    }
}

