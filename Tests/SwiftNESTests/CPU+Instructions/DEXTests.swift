//
//  DEXTests.swift
//  SwiftNesTests
//
//  Created by Tibor Bodecs on 2021. 09. 18..
//

import XCTest
@testable import SwiftNes

final class DEXTests: XCTestCase {
    
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
        nes.cpu.registers.x = 0x0
        nes.cpu.registers.zeroFlag = true
        nes.cpu.registers.signFlag = false
        nes.memory.storage[0x00] = nes.cpu.opcode(.dex, .implicit)
        nes.start(cycles: 2)
        XCTAssertEqual(nes.cpu.registers.x, 0xFF)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes, registers)
        XCTAssertEqual(nes.cpu.totalCycles, 2)
    }
    
    func testImplicitZero() throws {
        let nes = Nes()
        let registers = nes.cpu.registers
        nes.cpu.registers.x = 0x01
        nes.cpu.registers.zeroFlag = false
        nes.cpu.registers.signFlag = true
        nes.memory.storage[0x00] = nes.cpu.opcode(.dex, .implicit)
        nes.start(cycles: 2)
        XCTAssertEqual(nes.cpu.registers.x, 0x0)
        XCTAssertTrue(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes, registers)
        XCTAssertEqual(nes.cpu.totalCycles, 2)
    }
    
    func testImplicitNegative() throws {
        let nes = Nes()
        let registers = nes.cpu.registers
        nes.cpu.registers.x = 0b10001001
        nes.cpu.registers.zeroFlag = true
        nes.cpu.registers.signFlag = false
        nes.memory.storage[0x00] = nes.cpu.opcode(.dex, .implicit)
        nes.start(cycles: 2)
        XCTAssertEqual(nes.cpu.registers.x, 0b10001000)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes, registers)
        XCTAssertEqual(nes.cpu.totalCycles, 2)
    }
}
