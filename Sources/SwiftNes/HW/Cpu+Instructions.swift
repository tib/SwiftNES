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

    /// call the appropriate instruction handler using the given addressing mode
    func call(_ instruction: Instruction, _ addressingMode: AddressingMode) {
        switch instruction {
        case .invalid: return invalid(addressingMode)
        case .lda: return lda(addressingMode)
        case .ldx: return ldx(addressingMode)
        case .ldy: return ldy(addressingMode)
        case .sta: return
        case .stx: return
        case .sty: return
        case .tax: return
        case .tay: return
        case .txa: return
        case .tya: return
        case .tsx: return
        case .txs: return
        case .pha: return
        case .php: return
        case .pla: return
        case .plp: return
        case .and: return
        case .eor: return
        case .ora: return
        case .bit: return
        case .adc: return adc(addressingMode)
        case .sbc: return
        case .cmp: return
        case .cpx: return
        case .cpy: return
        case .inc: return
        case .inx: return
        case .iny: return
        case .dec: return
        case .dex: return
        case .dey: return
        case .asl: return
        case .lsr: return
        case .rol: return
        case .ror: return
        case .jmp: return jmp(addressingMode)
        case .jsr: return jsr(addressingMode)
        case .rts: return
        case .bcc: return
        case .bcs: return
        case .beq: return
        case .bmi: return
        case .bne: return
        case .bpl: return
        case .bvc: return
        case .bvs: return
        case .clc: return
        case .cld: return
        case .cli: return
        case .clv: return
        case .sec: return
        case .sed: return
        case .sei: return
        case .brk: return
        case .nop: return nop(addressingMode)
        case .rti: return
        }
    }
    
    // MARK: - helpers
    
    private func updateZeroAndSignFlagsUsing(_ value: Byte) {
        registers.zeroFlag = value == 0
        registers.signFlag = (value & 0b10000000) > 0
    }
    
    // MARK: - instruction handlers
    
    func invalid(_ addressingMode: AddressingMode) {
        print("Invalid instruction")
    }
    
    func nop(_ addressingMode: AddressingMode) {
        print("No operation")
    }

    func lda(_ addressingMode: AddressingMode) {
        switch addressingMode {
        case .immediate:
            registers.a = fetch()
        case .zeroPage:
            registers.a = readByte(fetchZeroPageAddress())
        case .zeroPageX:
            registers.a = readByte(fetchZeroPageXAddress())
        case .absolute:
            registers.a = readByte(fetchAbsoluteAddress())
        case .absoluteX:
            registers.a = readByte(fetchAbsoluteXAddress())
        case .absoluteY:
            registers.a = readByte(fetchAbsoluteYAddress())
        case .indexedIndirect:
            registers.a = readByte(fetchIndexedIndirectAddress())
        case .indirectIndexed:
            registers.a = readByte(fetchIndirectIndexedAddress())
        default:
            return // no action
        }
        updateZeroAndSignFlagsUsing(registers.a)
    }
    
    func ldx(_ addressingMode: AddressingMode) {
        switch addressingMode {
        case .immediate:
            registers.x = fetch()
        case .zeroPage:
            registers.x = readByte(fetchZeroPageAddress())
        case .zeroPageY:
            registers.x = readByte(fetchZeroPageYAddress())
        case .absolute:
            registers.x = readByte(fetchAbsoluteAddress())
        case .absoluteY:
            registers.x = readByte(fetchAbsoluteYAddress())
        default:
            return // no action
        }
        updateZeroAndSignFlagsUsing(registers.x)
    }
    
    func ldy(_ addressingMode: AddressingMode) {
        switch addressingMode {
        case .immediate:
            registers.y = fetch()
        case .zeroPage:
            registers.y = readByte(fetchZeroPageAddress())
        case .zeroPageX:
            registers.y = readByte(fetchZeroPageXAddress())
        case .absolute:
            registers.y = readByte(fetchAbsoluteAddress())
        case .absoluteX:
            registers.y = readByte(fetchAbsoluteXAddress())
        default:
            return // no action
        }
        updateZeroAndSignFlagsUsing(registers.y)
    }
    
    func adc(_ addressingMode: AddressingMode) {
        let value: Byte

        switch addressingMode {
        case .immediate:
            value = fetch()
        case .zeroPage:
            value = readByte(fetchZeroPageAddress())
        case .zeroPageX:
            value = readByte(fetchZeroPageXAddress())
        case .absolute:
            value = readByte(fetchAbsoluteAddress())
        case .absoluteX:
            value = readByte(fetchAbsoluteXAddress())
        case .absoluteY:
            value = readByte(fetchAbsoluteYAddress())
        case .indexedIndirect:
            value = readByte(fetchIndexedIndirectAddress())
        case .indirectIndexed:
            value = readByte(fetchIndirectIndexedAddress())
        default:
            return // no action
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
    }
    
    
    func brk(_ addressingMode: AddressingMode) {
        
    }
    
    func ora(_ addressingMode: AddressingMode) {
        
    }
    
    func asl(_ addressingMode: AddressingMode) {
        
    }
    
    func jmp(_ addressingMode: AddressingMode) {
        
    }
    
    func jsr(_ addressingMode: AddressingMode) {
        guard addressingMode == .absolute else { return }

        let absoluteAddress = Address(fetch()) + Address(fetch()) << 8

        writeWord(registers.pc - 1, to: Address(registers.sp + 1))

        /// +1 cycle
        registers.pc = absoluteAddress
        totalCycles += 1
    }
}
