//
//  Cpu.swift
//  SwiftNES
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

    func execute() {
        while totalCycles != 9 {
            let opcodeByte = fetch()
            guard let opcode = opcodes.first(where: { $0.value == opcodeByte }) else {
                return print("Invalid opcode byte `\(opcodeByte.hex)`")
            }
            call(opcode.instruction, opcode.addressingMode)
            
            print(opcode.value.hex, registers, ", ", totalCycles)
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
        let word = Word(bus.readByte(from: address)) + Word(bus.readByte(from: address + 1)) << 8
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
    
  

    
}
