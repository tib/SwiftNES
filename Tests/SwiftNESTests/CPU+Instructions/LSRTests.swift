//
//  LSRTests.swift
//  SwiftNesTests
//
//  Created by Tibor Bodecs on 2021. 09. 12..
//

import XCTest
@testable import SwiftNes

final class LSRTests: XCTestCase {
    
    private func testUnchangedRegisterFlags(_ nes: Nes) {
        XCTAssertFalse(nes.cpu.registers.overflowFlag)
        XCTAssertFalse(nes.cpu.registers.interruptFlag)
        XCTAssertFalse(nes.cpu.registers.decimalFlag)
        XCTAssertFalse(nes.cpu.registers.breakFlag)
    }
    
    func testAccumulatorZero() throws {
        let nes = Nes()
        nes.cpu.registers.a = 1
        nes.memory.storage[0x00] = nes.cpu.opcode(.lsr, .accumulator)
        let cycles = 2
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 0)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertTrue(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testAccumulator() throws {
        let nes = Nes()
        nes.cpu.registers.a = 16
        nes.memory.storage[0x00] = nes.cpu.opcode(.lsr, .accumulator)
        let cycles = 2
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 8)
        XCTAssertFalse(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testNegative() throws {
        let nes = Nes()
        nes.cpu.registers.a = 0b10110010
        nes.memory.storage[0x00] = nes.cpu.opcode(.lsr, .accumulator)
        let cycles = 2
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 0b01011001)
        XCTAssertFalse(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
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
        nes.memory.storage[0x00] = nes.cpu.opcode(.lsr, .zeroPage)
        nes.memory.storage[0x01] = 0x42
        nes.memory.storage[0x42] = 16
        let cycles = 5
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.memory.storage[0x42], 8)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }

    func testZeroPageX() throws {
        let nes = Nes()
        nes.cpu.registers.a = 1
        nes.cpu.registers.x = 5
        nes.memory.storage[0x00] = nes.cpu.opcode(.lsr, .zeroPageX)
        nes.memory.storage[0x01] = 0x42
        nes.memory.storage[0x47] = 16
        let cycles = 6
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.x, 5)
        XCTAssertEqual(nes.memory.storage[0x47], 8)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }

    func testAbsolute() throws {
        let nes = Nes()
        nes.cpu.registers.a = 1
        nes.memory.storage[0x00] = nes.cpu.opcode(.lsr, .absolute)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x01
        nes.memory.storage[0x0180] = 16
        let cycles = 6
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.memory.storage[0x180], 8)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }

    func testAbsoluteX() throws {
        let nes = Nes()
        nes.cpu.registers.a = 1
        nes.cpu.registers.x = 1
        nes.memory.storage[0x00] = nes.cpu.opcode(.lsr, .absoluteX)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x01
        nes.memory.storage[0x0181] = 16
        let cycles = 7
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.x, 1)
        XCTAssertEqual(nes.memory.storage[0x0181], 8)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
}
