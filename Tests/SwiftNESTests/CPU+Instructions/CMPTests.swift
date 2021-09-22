//
//  CMPTests.swift
//  SwiftNesTests
//
//  Created by Tibor Bodecs on 2021. 09. 12..
//

import XCTest
@testable import SwiftNes

final class CMPTests: XCTestCase {
    
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
        nes.cpu.registers.a = 26
        nes.memory.storage[0x00] = nes.cpu.opcode(.cmp, .immediate)
        nes.memory.storage[0x01] = 26
        let cycles = 2
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 26)
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
        nes.cpu.registers.a = 48
        nes.memory.storage[0x00] = nes.cpu.opcode(.cmp, .zeroPage)
        nes.memory.storage[0x01] = 0x42
        nes.memory.storage[0x42] = 26
        let cycles = 3
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 48)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }

    func testZeroPageX() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.zeroFlag = true
        nes.cpu.registers.signFlag = true
        nes.cpu.registers.a = 130
        nes.cpu.registers.x = 5
        nes.memory.storage[0x00] = nes.cpu.opcode(.cmp, .zeroPageX)
        nes.memory.storage[0x01] = 0x42
        nes.memory.storage[0x47] = 26
        let cycles = 4
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 130)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }

    func testZeroPageXOverflow () throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = true
        nes.cpu.registers.zeroFlag = true
        nes.cpu.registers.signFlag = false
        nes.cpu.registers.a = 8
        nes.cpu.registers.x = 0xFF
        nes.memory.storage[0x00] = nes.cpu.opcode(.cmp, .zeroPageX)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x007F] = 26
        let cycles = 4
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 8)
        XCTAssertFalse(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }

    func testAbsolute() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.zeroFlag = true
        nes.cpu.registers.signFlag = true
        nes.cpu.registers.a = 48
        nes.memory.storage[0x00] = nes.cpu.opcode(.cmp, .absolute)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x01
        nes.memory.storage[0x0180] = 26
        let cycles = 4
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 48)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }

    func testAbsoluteX() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.zeroFlag = true
        nes.cpu.registers.signFlag = true
        nes.cpu.registers.a = 48
        nes.cpu.registers.x = 1
        nes.memory.storage[0x00] = nes.cpu.opcode(.cmp, .absoluteX)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x01
        nes.memory.storage[0x0181] = 26
        let cycles = 4
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 48)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }

    func testAbsoluteXBoundary() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.zeroFlag = true
        nes.cpu.registers.signFlag = true
        nes.cpu.registers.a = 48
        nes.cpu.registers.x = 0xFF
        nes.memory.storage[0x00] = nes.cpu.opcode(.cmp, .absoluteX)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x00
        nes.memory.storage[0x017F] = 26
        let cycles = 5
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 48)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }

    func testAbsoluteY() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.zeroFlag = true
        nes.cpu.registers.signFlag = true
        nes.cpu.registers.a = 48
        nes.cpu.registers.y = 1
        nes.memory.storage[0x00] = nes.cpu.opcode(.cmp, .absoluteY)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x01
        nes.memory.storage[0x0181] = 26
        let cycles = 4
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 48)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }

    func testAbsoluteYBoundary() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.zeroFlag = true
        nes.cpu.registers.signFlag = true
        nes.cpu.registers.a = 48
        nes.cpu.registers.y = 0xFF
        nes.memory.storage[0x00] = nes.cpu.opcode(.cmp, .absoluteY)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x00
        nes.memory.storage[0x017F] = 26
        let cycles = 5
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 48)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }

    func testIndexedIndirect() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.zeroFlag = true
        nes.cpu.registers.signFlag = true
        nes.cpu.registers.a = 48
        nes.cpu.registers.x = 0x04
        nes.memory.storage[0x00] = nes.cpu.opcode(.cmp, .indexedIndirect)
        nes.memory.storage[0x01] = 0x02
        nes.memory.storage[0x0006] = 0x80
        nes.memory.storage[0x0007] = 0x01
        nes.memory.storage[0x0180] = 26
        let cycles = 6
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 48)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }

    func testIndirectIndexed() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.zeroFlag = true
        nes.cpu.registers.signFlag = true
        nes.cpu.registers.a = 48
        nes.cpu.registers.y = 0x04
        nes.memory.storage[0x00] = nes.cpu.opcode(.cmp, .indirectIndexed)
        nes.memory.storage[0x01] = 0x02
        nes.memory.storage[0x0002] = 0x80
        nes.memory.storage[0x0003] = 0x01
        nes.memory.storage[0x0184] = 26
        let cycles = 5
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 48)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }

    func testIndirectIndexedBoundary() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.zeroFlag = true
        nes.cpu.registers.signFlag = true
        nes.cpu.registers.a = 48
        nes.cpu.registers.y = 0xFF
        nes.memory.storage[0x00] = nes.cpu.opcode(.cmp, .indirectIndexed)
        nes.memory.storage[0x01] = 0x02
        nes.memory.storage[0x0002] = 0x80
        nes.memory.storage[0x0003] = 0x00
        nes.memory.storage[0x017F] = 26
        let cycles = 6
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 48)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }

}
