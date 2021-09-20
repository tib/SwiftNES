//
//  JMPTests.swift
//  SwiftNesTests
//
//  Created by Tibor Bodecs on 2021. 09. 18..
//

import XCTest
@testable import SwiftNes

final class JMPTests: XCTestCase {

    private func testUnchangedRegisterFlags(_ nes: Nes, _ registers: Cpu.Registers) {
        XCTAssertEqual(nes.cpu.registers.zeroFlag, registers.zeroFlag)
        XCTAssertEqual(nes.cpu.registers.signFlag, registers.signFlag)
        XCTAssertEqual(nes.cpu.registers.carryFlag, registers.carryFlag)
        XCTAssertEqual(nes.cpu.registers.interruptFlag, registers.interruptFlag)
        XCTAssertEqual(nes.cpu.registers.decimalFlag, registers.decimalFlag)
        XCTAssertEqual(nes.cpu.registers.breakFlag, registers.breakFlag)
        XCTAssertEqual(nes.cpu.registers.overflowFlag, registers.overflowFlag)
    }
    
    func testAbsolute() throws {
        let nes = Nes()
        let registers = nes.cpu.registers
        nes.memory.storage[0x00] = nes.cpu.opcode(.jmp, .absolute)
        nes.memory.storage[0x01] = 0x11
        nes.memory.storage[0x02] = 0x00
        
        let cycles = 3
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
        XCTAssertEqual(nes.cpu.registers.sp, registers.sp)
        XCTAssertEqual(nes.cpu.registers.pc, 0x0011)
        testUnchangedRegisterFlags(nes, registers)
    }
    
    func testIndirect() throws {
        let nes = Nes()
        let registers = nes.cpu.registers
        nes.memory.storage[0x0000] = nes.cpu.opcode(.jmp, .indirect)
        nes.memory.storage[0x0001] = 0x11
        nes.memory.storage[0x0002] = 0x00
        nes.memory.storage[0x0011] = 0x18
        nes.memory.storage[0x0012] = 0x00

        let cycles = 5
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
        XCTAssertEqual(nes.cpu.registers.sp, registers.sp)
        XCTAssertEqual(nes.cpu.registers.pc, 0x0018)
        testUnchangedRegisterFlags(nes, registers)
    }
   
}
