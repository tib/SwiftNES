//
//  JSRTests.swift
//  SwiftNesTests
//
//  Created by Tibor Bodecs on 2021. 09. 18..
//

import XCTest
@testable import SwiftNes

final class JSRTests: XCTestCase {

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
        let sp = nes.cpu.registers.sp
        nes.memory.storage[0x00] = nes.cpu.opcode(.jsr, .absolute)
        nes.memory.storage[0x01] = 0x11
        nes.memory.storage[0x02] = 0x00
        nes.memory.storage[0x0011] = nes.cpu.opcode(.lda, .immediate)
        nes.memory.storage[0x0012] = 0xcf
        
        let cycles = 6 + 2
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 0xcf)
        XCTAssertNotEqual(nes.cpu.registers.sp, sp)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testWithRTSAndRegisters() throws {
        let nes = Nes()
        let registers = nes.cpu.registers
        nes.memory.storage[0x00] = nes.cpu.opcode(.jsr, .absolute)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x00
        nes.memory.storage[0x0080] = nes.cpu.opcode(.rts, .implicit)

        let cycles = 6 + 6
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.sp, registers.sp)
        testUnchangedRegisterFlags(nes, registers)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testWithRTS() throws {
        let nes = Nes()
        let sp = nes.cpu.registers.sp
        nes.memory.storage[0x00] = nes.cpu.opcode(.jsr, .absolute)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x00
        nes.memory.storage[0x0080] = nes.cpu.opcode(.rts, .implicit)
        nes.memory.storage[0x03] = nes.cpu.opcode(.lda, .immediate)
        nes.memory.storage[0x04] = 0x42
        
        let cycles = 6 + 6 + 2
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 0x42)
        XCTAssertEqual(nes.cpu.registers.sp, sp)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
}
