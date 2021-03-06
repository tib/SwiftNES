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
        case .sbc: return sbc(addressingMode)
        case .cmp: return cmp(addressingMode)
        case .cpx: return cpx(addressingMode)
        case .cpy: return cpy(addressingMode)
        case .inc: return inc(addressingMode)
        case .inx: return inx(addressingMode)
        case .iny: return iny(addressingMode)
        case .dec: return dec(addressingMode)
        case .dex: return dex(addressingMode)
        case .dey: return dey(addressingMode)
        case .asl: return asl(addressingMode)
        case .lsr: return lsr(addressingMode)
        case .rol: return rol(addressingMode)
        case .ror: return ror(addressingMode)
        case .jmp: return jmp(addressingMode)
        case .jsr: return jsr(addressingMode)
        case .rts: return rts(addressingMode)
        case .bcc: return bcc(addressingMode)
        case .bcs: return bcs(addressingMode)
        case .beq: return beq(addressingMode)
        case .bmi: return bmi(addressingMode)
        case .bne: return bne(addressingMode)
        case .bpl: return bpl(addressingMode)
        case .bvc: return bvc(addressingMode)
        case .bvs: return bvs(addressingMode)
        case .clc: return clc(addressingMode)
        case .cld: return cld(addressingMode)
        case .cli: return cli(addressingMode)
        case .clv: return clv(addressingMode)
        case .sec: return sec(addressingMode)
        case .sed: return sed(addressingMode)
        case .sei: return sei(addressingMode)
        case .brk: return brk(addressingMode)
        case .nop: return nop(addressingMode)
        case .rti: return rti(addressingMode)
        case .invalid: return invalid(addressingMode)
        }
    }
    
    // MARK: - instruction handlers

    /// Generic invalid instruction handler, currently just a fatal error.
    func invalid(_ addressingMode: AddressingMode) -> Int {
        fatalError("Invalid instruction.")
    }

    ///
    /// The BRK instruction forces the generation of an interrupt request.
    ///
    /// The program counter and processor status are pushed on the stack then the IRQ interrupt vector at $FFFE/F is loaded into the PC and the break flag in the status set to one.
    ///
    /// The interpretation of a BRK depends on the operating system.
    /// On the BBC Microcomputer it is used by language ROMs to signal run time errors but it could be used for other purposes (e.g. calling operating system functions, etc.).
    ///
    func brk(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        pushWordToStack(registers.pc)
        pushByteToStack(registers.p)
        // TODO: use 0xFFFE later on, since NES has only 2KB RAM, we're good for now
        registers.pc = readWord(0x00FE)
        registers.breakFlag = true
        return 7
    }
    
    ///
    /// The RTI instruction is used at the end of an interrupt processing routine.
    ///
    /// It pulls the processor flags from the stack followed by the program counter.
    ///
    func rti(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        registers.p = popByteFromStack()
        registers.pc = popWordFromStack()
        return 6
    }
    
    /// The NOP instruction causes no changes to the processor other than the normal incrementing of the program counter to the next instruction.
    func nop(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        return 2
    }

    /// Loads a byte of memory into the accumulator setting the zero and negative flags as appropriate.
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
    
    /// Loads a byte of memory into the X register setting the zero and negative flags as appropriate.
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
    
    /// Loads a byte of memory into the Y register setting the zero and negative flags as appropriate.
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
    
    /// Stores the contents of the accumulator into memory.
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
    
    /// Stores the contents of the X register into memory.
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
    
    /// Stores the contents of the Y register into memory.
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
    
    /// Sets the program counter to the address specified by the operand.
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
    
    /// Pushes the address (minus one) of the return point on to the stack and then sets the program counter to the target memory address.
    func jsr(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .absolute else {
            return 0
        }
        let address = fetchAbsoluteAddress()
        pushWordToStack(registers.pc - 1)
        registers.pc = address
        return 6
    }
    
    ///
    /// The RTS instruction is used at the end of a subroutine to return to the calling routine.
    ///
    /// It pulls the program counter (minus one) from the stack.
    ///
    func rts(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        let address = popWordFromStack()
        registers.pc = address + 1
        return 6
    }
    
    /// Copies the current contents of the stack register into the X register and sets the zero and negative flags as appropriate.
    func tsx(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        registers.x = registers.sp
        updateZeroAndSignFlagsUsing(registers.x)
        return 2
    }
    
    /// Copies the current contents of the X register into the stack register.
    func txs(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        registers.sp = registers.x
        return 2
    }
    
    /// Pushes a copy of the accumulator on to the stack.
    func pha(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        pushByteToStack(registers.a)
        return 3
    }
    
    /// Pushes a copy of the status flags on to the stack.
    func php(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        pushByteToStack(registers.p)
        return 3
    }
    
    ///
    /// Pulls an 8 bit value from the stack and into the accumulator.
    ///
    /// The zero and negative flags are set as appropriate.
    ///
    func pla(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        registers.a = popByteFromStack()
        updateZeroAndSignFlagsUsing(registers.a)
        return 4
    }
    
    ///
    /// Pulls an 8 bit value from the stack and into the processor flags.
    ///
    /// The flags will take on new states as determined by the value pulled.
    ///
    func plp(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        
        registers.p = popByteFromStack()
        return 4
    }
    
    /// A logical AND is performed, bit by bit, on the accumulator contents using the contents of a byte of memory.
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
    
    /// An inclusive OR is performed, bit by bit, on the accumulator contents using the contents of a byte of memory.
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
    
    /// An exclusive OR is performed, bit by bit, on the accumulator contents using the contents of a byte of memory.
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
    
    ///
    /// This instructions is used to test if one or more bits are set in a target memory location.
    ///
    /// The mask pattern in A is ANDed with the value in memory to set or clear the zero flag, but the result is not kept.
    /// Bits 7 and 6 of the value from memory are copied into the N and V flags.
    ///
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
    
    /// Copies the current contents of the accumulator into the X register and sets the zero and negative flags as appropriate.
    func tax(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        registers.x = registers.a
        updateZeroAndSignFlagsUsing(registers.x)
        return 2
    }
    
    /// Copies the current contents of the accumulator into the Y register and sets the zero and negative flags as appropriate.
    func tay(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        registers.y = registers.a
        updateZeroAndSignFlagsUsing(registers.y)
        return 2
    }
    
    /// Copies the current contents of the X register into the accumulator and sets the zero and negative flags as appropriate.
    func txa(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        registers.a = registers.x
        updateZeroAndSignFlagsUsing(registers.a)
        return 2
    }
    
    /// Copies the current contents of the Y register into the accumulator and sets the zero and negative flags as appropriate.
    func tya(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        registers.a = registers.y
        updateZeroAndSignFlagsUsing(registers.a)
        return 2
    }
    
    /// Adds one to the X register setting the zero and negative flags as appropriate.
    func inx(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        registers.x = registers.x &+ 1
        updateZeroAndSignFlagsUsing(registers.x)
        return 2
    }
    
    /// Adds one to the Y register setting the zero and negative flags as appropriate.
    func iny(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        registers.y = registers.y &+ 1
        updateZeroAndSignFlagsUsing(registers.y)
        return 2
    }
    
    /// Subtracts one from the X register setting the zero and negative flags as appropriate.
    func dex(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        registers.x = registers.x &- 1
        updateZeroAndSignFlagsUsing(registers.x)
        return 2
    }
    
    /// Subtracts one from the Y register setting the zero and negative flags as appropriate.
    func dey(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        registers.y = registers.y &- 1
        updateZeroAndSignFlagsUsing(registers.y)
        return 2
    }
    
    /// Subtracts one from the value held at a specified memory location setting the zero and negative flags as appropriate.
    func dec(_ addressingMode: AddressingMode) -> Int {
        let cycles: Int
        let address: Address
        switch addressingMode {
        case .zeroPage:
            cycles = 5
            address = fetchZeroPageAddress()
        case .zeroPageX:
            cycles = 6
            address = fetchZeroPageXAddress()
        case .absolute:
            cycles = 6
            address = fetchAbsoluteAddress()
        case .absoluteX:
            cycles = 7
            address = fetchAbsoluteXAddress()
        default:
            return 0
        }
        let value = readByte(address)
        writeByte(value &- 1, to: address)
        updateZeroAndSignFlagsUsing(value)
        return cycles
    }
    
    /// Adds one to the value held at a specified memory location setting the zero and negative flags as appropriate.
    func inc(_ addressingMode: AddressingMode) -> Int {
        let cycles: Int
        let address: Address
        switch addressingMode {
        case .zeroPage:
            cycles = 5
            address = fetchZeroPageAddress()
        case .zeroPageX:
            cycles = 6
            address = fetchZeroPageXAddress()
        case .absolute:
            cycles = 6
            address = fetchAbsoluteAddress()
        case .absoluteX:
            cycles = 7
            address = fetchAbsoluteXAddress()
        default:
            return 0
        }
        let value = readByte(address)
        writeByte(value &+ 1, to: address)
        updateZeroAndSignFlagsUsing(value)
        return cycles
    }
    
    // MARK: - branching
    
    // generic helper method for branching purposes
    private func branch(if condition: Bool) -> Int {
        let offsetByte = fetch()
        if condition {
            let originalAddress = registers.pc
            if offsetByte & 0b10000000 > 0 {
                registers.pc -= Address(128 - offsetByte & 0b01111111)
            } else {
                registers.pc += Address(offsetByte & 0b01111111)
            }
            if registers.pc >> 8 != originalAddress >> 8 {
                return 5
            }
            return 3
        }
        return 2
    }
    
    /// If the zero flag is set then add the relative displacement to the program counter to cause a branch to a new location.
    func beq(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .relative else {
            return 0
        }
        return branch(if: registers.zeroFlag)
    }
    
    /// If the zero flag is clear then add the relative displacement to the program counter to cause a branch to a new location.
    func bne(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .relative else {
            return 0
        }
        return branch(if: !registers.zeroFlag)
    }

    func bcs(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .relative else {
            return 0
        }
        return branch(if: registers.carryFlag)
    }
    
    func bcc(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .relative else {
            return 0
        }
        return branch(if: !registers.carryFlag)
    }
    
    func bmi(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .relative else {
            return 0
        }
        return branch(if: registers.signFlag)
    }
    
    func bpl(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .relative else {
            return 0
        }
        return branch(if: !registers.signFlag)
    }
    
    func bvs(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .relative else {
            return 0
        }
        return branch(if: registers.overflowFlag)
    }
    
    func bvc(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .relative else {
            return 0
        }
        return branch(if: !registers.overflowFlag)
    }
    
    // MARK: - status flag changes
    
    func clc(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        registers.carryFlag = false
        return 2
    }
    
    func sec(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        registers.carryFlag = true
        return 2
    }
    
    func cli(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        registers.interruptFlag = false
        return 2
    }
    
    func sei(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        registers.interruptFlag = true
        return 2
    }
    
    func cld(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        registers.decimalFlag = false
        return 2
    }
    
    func sed(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        registers.decimalFlag = true
        return 2
    }
    
    func clv(_ addressingMode: AddressingMode) -> Int {
        guard addressingMode == .implicit else {
            return 0
        }
        registers.overflowFlag = false
        return 2
    }

    /// performs a compare instruction using a given value
    private func performCompare(using register: UInt8, with value: UInt8) {
        let tmp = register &- value
        registers.signFlag = (tmp & 0b10000000) > 0
        registers.zeroFlag = register == value
        registers.carryFlag = register >= value
    }
    
    /// This instruction compares the contents of the accumulator with another memory held value and sets the zero and carry flags as appropriate.
    func cmp(_ addressingMode: AddressingMode) -> Int {
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
        performCompare(using: registers.a, with: value)
        return cycles
    }
    
    func cpx(_ addressingMode: AddressingMode) -> Int {
        var cycles: Int
        let value: Byte
        switch addressingMode {
        case .immediate:
            cycles = 2
            value = fetch()
        case .zeroPage:
            cycles = 3
            value = readByte(fetchZeroPageAddress())
        case .absolute:
            cycles = 4
            value = readByte(fetchAbsoluteAddress())
        default:
            return 0
        }
        performCompare(using: registers.x, with: value)
        return cycles
    }
    
    func cpy(_ addressingMode: AddressingMode) -> Int {
        var cycles: Int
        let value: Byte
        switch addressingMode {
        case .immediate:
            cycles = 2
            value = fetch()
        case .zeroPage:
            cycles = 3
            value = readByte(fetchZeroPageAddress())
        case .absolute:
            cycles = 4
            value = readByte(fetchAbsoluteAddress())
        default:
            return 0
        }
        performCompare(using: registers.y, with: value)
        return cycles
    }
    
    ///
    /// This instruction adds the contents of a memory location to the accumulator together with the carry bit.
    ///
    /// If overflow occurs the carry bit is set, this enables multiple byte addition to be performed.
    ///
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
        let result = UInt16(registers.a) &+ UInt16(value) &+ UInt16(registers.carryFlag ? 1 : 0)
        /// if the result overflows we set a carry flag
        registers.carryFlag = result & 0xFF00 > 0
        // N + N => N & P + P => P
        registers.overflowFlag = (~(UInt16(registers.a) ^ UInt16(value)) & (UInt16(registers.a) ^ result) & UInt16(0b10000000)) > 0
        registers.a = UInt8(result & UInt16(0xFF))
        updateZeroAndSignFlagsUsing(registers.a)
        return cycles
    }

    ///
    /// This instruction subtracts the contents of a memory location to the accumulator together with the not of the carry bit.
    ///
    /// If overflow occurs the carry bit is clear, this enables multiple byte subtraction to be performed.
    ///
    func sbc(_ addressingMode: AddressingMode) -> Int {
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
        /// subtract the value from the accumulator and subtract one more if carry was zero
        let result = UInt16(registers.a) &- UInt16(value) &- UInt16(registers.carryFlag ? 0 : 1)
        /// if result does not overflow we set a carry flag
        registers.carryFlag = result & 0xFF00 == 0
        // N - P => N & P - N => P
        registers.overflowFlag = ((UInt16(registers.a) ^ UInt16(value)) & (UInt16(registers.a) ^ result) & UInt16(0b10000000)) > 0
        registers.a = UInt8(result & UInt16(0xFF))
        updateZeroAndSignFlagsUsing(registers.a)
        return cycles
    }
    
    ///
    /// Performs a logical left shift on a value under a given memory address.
    /// It writes back the result into the same address.
    /// Finally updates zero and sign register flags.
    ///
    private func performASL(on address: Address) {
        let value = readByte(address)
        registers.carryFlag = (value & 0b10000000) > 0
        let newValue = value << 1
        writeByte(newValue, to: address)
        updateZeroAndSignFlagsUsing(newValue)
    }
    
    ///
    /// This operation shifts all the bits of the accumulator or memory contents one bit left.
    /// Bit 0 is set to 0 and bit 7 is placed in the carry flag.
    /// The effect of this operation is to multiply the memory contents by 2 (ignoring 2's complement considerations), setting the carry if the result will not fit in 8 bits.
    ///
    func asl(_ addressingMode: AddressingMode) -> Int {
        var cycles: Int
        switch addressingMode {
        case .accumulator:
            cycles = 2
            registers.carryFlag = (registers.a & 0b10000000) > 0
            registers.a = registers.a << 1
            updateZeroAndSignFlagsUsing(registers.a)
        case .zeroPage:
            cycles = 5
            performASL(on: fetchZeroPageAddress())
        case .zeroPageX:
            cycles = 6
            performASL(on: fetchZeroPageXAddress())
        case .absolute:
            cycles = 6
            performASL(on: fetchAbsoluteAddress())
        case .absoluteX:
            cycles = 7
            performASL(on: fetchAbsoluteXAddress())
        default:
            return 0
        }
        return cycles
    }
    
    ///
    /// Performs a logical right shift on a value under a given memory address.
    /// It writes back the result into the same address.
    /// Finally updates zero and sign register flags.
    ///
    private func performLSR(on address: Address) {
        let value = readByte(address)
        registers.carryFlag = (value & 0b00000001) > 0
        let newValue = value >> 1
        writeByte(newValue, to: address)
        updateZeroAndSignFlagsUsing(newValue)
    }
    
    ///
    /// Each of the bits in A or M is shift one place to the right.
    /// The bit that was in bit 0 is shifted into the carry flag. Bit 7 is set to zero.
    ///
    func lsr(_ addressingMode: AddressingMode) -> Int {
        var cycles: Int
        switch addressingMode {
        case .accumulator:
            cycles = 2
            registers.carryFlag = (registers.a & 0b00000001) > 0
            registers.a = registers.a >> 1
            updateZeroAndSignFlagsUsing(registers.a)
        case .zeroPage:
            cycles = 5
            performLSR(on: fetchZeroPageAddress())
        case .zeroPageX:
            cycles = 6
            performLSR(on: fetchZeroPageXAddress())
        case .absolute:
            cycles = 6
            performLSR(on: fetchAbsoluteAddress())
        case .absoluteX:
            cycles = 7
            performLSR(on: fetchAbsoluteXAddress())
        default:
            return 0
        }
        return cycles
    }
    
    ///
    /// Performs a logical right shift on a value under a given memory address.
    /// It writes back the result into the same address.
    /// Finally updates zero and sign register flags.
    ///
    private func performROL(on address: Address) {
        let value = readByte(address)
        let oldCarryBit = UInt8(registers.carryFlag ? 1 : 0)
        registers.carryFlag = (value & 0b10000000) > 0
        var newValue = value << 1
        newValue = (newValue & 0b11111110) | oldCarryBit
        writeByte(newValue, to: address)
        updateZeroAndSignFlagsUsing(newValue)
    }
    
    func rol(_ addressingMode: AddressingMode) -> Int {
        var cycles: Int
        switch addressingMode {
        case .accumulator:
            cycles = 2
            let oldCarryBit = UInt8(registers.carryFlag ? 1 : 0)
            registers.carryFlag = (registers.a & 0b10000000) > 0
            registers.a = registers.a << 1
            registers.a = (registers.a & 0b11111110) | oldCarryBit
            updateZeroAndSignFlagsUsing(registers.a)
        case .zeroPage:
            cycles = 5
            performROL(on: fetchZeroPageAddress())
        case .zeroPageX:
            cycles = 6
            performROL(on: fetchZeroPageXAddress())
        case .absolute:
            cycles = 6
            performROL(on: fetchAbsoluteAddress())
        case .absoluteX:
            cycles = 7
            performROL(on: fetchAbsoluteXAddress())
        default:
            return 0
        }
        return cycles
    }
    
    ///
    /// Performs a logical right shift on a value under a given memory address.
    /// It writes back the result into the same address.
    /// Finally updates zero and sign register flags.
    ///
    private func performROR(on address: Address) {
        let value = readByte(address)
        let oldCarryBit = UInt8(registers.carryFlag ? 1 : 0)
        registers.carryFlag = (value & 0b00000001) > 0
        var newValue = value >> 1
        newValue = (newValue & 0b01111111) | oldCarryBit << 7
        writeByte(newValue, to: address)
        updateZeroAndSignFlagsUsing(newValue)
    }
    
    func ror(_ addressingMode: AddressingMode) -> Int {
        var cycles: Int
        switch addressingMode {
        case .accumulator:
            cycles = 2
            let oldCarryBit = UInt8(registers.carryFlag ? 1 : 0)
            registers.carryFlag = (registers.a & 0b00000001) > 0
            registers.a = registers.a >> 1
            registers.a = (registers.a & 0b01111111) | oldCarryBit << 7
            updateZeroAndSignFlagsUsing(registers.a)
        case .zeroPage:
            cycles = 5
            performROR(on: fetchZeroPageAddress())
        case .zeroPageX:
            cycles = 6
            performROR(on: fetchZeroPageXAddress())
        case .absolute:
            cycles = 6
            performROR(on: fetchAbsoluteAddress())
        case .absoluteX:
            cycles = 7
            performROR(on: fetchAbsoluteXAddress())
        default:
            return 0
        }
        return cycles
    }
}
