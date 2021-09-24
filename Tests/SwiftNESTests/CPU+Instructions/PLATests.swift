//
//  PLATests.swift
//  SwiftNesTests
//
//  Created by Tibor Bodecs on 2021. 09. 18..
//

import XCTest
@testable import SwiftNes

final class PLATests: XCTestCase {

    private func testUnchangedRegisterFlags(_ nes: Nes, _ registers: Cpu.Registers) {
        
        XCTAssertEqual(nes.cpu.registers.carryFlag, registers.carryFlag)
        XCTAssertEqual(nes.cpu.registers.interruptFlag, registers.interruptFlag)
        XCTAssertEqual(nes.cpu.registers.decimalFlag, registers.decimalFlag)
        XCTAssertEqual(nes.cpu.registers.breakFlag, registers.breakFlag)
        XCTAssertEqual(nes.cpu.registers.overflowFlag, registers.overflowFlag)
    }
    
    func testImplicit() throws {
        let nes = Nes()
        let registers = nes.cpu.registers
        nes.cpu.registers.a = 0x00
        nes.cpu.registers.sp = 0xFC
        nes.memory.storage[0x01FD] = 0x42
        nes.memory.storage[0x00] = nes.cpu.opcode(.pla, .implicit)

        let cycles = 4
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
        XCTAssertEqual(nes.cpu.registers.a, 0x42)
        XCTAssertEqual(nes.cpu.registers.sp, 0xFD)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes, registers)
    }
    
    func testImplicitZeroFlag() throws {
        let nes = Nes()
        let registers = nes.cpu.registers
        nes.cpu.registers.a = 0x00
        nes.cpu.registers.sp = 0xFC
        nes.memory.storage[0x01FC] = 0x0
        nes.memory.storage[0x00] = nes.cpu.opcode(.pla, .implicit)

        let cycles = 4
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
        XCTAssertEqual(nes.cpu.registers.a, 0x00)
        XCTAssertEqual(nes.cpu.registers.sp, 0xFD)
        XCTAssertTrue(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes, registers)
    }
    
    func testImplicitNegativeFlag() throws {
        let nes = Nes()
        let registers = nes.cpu.registers
        nes.cpu.registers.a = 0x00
        nes.cpu.registers.sp = 0xFC
        nes.memory.storage[0x01FD] = 0b10000000
        nes.memory.storage[0x00] = nes.cpu.opcode(.pla, .implicit)

        let cycles = 4
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
        XCTAssertEqual(nes.cpu.registers.a, 0b10000000)
        XCTAssertEqual(nes.cpu.registers.sp, 0xFD)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes, registers)
    }
}
