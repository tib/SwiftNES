//
//  ADCTests.swift
//  SwiftNESTests
//
//  Created by Tibor Bodecs on 2021. 09. 14..
//

import XCTest
@testable import SwiftNes

final class ADCTests: XCTestCase {
    
    private func testUnchangedLDARegisterFlags(_ nes: Nes) {
        XCTAssertFalse(nes.cpu.registers.interruptFlag)
        XCTAssertFalse(nes.cpu.registers.decimalFlag)
        XCTAssertFalse(nes.cpu.registers.breakFlag)
    }
    
    func testADCZeroFlag() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 0
        nes.memory.storage[0x0000] = 0x6D
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x01
        nes.memory.storage[0x0180] = 0
        nes.start(cycles: 4)
        XCTAssertEqual(nes.cpu.registers.a, 0)
        XCTAssertTrue(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        XCTAssertFalse(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.overflowFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }
    
    func testADCNegativeFlagPositive() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 0
        nes.memory.storage[0x0000] = 0x6D
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x01
        nes.memory.storage[0x0180] = 1
        nes.start(cycles: 4)
        XCTAssertEqual(nes.cpu.registers.a, 1)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        XCTAssertFalse(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.overflowFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }
    
    func testADCNegativeFlag() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 0
        nes.memory.storage[0x0000] = 0x6D
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x01
        nes.memory.storage[0x0180] = 0b11111111 // -1
        nes.start(cycles: 4)
        XCTAssertEqual(nes.cpu.registers.a, 0b11111111)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        XCTAssertFalse(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.overflowFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }
    
    func testADCCarryFlag() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 0xFF
        nes.memory.storage[0x0000] = 0x6D
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x01
        nes.memory.storage[0x0180] = 1
        nes.start(cycles: 4)
        XCTAssertEqual(nes.cpu.registers.a, 0)
        XCTAssertTrue(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.overflowFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }
    
    func testADCOverflowFlag() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 127
        nes.memory.storage[0x0000] = 0x6D
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x01
        nes.memory.storage[0x0180] = 1
        nes.start(cycles: 4)
        XCTAssertEqual(nes.cpu.registers.a, 128)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        XCTAssertFalse(nes.cpu.registers.carryFlag)
        XCTAssertTrue(nes.cpu.registers.overflowFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }
    
    func testADCOverflowFlagNegative() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 0b10000000 // -128
        nes.memory.storage[0x0000] = 0x6D
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x01
        nes.memory.storage[0x0180] = 0b11111111 // -1
        nes.start(cycles: 4)
        XCTAssertEqual(nes.cpu.registers.a, 0b01111111)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertTrue(nes.cpu.registers.overflowFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }
    
    
}
