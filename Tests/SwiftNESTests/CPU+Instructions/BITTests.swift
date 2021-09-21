//
//  BITTests.swift
//  SwiftNesTests
//
//  Created by Tibor Bodecs on 2021. 09. 12..
//

import XCTest
@testable import SwiftNes

final class BITTests: XCTestCase {
    
    private func testUnchangedRegisterFlags(_ nes: Nes) {
        XCTAssertFalse(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.interruptFlag)
        XCTAssertFalse(nes.cpu.registers.decimalFlag)
        XCTAssertFalse(nes.cpu.registers.breakFlag)
    }

    func testZeroPage() throws {
        let nes = Nes()
        nes.cpu.registers.zeroFlag = false
        nes.cpu.registers.signFlag = false
        nes.cpu.registers.overflowFlag = false
        nes.cpu.registers.a = 0xCC
        nes.memory.storage[0x00] = nes.cpu.opcode(.bit, .zeroPage)
        nes.memory.storage[0x01] = 0x42
        nes.memory.storage[0x42] = 0xCC
        nes.start(cycles: 3)
        XCTAssertTrue(nes.cpu.registers.overflowFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        XCTAssertTrue(nes.cpu.registers.zeroFlag)
        XCTAssertEqual(nes.cpu.registers.a, 0xCC)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 3)
    }
    
    func testZeroPageFalseFlags() throws {
        let nes = Nes()
        nes.cpu.registers.zeroFlag = true
        nes.cpu.registers.signFlag = true
        nes.cpu.registers.overflowFlag = true
        nes.cpu.registers.a = 0xCC
        nes.memory.storage[0x00] = nes.cpu.opcode(.bit, .zeroPage)
        nes.memory.storage[0x01] = 0x42
        nes.memory.storage[0x42] = 0x33
        nes.start(cycles: 3)
        XCTAssertFalse(nes.cpu.registers.overflowFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertEqual(nes.cpu.registers.a, 0xCC)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 3)
    }

    func testAbsolute() throws {
        let nes = Nes()
        nes.cpu.registers.zeroFlag = false
        nes.cpu.registers.signFlag = false
        nes.cpu.registers.overflowFlag = false
        nes.cpu.registers.a = 0xCC
        nes.memory.storage[0x00] = nes.cpu.opcode(.bit, .absolute)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x01
        nes.memory.storage[0x0180] = 0xCC
        nes.start(cycles: 4)
        XCTAssertTrue(nes.cpu.registers.overflowFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        XCTAssertTrue(nes.cpu.registers.zeroFlag)
        XCTAssertEqual(nes.cpu.registers.a, 0xCC)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }
    
    func testAbsoluteFalseFlags() throws {
        let nes = Nes()
        nes.cpu.registers.zeroFlag = true
        nes.cpu.registers.signFlag = false
        nes.cpu.registers.overflowFlag = false
        nes.cpu.registers.a = 0x33
        nes.memory.storage[0x00] = nes.cpu.opcode(.bit, .absolute)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x01
        nes.memory.storage[0x0180] = 0xCC
        nes.start(cycles: 4)
        XCTAssertTrue(nes.cpu.registers.overflowFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertEqual(nes.cpu.registers.a, 0x33)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }
    
    func testAbsoluteFalseFlagsMixed() throws {
        let nes = Nes()
        nes.cpu.registers.signFlag = false
        nes.cpu.registers.overflowFlag = true
        nes.memory.storage[0x00] = nes.cpu.opcode(.bit, .absolute)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x01
        nes.memory.storage[0x0180] = 0b10000000
        nes.start(cycles: 4)
        XCTAssertFalse(nes.cpu.registers.overflowFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }
       
}
