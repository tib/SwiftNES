//
//  CPYTests.swift
//  SwiftNesTests
//
//  Created by Tibor Bodecs on 2021. 09. 12..
//

import XCTest
@testable import SwiftNes

final class CPYTests: XCTestCase {
    
    private func testUnchangedRegisterFlags(_ nes: Nes) {
        XCTAssertFalse(nes.cpu.registers.interruptFlag)
        XCTAssertFalse(nes.cpu.registers.decimalFlag)
        XCTAssertFalse(nes.cpu.registers.breakFlag)
        XCTAssertFalse(nes.cpu.registers.overflowFlag)
    }

    func testImmediate() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.zeroFlag = false
        nes.cpu.registers.signFlag = true
        nes.cpu.registers.y = 26
        nes.memory.storage[0x00] = nes.cpu.opcode(.cpy, .immediate)
        nes.memory.storage[0x01] = 26
        let cycles = 2
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.y, 26)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertTrue(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }

    func testZeroPage() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.zeroFlag = true
        nes.cpu.registers.signFlag = true
        nes.cpu.registers.y = 48
        nes.memory.storage[0x00] = nes.cpu.opcode(.cpy, .zeroPage)
        nes.memory.storage[0x01] = 0x42
        nes.memory.storage[0x42] = 26
        let cycles = 3
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.y, 48)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }

    func testAbsolute() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = true
        nes.cpu.registers.zeroFlag = true
        nes.cpu.registers.signFlag = false
        nes.cpu.registers.y = 8
        nes.memory.storage[0x00] = nes.cpu.opcode(.cpy, .absolute)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x01
        nes.memory.storage[0x0180] = 26
        let cycles = 4
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.y, 8)
        XCTAssertFalse(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }

}
