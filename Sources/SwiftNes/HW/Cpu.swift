//
//  Cpu.swift
//  SwiftNes
//
//  Created by Tibor Bodecs on 2021. 09. 08..
//

import Foundation

final class Cpu {

    unowned var bus: Bus!

    var registers: Registers
    let frequency: Double = 1_789_773
    var totalCycles: Int

    /// initialize the CPU using a bus, reset all the registers and the cycle count
    init(bus: Bus) {
        self.bus = bus
        self.registers = Registers()
        self.totalCycles = 0
    }
    
    /// resets the CPU internal state & pointers
    func reset() {
        registers.reset()
        totalCycles = 0
    }

    func load(_ program: [UInt8]) -> Address {
        guard program.count > 2 else { fatalError("Couldn't load program.") }
        
        let address = Address(program[0] | program[1] << 8)
       
        for (i, data) in program.dropFirst(2).enumerated() {
            bus.writeByte(data, to: address + Address(i))
        }
        return address
    }

    func execute(cycles: Int) {
        while totalCycles < cycles {
            let opcodeByte = fetch()
            guard let opcode = opcodes.first(where: { $0.value == opcodeByte }) else {
                print("Invalid opcode byte `\(opcodeByte.hex)`")
                return
            }
            call(opcode.instruction, opcode.addressingMode)
            print(opcode, opcode.value.hex, registers, ", ", totalCycles)
        }
    }

    // MARK: - bus operations
    
    /// read a byte from the memory
    ///
    /// This operation costs a single clock cycle
    func readByte(_ address: Address) -> Byte {
        let byte = bus.readByte(from: address)
        totalCycles += 1
        return byte
    }
    
    /// read a word from the memory
    ///
    /// This operation costs two clock cycles
    func readWord(_ address: Address) -> Word {
        let word = Word(bus.readByte(from: address)) | Word(bus.readByte(from: address + 1)) << 8
        totalCycles += 2
        return word
    }
    
    func writeByte(_ data: Byte, to address: Address) {
        bus.writeByte(data, to: address)
        totalCycles += 1
    }
    
    func writeWord(_ data: Word, to address: Address) {
        bus.writeByte(UInt8(data & 0xFF), to: address)
        bus.writeByte(UInt8(data >> 8), to: address + 1)
        totalCycles += 2
    }
    
    /// fetch the current program counter & incremnet the pc register
    ///
    /// This operation costs one clock cycle
    func fetch() -> Byte {
        let byte = readByte(registers.pc)
        registers.pc += 1
        return byte
    }
    
    func fetchWord() -> Word {
        let word = readWord(registers.pc)
        registers.pc += 2
        return word
    }
  
    // MARK: - register status updates
    
    func updateZeroAndSignFlagsUsing(_ value: Byte) {
        registers.zeroFlag = value == 0
        registers.signFlag = (value & 0b10000000) > 0
    }

    // MARK: - stack updates
    
    var spAddress: Address {
        0x0100 | Address(registers.sp)
    }
    
    func pushWordToStack(_ value: Word) {
        writeWord(value, to: spAddress - 1)
        registers.sp -= 2
    }
    
    func pushByteToStack(_ value: Byte) {
        writeByte(value, to: spAddress)
        registers.sp -= 1
    }
    
    func popWordFromStack() -> Address {
        let value = readWord(spAddress + 1)
        registers.sp += 2
        return value
    }
    
    func popByteFromStack() -> Byte {
        let value = readByte(spAddress)
        registers.sp += 1
        return value
    }
}
