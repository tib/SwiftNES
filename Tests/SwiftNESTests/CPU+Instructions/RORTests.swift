//
//  RORTests.swift
//  SwiftNesTests
//
//  Created by Tibor Bodecs on 2021. 09. 12..
//

import XCTest
@testable import SwiftNes

final class RORTests: XCTestCase {
    
    private func testUnchangedRegisterFlags(_ nes: Nes) {
        XCTAssertFalse(nes.cpu.registers.interruptFlag)
        XCTAssertFalse(nes.cpu.registers.decimalFlag)
        XCTAssertFalse(nes.cpu.registers.breakFlag)
        XCTAssertFalse(nes.cpu.registers.overflowFlag)
    }
    
    func testAccumulatorZeroWithCarry() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = true
        nes.cpu.registers.a = 0
        nes.memory.storage[0x00] = nes.cpu.opcode(.ror, .accumulator)
        let cycles = 2
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 0b10000000)
        XCTAssertFalse(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testAccumulatorZero() throws {
        let nes = Nes()
        nes.cpu.registers.a = 0
        nes.memory.storage[0x00] = nes.cpu.opcode(.ror, .accumulator)
        let cycles = 2
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 0)
        XCTAssertFalse(nes.cpu.registers.carryFlag)
        XCTAssertTrue(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testAccumulator() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 1
        nes.memory.storage[0x00] = nes.cpu.opcode(.ror, .accumulator)
        let cycles = 2
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 0)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertTrue(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testAccumulatorNegative() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = true
        nes.cpu.registers.a = 1
        nes.memory.storage[0x00] = nes.cpu.opcode(.ror, .accumulator)
        let cycles = 2
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 0b10000000)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }

    private func checkResults(_ nes: Nes) {
        XCTAssertEqual(nes.cpu.registers.a, 1)
        XCTAssertFalse(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
    }
    
    func testZeroPage() throws {
        let nes = Nes()
        nes.cpu.registers.a = 1
        nes.memory.storage[0x00] = nes.cpu.opcode(.ror, .zeroPage)
        nes.memory.storage[0x01] = 0x42
        nes.memory.storage[0x42] = 2
        let cycles = 5
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.memory.storage[0x42], 1)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }

    func testZeroPageX() throws {
        let nes = Nes()
        nes.cpu.registers.a = 1
        nes.cpu.registers.x = 5
        nes.memory.storage[0x00] = nes.cpu.opcode(.ror, .zeroPageX)
        nes.memory.storage[0x01] = 0x42
        nes.memory.storage[0x47] = 2
        let cycles = 6
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.x, 5)
        XCTAssertEqual(nes.memory.storage[0x47], 1)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }

    func testAbsolute() throws {
        let nes = Nes()
        nes.cpu.registers.a = 1
        nes.memory.storage[0x00] = nes.cpu.opcode(.ror, .absolute)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x01
        nes.memory.storage[0x0180] = 2
        let cycles = 6
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.memory.storage[0x180], 1)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }

    func testAbsoluteX() throws {
        let nes = Nes()
        nes.cpu.registers.a = 1
        nes.cpu.registers.x = 1
        nes.memory.storage[0x00] = nes.cpu.opcode(.ror, .absoluteX)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x01
        nes.memory.storage[0x0181] = 2
        let cycles = 7
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.x, 1)
        XCTAssertEqual(nes.memory.storage[0x0181], 1)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
}
