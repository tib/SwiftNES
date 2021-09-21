//
//  Cpu+Instructions.swift
//  SwiftNes
//
//  Created by Tibor Bodecs on 2021. 09. 09..
//

import Foundation

extension Cpu {
    
    /// http://www.obelisk.me.uk/6502/instructions.html
    enum Instruction: String {
        
        /// invalid operation
        case invalid = "xxx"

        // Load/Store Operations
        
        /// Load Accumulator (N,Z)
        case lda
        /// Load X Register (N,Z)
        case ldx
        /// Load Y Register (N,Z)
        case ldy
        /// Store Accumulator
        case sta
        /// Store X Register
        case stx
        /// Store Y Register
        case sty
        
        // Register Transfers
        
        /// Transfer accumulator to X (N,Z)
        case tax
        /// Transfer accumulator to Y (N,Z)
        case tay
        /// Transfer X to accumulator (N,Z)
        case txa
        /// Transfer Y to accumulator (N,Z)
        case tya
        
        // Stack Operations
       
        /// Transfer stack pointer to X (N,Z)
        case tsx
        /// Transfer X to stack pointer
        case txs
        /// Push accumulator on stack
        case pha
        /// Push processor status on stack
        case php
        /// Pull accumulator from stack (N,Z)
        case pla
        /// Pull processor status from stack (All)
        case plp
        
        // Logical
        
        /// Logical AND (N,Z)
        case and
        /// Exclusive OR (N,Z)
        case eor
        /// Logical Inclusive OR (N,Z)
        case ora
        /// Bit Test (N,V,Z)
        case bit
        
        // Arithmetic
        
        /// Add with Carry (N,V,Z,C)
        case adc
        /// Subtract with Carry (N,V,Z,C)
        case sbc
        /// Compare accumulator (N,Z,C)
        case cmp
        /// Compare X register (N,Z,C)
        case cpx
        /// Compare Y register (N,Z,C)
        case cpy

        // Increments & Decrements
        
        /// Increment a memory location (N,Z)
        case inc
        /// Increment the X register (N,Z)
        case inx
        /// Increment the Y register (N,Z)
        case iny
        /// Decrement a memory location (N,Z)
        case dec
        /// Decrement the X register (N,Z)
        case dex
        /// Decrement the Y register (N,Z)
        case dey

        // Shifts
        
        /// Arithmetic Shift Left (N,Z,C)
        case asl
        /// Logical Shift Right (N,Z,C)
        case lsr
        /// Rotate Left (N,Z,C)
        case rol
        /// Rotate Right (N,Z,C)
        case ror

        // Jumps & Calls
        
        /// Jump to another location
        case jmp
        /// Jump to a subroutine
        case jsr
        /// Return from subroutine
        case rts
        
        // Branches
        
        /// Branch if carry flag clear
        case bcc
        /// Branch if carry flag set
        case bcs
        /// Branch if zero flag set
        case beq
        /// Branch if negative flag set
        case bmi
        /// Branch if zero flag clear
        case bne
        /// Branch if negative flag clear
        case bpl
        /// Branch if overflow flag clear
        case bvc
        /// Branch if overflow flag set
        case bvs
        
        // Status Flag Changes
        
        /// Clear carry flag (C)
        case clc
        /// Clear decimal mode flag (D)
        case cld
        /// Clear interrupt disable flag (I)
        case cli
        /// Clear overflow flag (V)
        case clv
        /// Set carry flag (C)
        case sec
        /// Set decimal mode flag (D)
        case sed
        /// Set interrupt disable flag (I)
        case sei
        
        // System Functions
        
        /// Force an interrupt (B)
        case brk
        /// No Operation
        case nop
        /// Return from Interrupt (All)
        case rti

    }

    // MARK: - instruction calls

    ///
    /// Calls the appropriate instruction handler using the given addressing mode
    ///
    /// - Parameters:
    ///     - instruction: The Instruction to perform
    ///     - addressingMode: The associated addressing mode for the operation
    ///
    /// - Returns:
    ///     The number of cycles required to perform the given instruction
    ///
    func call(_ instruction: Instruction, _ addressingMode: AddressingMode) -> Int {
        switch instruction {
        case .invalid: return invalid(addressingMode)
        case .lda: return lda(addressingMode)
        case .ldx: return ldx(addressingMode)
        case .ldy: return ldy(addressingMode)
        case .sta: return sta(addressingMode)
        case .stx: return stx(addressingMode)
        case .sty: return sty(addressingMode)
        case .tax: return tax(addressingMode)
        case .tay: return tay(addressingMode)
        case .txa: return txa(addressingMode)
        case .tya: return tya(addressingMode)
        case .tsx: return tsx(addressingMode)
        case .txs: return txs(addressingMode)
        case .pha: return pha(addressingMode)
        case .php: return php(addressingMode)
        case .pla: return pla(addressingMode)
        case .plp: return plp(addressingMode)
        case .and: return and(addressingMode)
        case .eor: return eor(addressingMode)
        case .ora: return ora(addressingMode)
        case .bit: return bit(addressingMode)
        case .adc: return adc(addressingMode)
        case .sbc: return 0
        case .cmp: return 0
        case .cpx: return 0
        case .cpy: return 0
        case .inc: return 0
        case .inx: return inx(addressingMode)
        case .iny: return iny(addressingMode)
        case .dec: return 0
        case .dex: return dex(addressingMode)
        case .dey: return dey(addressingMode)
        case .asl: return 0
        case .lsr: return 0
        case .rol: return 0
        case .ror: return 0
        case .jmp: return jmp(addressingMode)
        case .jsr: return jsr(addressingMode)
        case .rts: return rts(addressingMode)
        case .bcc: return 0
        case .bcs: return 0
        case .beq: return 0
        case .bmi: return 0
        case .bne: return 0
        case .bpl: return 0
        case .bvc: return 0
        case .bvs: return 0
        case .clc: return 0
        case .cld: return 0
        case .cli: return 0
        case .clv: return 0
        case .sec: return 0
        case .sed: return 0
        case .sei: return 0
        case .brk: return brk(addressingMode)
        case .nop: return nop(addressingMode)
        case .rti: return 0
        }
    }
    
    // MARK: - instruction handlers
    
    func brk(_ addressingMode: AddressingMode) -> Int {
        print("!!! BRK instruction")
        return 0
    }
    
    func invalid(_ addressingMode: AddressingMode) -> Int {
        print("Invalid instruction")
        return 0
    }
    
    func nop(_ addressingMode: AddressingMode) -> Int {
        print("No operation")
        return 0
    }

    func lda(_ addressingMode: AddressingMode) -> Int {
        var cycles: Int
        
        switch addressingMode {
        case .immediate:
            cycles = 2
            registers.a = fetch()
        case .zeroPage:
            cycles = 3
            registers.a = readByte(fetchZeroPageAddress())
        case .zeroPageX:
            cycles = 4
            registers.a = readByte(fetchZeroPageXAddress())
        case .absolute:
            cycles = 4
            registers.a = readByte(fetchAbsoluteAddress())
        case .absoluteX:
            cycles = 4 // +1 if page crossed
            registers.a = readByte(fetchAbsoluteXAddress(cycles: &cycles))
        case .absoluteY:
            cycles = 4 // +1 if page crossed
            registers.a = readByte(fetchAbsoluteYAddress(cycles: &cycles))
        case .indexedIndirect:
            cycles = 6
            registers.a = readByte(fetchIndexedIndirectAddress())
        case .indirectIndexed:
            cycles = 5 // +1 if page crossed
            registers.a = readByte(fetchIndirectIndexedAddress(cycles: &cycles))
        default:
            return 0
        }
        updateZeroAndSignFlagsUsing(registers.a)
        return cycles
    }
    
    func ldx(_ addressingMode: AddressingMode) -> Int {
        var cycles: Int
        
        switch addressingMode {
        case .immediate:
            cycles = 2
            registers.x = fetch()
        case .zeroPage:
            cycles = 3
            registers.x = readByte(fetchZeroPageAddress())
        case .zeroPageY:
            cycles = 4
            registers.x = readByte(fetchZeroPageYAddress())
        case .absolute:
            cycles = 4
            registers.x = readByte(fetchAbsoluteAddress())
        case .absoluteY:
            cycles = 4 // +1 if page crossed
            registers.x = readByte(fetchAbsoluteYAddress(cycles: &cycles))
        default:
            return 0
        }
        updateZeroAndSignFlagsUsing(registers.x)
        return cycles
    }
    
    func ldy(_ addressingMode: AddressingMode) -> Int {
        var cycles: Int

        switch addressingMode {
        case .immediate:
            cycles = 2
            registers.y = fetch()
        case .zeroPage:
            cycles = 3
            registers.y = readByte(fetchZeroPageAddress())
        case .zeroPageX:
            cycles = 4
            registers.y = readByte(fetchZeroPageXAddress())
        case .absolute:
            cycles = 4
            registers.y = readByte(fetchAbsoluteAddress())
        case .absoluteX:
            cycles = 4 // +1 if page crossed
            registers.y = readByte(fetchAbsoluteXAddress(cycles: &cycles))
        default:
            return 0
        }
        updateZeroAndSignFlagsUsing(registers.y)
        return cycles
    }
    
    func sta(_ addressingMode: AddressingMode) -> Int {
        var cycles: Int
        switch addressingMode {
        case .zeroPage:
            cycles = 3
            writeByte(registers.a, to: fetchZeroPageAddress())
        case .zeroPageX:
            cycles = 4
            writeByte(registers.a, to: fetchZeroPageXAddress())
        case .absolute:
            cycles = 4
            writeByte(registers.a, to: fetchAbsoluteAddress())
        case .absoluteX:
            cycles = 5
            writeByte(registers.a, to: fetchAbsoluteXAddress())
        case .absoluteY:
            cycles = 5
            writeByte(registers.a, to: fetchAbsoluteYAddress())
        case .indexedIndirect:
            cycles = 6
            writeByte(registers.a, to: fetchIndexedIndirectAddress())
        case .indirectIndexed:
            cycles = 6
            writeByte(registers.a, to: fetchIndirectIndexedAddress())
        default:
            return 0
        }
        return cycles
    }
    
    func stx(_ addressingMode: AddressingMode) -> Int {
        switch addressingMode {
        case .zeroPage:
            writeByte(registers.x, to: fetchZeroPageAddress())
            return 3
        case .zeroPageY:
            writeByte(registers.x, to: fetchZeroPageYAddress())
            return 4
        case .absolute:
            writeByte(registers.x, to: fetchAbsoluteAddress())
            return 4
        default:
            return 0
        }
    }
    
    func sty(_ addressingMode: AddressingMode) -> Int {
        switch addressingMode {
        case .zeroPage:
            writeByte(registers.y, to: fetchZeroPageAddress())
            return 3
        case .zeroPageX:
            writeByte(registers.y, to: fetchZeroPageXAddress())
            return 4
        case .absolute:
            writeByte(registers.y, to: fetchAbsoluteAddress())
            return 4
        default:
            return 0
        }
    }
    
    func adc(_ addressingMode: AddressingMode) -> Int {
        var cycles: Int
        let value: Byte
        switch addressingMode {
        case .immediate:
            cycles = 2
            value = fetch()
        case .zeroPage:
            cycles = 3
            value = readByte(fetchZeroPageAddress())
        case .zeroPageX:
            cycles = 4
            value = readByte(fetchZeroPageXAddress())
        case .absolute:
            cycles = 4
            value = readByte(fetchAbsoluteAddress())
        case .absoluteX:
            cycles = 4 // +1 if page crossed
            value = readByte(fetchAbsoluteXAddress(cycles: &cycles))
        case .absoluteY:
            cycles = 4 // +1 if page crossed
            value = readByte(fetchAbsoluteYAddress(cycles: &cycles))
        case .indexedIndirect:
            cycles = 6
            value = readByte(fetchIndexedIndirectAddress())
        case .indirectIndexed:
            cycles = 5 // +1 if page crossed
            value = readByte(fetchIndirectIndexedAddress(cycles: &cycles))
        default:
            return 0
        }
        /// add the value to the accumulator and add plus one if carry flag is active
        let result = UInt16(registers.a) + UInt16(value) + UInt16(registers.carryFlag ? 1 : 0)
        /// calculate new flags
        registers.carryFlag = result & 0xFF00 > 0
        registers.zeroFlag = result & 0x00FF == 0
        registers.signFlag = result & 0x0080 > 0
        registers.overflowFlag = ((result ^ UInt16(registers.a)) & (result ^ UInt16(value)) & 0x0080) > UInt16(0)
        /// set the result
        registers.a = UInt8(result & UInt16(0xFF))
        return cycles
    }
    
    func asl(_ addressingMode: AddressingMode) -> Int {
        0
    }
    
    func jmp(_ addressingMode: AddressingMode) -> Int {
        switch addressingMode {
        case .absolute:
            registers.pc = fetchAbsoluteAddress()
            return 3
        case .indirect:
            registers.pc = readWord(fetchAbsoluteAddress())
            return 5
        default:
            return 0
        }
    }
    
    func jsr(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .absolute else {
            return 0
        }
        let address = fetchAbsoluteAddress()
        pushWordToStack(registers.pc - 1)
        registers.pc = address
        return 6
    }
    
    func rts(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        let address = popWordFromStack()
        registers.pc = address + 1
        return 6
    }
    
    func tsx(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        registers.x = registers.sp
        updateZeroAndSignFlagsUsing(registers.x)
        return 2
    }
    
    func txs(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        registers.sp = registers.x
        return 2
    }
    
    func pha(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        pushByteToStack(registers.a)
        return 3
    }
    
    func php(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        pushByteToStack(registers.p)
        return 3
    }
    
    func pla(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        registers.a = popByteFromStack()
        updateZeroAndSignFlagsUsing(registers.a)
        return 4
    }
    
    func plp(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        
        registers.p = popByteFromStack()
        return 4
    }
    
    func and(_ addressingMode: AddressingMode) -> Int {
        var cycles: Int
        switch addressingMode {
        case .immediate:
            cycles = 2
            registers.a &= fetch()
        case .zeroPage:
            cycles = 3
            registers.a &= readByte(fetchZeroPageAddress())
        case .zeroPageX:
            cycles = 4
            registers.a &= readByte(fetchZeroPageXAddress())
        case .absolute:
            cycles = 4
            registers.a &= readByte(fetchAbsoluteAddress())
        case .absoluteX:
            cycles = 4 // +1 if page crossed
            registers.a &= readByte(fetchAbsoluteXAddress(cycles: &cycles))
        case .absoluteY:
            cycles = 4 // +1 if page crossed
            registers.a &= readByte(fetchAbsoluteYAddress(cycles: &cycles))
        case .indexedIndirect:
            cycles = 6
            registers.a &= readByte(fetchIndexedIndirectAddress())
        case .indirectIndexed:
            cycles = 5 // +1 if page crossed
            registers.a &= readByte(fetchIndirectIndexedAddress(cycles: &cycles))
        default:
            return 0
        }
        updateZeroAndSignFlagsUsing(registers.a)
        return cycles
    }
    
    func ora(_ addressingMode: AddressingMode) -> Int {
        var cycles: Int
        switch addressingMode {
        case .immediate:
            cycles = 2
            registers.a |= fetch()
        case .zeroPage:
            cycles = 3
            registers.a |= readByte(fetchZeroPageAddress())
        case .zeroPageX:
            cycles = 4
            registers.a |= readByte(fetchZeroPageXAddress())
        case .absolute:
            cycles = 4
            registers.a |= readByte(fetchAbsoluteAddress())
        case .absoluteX:
            cycles = 4 // +1 if page crossed
            registers.a |= readByte(fetchAbsoluteXAddress(cycles: &cycles))
        case .absoluteY:
            cycles = 4 // +1 if page crossed
            registers.a |= readByte(fetchAbsoluteYAddress(cycles: &cycles))
        case .indexedIndirect:
            cycles = 6
            registers.a |= readByte(fetchIndexedIndirectAddress())
        case .indirectIndexed:
            cycles = 5 // +1 if page crossed
            registers.a |= readByte(fetchIndirectIndexedAddress(cycles: &cycles))
        default:
            return 0
        }
        updateZeroAndSignFlagsUsing(registers.a)
        return cycles
    }
    
    func eor(_ addressingMode: AddressingMode) -> Int {
        var cycles: Int
        switch addressingMode {
        case .immediate:
            cycles = 2
            registers.a ^= fetch()
        case .zeroPage:
            cycles = 3
            registers.a ^= readByte(fetchZeroPageAddress())
        case .zeroPageX:
            cycles = 4
            registers.a ^= readByte(fetchZeroPageXAddress())
        case .absolute:
            cycles = 4
            registers.a ^= readByte(fetchAbsoluteAddress())
        case .absoluteX:
            cycles = 4 // +1 if page crossed
            registers.a ^= readByte(fetchAbsoluteXAddress(cycles: &cycles))
        case .absoluteY:
            cycles = 4 // +1 if page crossed
            registers.a ^= readByte(fetchAbsoluteYAddress(cycles: &cycles))
        case .indexedIndirect:
            cycles = 6
            registers.a ^= readByte(fetchIndexedIndirectAddress())
        case .indirectIndexed:
            cycles = 5 // +1 if page crossed
            registers.a ^= readByte(fetchIndirectIndexedAddress(cycles: &cycles))
        default:
            return 0
        }
        updateZeroAndSignFlagsUsing(registers.a)
        return cycles
    }
    
    func bit(_ addressingMode: AddressingMode) -> Int {
        let cycles: Int
        let value: UInt8
        switch addressingMode {
        case .zeroPage:
            cycles = 3
            value = readByte(fetchZeroPageAddress())
        case .absolute:
            cycles = 4
            value = readByte(fetchAbsoluteAddress())
        default:
            return 0
        }
        registers.zeroFlag = (registers.a & value) > 0
        registers.overflowFlag = (value & 0b01000000) > 0
        registers.signFlag = (value & 0b10000000) > 0
        return cycles
    }
    
    func tax(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        registers.x = registers.a
        updateZeroAndSignFlagsUsing(registers.x)
        return 2
    }
    
    func tay(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        registers.y = registers.a
        updateZeroAndSignFlagsUsing(registers.y)
        return 2
    }
    
    func txa(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        registers.a = registers.x
        updateZeroAndSignFlagsUsing(registers.a)
        return 2
    }
    
    func tya(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        registers.a = registers.y
        updateZeroAndSignFlagsUsing(registers.a)
        return 2
    }
    
    func inx(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        registers.x = registers.x &+ 1
        updateZeroAndSignFlagsUsing(registers.x)
        return 2
    }
    
    func iny(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        registers.y = registers.y &+ 1
        updateZeroAndSignFlagsUsing(registers.y)
        return 2
    }
    
    func dex(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        registers.x = registers.x &- 1
        updateZeroAndSignFlagsUsing(registers.x)
        return 2
    }
    
    func dey(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        registers.y = registers.y &- 1
        updateZeroAndSignFlagsUsing(registers.y)
        return 2
    }
}
