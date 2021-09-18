//
//  LDYTests.swift
//  SwiftNesTests
//
//  Created by Tibor Bodecs on 2021. 09. 18..
//

import XCTest
@testable import SwiftNes

final class LDYTests: XCTestCase {
    
    private func testUnchangedRegisterFlags(_ nes: Nes) {
        XCTAssertFalse(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.interruptFlag)
        XCTAssertFalse(nes.cpu.registers.decimalFlag)
        XCTAssertFalse(nes.cpu.registers.breakFlag)
        XCTAssertFalse(nes.cpu.registers.overflowFlag)
    }

    func testImmediate() throws {
        let nes = Nes()
        nes.memory.storage[0x00] = nes.cpu.opcode(.ldy, .immediate)
        nes.memory.storage[0x01] = 0x84
        nes.start(cycles: 2)
        XCTAssertEqual(nes.cpu.registers.y, 0x84)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 2)
    }
    
    func testZeroPage() throws {
        let nes = Nes()
        nes.memory.storage[0x00] = nes.cpu.opcode(.ldy, .zeroPage)
        nes.memory.storage[0x01] = 0x42
        nes.memory.storage[0x42] = 11
        nes.start(cycles: 3)
        XCTAssertEqual(nes.cpu.registers.y, 11)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 3)
    }
    
    func testZeroPageX() throws {
        let nes = Nes()
        nes.cpu.registers.x = 5
        nes.memory.storage[0x00] = nes.cpu.opcode(.ldy, .zeroPageX)
        nes.memory.storage[0x01] = 0x42
        nes.memory.storage[0x47] = 0x37
        nes.start(cycles: 4)
        XCTAssertEqual(nes.cpu.registers.y, 0x37)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }
    
    func testZeroPageXOverflow () throws {
        let nes = Nes()
        nes.cpu.registers.x = 0xFF
        nes.memory.storage[0x00] = nes.cpu.opcode(.ldy, .zeroPageX)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x007F] = 0x37
        nes.start(cycles: 4)
        XCTAssertEqual(nes.cpu.registers.y, 0x37)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }
    
    func testAbsolute() throws {
        let nes = Nes()
        nes.memory.storage[0x00] = nes.cpu.opcode(.ldy, .absolute)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x01
        nes.memory.storage[0x0180] = 0x84
        nes.start(cycles: 4)
        XCTAssertEqual(nes.cpu.registers.y, 0x84)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }
    
    func testAbsoluteX() throws {
        let nes = Nes()
        nes.cpu.registers.x = 1
        nes.memory.storage[0x00] = nes.cpu.opcode(.ldy, .absoluteX)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x01
        nes.memory.storage[0x0181] = 0x84
        nes.start(cycles: 4)
        XCTAssertEqual(nes.cpu.registers.y, 0x84)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }
    
    func testAbsoluteXBoundary() throws {
        let nes = Nes()
        nes.cpu.registers.x = 0xFF
        nes.memory.storage[0x00] = nes.cpu.opcode(.ldy, .absoluteX)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x00
        nes.memory.storage[0x017F] = 0x84
        nes.start(cycles: 5)
        XCTAssertEqual(nes.cpu.registers.y, 0x84)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 5)
    }
}
