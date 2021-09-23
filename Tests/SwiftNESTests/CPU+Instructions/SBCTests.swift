//
//  SBCTests.swift
//  SwiftNESTests
//
//  Created by Tibor Bodecs on 2021. 09. 14..
//

import XCTest
@testable import SwiftNes

final class SBCTests: XCTestCase {
    
    private func testUnchangedRegisterFlags(_ nes: Nes) {
        XCTAssertFalse(nes.cpu.registers.interruptFlag)
        XCTAssertFalse(nes.cpu.registers.decimalFlag)
        XCTAssertFalse(nes.cpu.registers.breakFlag)
    }

    
    // MARK: - test using absolute addressing mode
    
    func testZero() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = true
        nes.cpu.registers.a = 0
        nes.memory.storage[0x0000] = nes.cpu.opcode(.sbc, .absolute)
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x01
        nes.memory.storage[0x0180] = 0
        let cycles = 4
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 0)
        XCTAssertTrue(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.overflowFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testZeroWithCarry() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 0
        nes.memory.storage[0x0000] = nes.cpu.opcode(.sbc, .absolute)
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x01
        nes.memory.storage[0x0180] = 0
        let cycles = 4
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 0b11111111)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        XCTAssertFalse(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.overflowFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testNegative() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = true
        nes.cpu.registers.a = 0
        nes.memory.storage[0x0000] = nes.cpu.opcode(.sbc, .absolute)
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x01
        nes.memory.storage[0x0180] = 1
        let cycles = 4
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 0b11111111)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        XCTAssertFalse(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.overflowFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }

    func testNegativeWithCarry() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 0
        nes.memory.storage[0x0000] = nes.cpu.opcode(.sbc, .absolute)
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x01
        nes.memory.storage[0x0180] = 1
        let cycles = 4
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 0b11111110)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        XCTAssertFalse(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.overflowFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }

    func testNegativeAndPositive() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = true
        nes.cpu.registers.a = 0b10000000 // -128
        nes.memory.storage[0x0000] = nes.cpu.opcode(.sbc, .absolute)
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x01
        nes.memory.storage[0x0180] = 1
        let cycles = 4
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 127)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertTrue(nes.cpu.registers.overflowFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }

    func testNegatives() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = true
        nes.cpu.registers.a = 127
        nes.memory.storage[0x0000] = nes.cpu.opcode(.sbc, .absolute)
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x01
        nes.memory.storage[0x0180] = 0b11111111 // -1
        let cycles = 4
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 0b10000000) // -128
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        XCTAssertFalse(nes.cpu.registers.carryFlag)
        XCTAssertTrue(nes.cpu.registers.overflowFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }

    // MARK: - test other addressing modes

    private func checkResults(_ nes: Nes) {
        XCTAssertEqual(nes.cpu.registers.a, 36)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.overflowFlag)
        testUnchangedRegisterFlags(nes)
    }

    func testZeroPageAddressingMode() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = true
        nes.cpu.registers.a = 42
        nes.memory.storage[0x0000] = nes.cpu.opcode(.sbc, .zeroPage)
        nes.memory.storage[0x0001] = 0x42
        nes.memory.storage[0x0042] = 6
        let cycles = 3
        nes.start(cycles: cycles)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }

    func testZeroPageXAddressingMode() throws {
        let nes = Nes()
        nes.cpu.registers.x = 5
        nes.cpu.registers.carryFlag = true
        nes.cpu.registers.a = 42
        nes.memory.storage[0x0000] = nes.cpu.opcode(.sbc, .zeroPageX)
        nes.memory.storage[0x0001] = 0x42
        nes.memory.storage[0x0047] = 6
        let cycles = 4
        nes.start(cycles: cycles)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }

    func testAbsoluteXAddressingMode() throws {
        let nes = Nes()
        nes.cpu.registers.x = 1
        nes.cpu.registers.carryFlag = true
        nes.cpu.registers.a = 42
        nes.memory.storage[0x0000] = nes.cpu.opcode(.sbc, .absoluteX)
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x01
        nes.memory.storage[0x0181] = 6
        let cycles = 4
        nes.start(cycles: cycles)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }

    func testAbsoluteXBoundary() throws {
        let nes = Nes()
        nes.cpu.registers.x = 0xFF
        nes.cpu.registers.carryFlag = true
        nes.cpu.registers.a = 42
        nes.memory.storage[0x0000] = nes.cpu.opcode(.sbc, .absoluteX)
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x00
        nes.memory.storage[0x017F] = 6
        let cycles = 5
        nes.start(cycles: cycles)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }

    func testAbsoluteYAddressingMode() throws {
        let nes = Nes()
        nes.cpu.registers.y = 1
        nes.cpu.registers.carryFlag = true
        nes.cpu.registers.a = 42
        nes.memory.storage[0x0000] = nes.cpu.opcode(.sbc, .absoluteY)
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x01
        nes.memory.storage[0x0181] = 6
        let cycles = 4
        nes.start(cycles: cycles)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }

    func testAbsoluteYBoundary() throws {
        let nes = Nes()
        nes.cpu.registers.y = 0xFF
        nes.cpu.registers.carryFlag = true
        nes.cpu.registers.a = 42
        nes.memory.storage[0x0000] = nes.cpu.opcode(.sbc, .absoluteY)
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x00
        nes.memory.storage[0x017F] = 6
        let cycles = 5
        nes.start(cycles: cycles)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }


    func testIndexedIndirectAddressingMode() throws {
        let nes = Nes()
        nes.cpu.registers.x = 0x04
        nes.cpu.registers.carryFlag = true
        nes.cpu.registers.a = 42
        nes.memory.storage[0x0000] = nes.cpu.opcode(.sbc, .indexedIndirect)
        nes.memory.storage[0x0001] = 0x02
        nes.memory.storage[0x0006] = 0x80
        nes.memory.storage[0x0007] = 0x01
        nes.memory.storage[0x0180] = 6
        let cycles = 6
        nes.start(cycles: cycles)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }

    func testIndirectIndexedAddressingMode() throws {
        let nes = Nes()
        nes.cpu.registers.y = 0x04
        nes.cpu.registers.carryFlag = true
        nes.cpu.registers.a = 42
        nes.memory.storage[0x0000] = nes.cpu.opcode(.sbc, .indirectIndexed)
        nes.memory.storage[0x0001] = 0x02
        nes.memory.storage[0x0002] = 0x80
        nes.memory.storage[0x0003] = 0x01
        nes.memory.storage[0x0184] = 6
        let cycles = 5
        nes.start(cycles: cycles)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }

    func testIndirectIndexedBoundary() throws {
        let nes = Nes()
        nes.cpu.registers.y = 0xFF
        nes.cpu.registers.carryFlag = true
        nes.cpu.registers.a = 42
        nes.memory.storage[0x0000] = nes.cpu.opcode(.sbc, .indirectIndexed)
        nes.memory.storage[0x0001] = 0x02
        nes.memory.storage[0x0002] = 0x80
        nes.memory.storage[0x0003] = 0x00
        nes.memory.storage[0x017F] = 6
        let cycles = 6
        nes.start(cycles: cycles)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
}
