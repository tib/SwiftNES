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
            self.sp = 0
            
//            setCarryFlag(true)
//            setZeroFlag(true)
//            setInterruptFlag(true)
//            setDecimalFlag(true)
//            setBreakFlag(true)
//            setOverflowFlag(true)
//            setSignFlag(true)
//            print(self)
        }
        
        /// resets the CPU internal state & pointers
        mutating func reset() {
            p = 0b00100000
            a = 0
            x = 0
            y = 0
            pc = 0
            sp = 0
        }
        
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

        // MARK: - get status flags

        var carryFlag: Bool {
            (p & 0b00000001) == 1
        }
        
        var zeroFlag: Bool {
            ((p & 0b00000010) >> 1) == 1
        }
        
        var interruptFlag: Bool {
            ((p & 0b00000100) >> 2) == 1
        }
        
        var decimalFlag: Bool {
            ((p & 0b00001000) >> 3) == 1
        }
        
        var breakFlag: Bool {
            ((p & 0b00010000) >> 4) == 1
        }
        
        var overflowFlag: Bool {
            ((p & 0b01000000) >> 6) == 1
        }
        
        var signFlag: Bool {
            ((p & 0b10000000) >> 7) == 1
        }
        
        // MARK: - set status flags
        
        mutating func setCarryFlag(_ value: Bool) {
            p = (p & 0b11111110) | value.byteValue
        }
        
        mutating func setZeroFlag(_ value: Bool) {
            p = (p & 0b11111101) | value.byteValue << 1
        }
        
        mutating func setInterruptFlag(_ value: Bool) {
            p = (p & 0b11111011) | value.byteValue << 2
        }
        
        mutating func setDecimalFlag(_ value: Bool) {
            p = (p & 0b11110111) | value.byteValue << 3
        }
        
        mutating func setBreakFlag(_ value: Bool) {
            p = (p & 0b11101111) | value.byteValue << 4
        }
        
        mutating func setOverflowFlag(_ value: Bool) {
            p = (p & 0b10111111) | value.byteValue << 6
        }
        
        mutating func setSignFlag(_ value: Bool) {
            p = (p & 0b01111111) | value.byteValue << 7
        }
    }
}

extension Cpu.Registers: CustomDebugStringConvertible {
    
    var debugDescription: String {
        """
        Registers
            P: \(p)
             - Carry: \(carryFlag)
             - Zero: \(zeroFlag)
             - Interrupt: \(interruptFlag)
             - Decimal: \(decimalFlag)
             - Break: \(breakFlag)
             - Overflow: \(overflowFlag)
             - Sign: \(signFlag)
            
            A: \(a.hex)
            X: \(x.hex)
            Y: \(x.hex)
            
            PC: \(p.hex)
            SP: \(p.hex)
        """
    }
}

