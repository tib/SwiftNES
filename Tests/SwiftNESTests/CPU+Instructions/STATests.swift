//
//  STATests.swift
//  SwiftNesTests
//
//  Created by Tibor Bodecs on 2021. 09. 18..
//

import XCTest
@testable import SwiftNes

final class STATests: XCTestCase {
    
    private func testUnchangedRegisterFlags(_ nes: Nes, _ registers: Cpu.Registers) {
        XCTAssertEqual(nes.cpu.registers.zeroFlag, registers.zeroFlag)
        XCTAssertEqual(nes.cpu.registers.signFlag, registers.signFlag)
        XCTAssertEqual(nes.cpu.registers.carryFlag, registers.carryFlag)
        XCTAssertEqual(nes.cpu.registers.interruptFlag, registers.interruptFlag)
        XCTAssertEqual(nes.cpu.registers.decimalFlag, registers.decimalFlag)
        XCTAssertEqual(nes.cpu.registers.breakFlag, registers.breakFlag)
        XCTAssertEqual(nes.cpu.registers.overflowFlag, registers.overflowFlag)
    }

    func testZeroPage() throws {
        let nes = Nes()
        let registers = nes.cpu.registers
        nes.cpu.registers.a = 0x2F
        nes.memory.storage[0x00] = nes.cpu.opcode(.sta, .zeroPage)
        nes.memory.storage[0x01] = 0x42
        nes.start(cycles: 3)
        XCTAssertEqual(nes.memory.storage[0x42], 0x2F)
        testUnchangedRegisterFlags(nes, registers)
        XCTAssertEqual(nes.cpu.totalCycles, 3)
    }

    func testZeroPageX() throws {
        let nes = Nes()
        let registers = nes.cpu.registers
        nes.cpu.registers.a = 0x2F
        nes.cpu.registers.x = 5
        nes.memory.storage[0x00] = nes.cpu.opcode(.sta, .zeroPageX)
        nes.memory.storage[0x01] = 0x42
        nes.start(cycles: 4)
        XCTAssertEqual(nes.memory.storage[0x47], 0x2F)
        testUnchangedRegisterFlags(nes, registers)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }

    func testZeroPageXOverflow () throws {
        let nes = Nes()
        let registers = nes.cpu.registers
        nes.cpu.registers.a = 0x2F
        nes.cpu.registers.x = 0xFF
        nes.memory.storage[0x00] = nes.cpu.opcode(.sta, .zeroPageX)
        nes.memory.storage[0x01] = 0x80
        nes.start(cycles: 4)
        XCTAssertEqual(nes.memory.storage[0x007F], 0x2F)
        testUnchangedRegisterFlags(nes, registers)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }

    func testAbsolute() throws {
        let nes = Nes()
        let registers = nes.cpu.registers
        nes.cpu.registers.a = 0x2F
        nes.memory.storage[0x00] = nes.cpu.opcode(.sta, .absolute)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x01
        nes.start(cycles: 4)
        XCTAssertEqual(nes.memory.storage[0x0180], 0x2F)
        testUnchangedRegisterFlags(nes, registers)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }

    func testAbsoluteX() throws {
        let nes = Nes()
        let registers = nes.cpu.registers
        nes.cpu.registers.a = 0x2F
        nes.cpu.registers.x = 1
        nes.memory.storage[0x00] = nes.cpu.opcode(.sta, .absoluteX)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x01
        nes.start(cycles: 5)
        XCTAssertEqual(nes.memory.storage[0x0181], 0x2F)
        testUnchangedRegisterFlags(nes, registers)
        XCTAssertEqual(nes.cpu.totalCycles, 5)
    }

    func testAbsoluteXBoundary() throws {
        let nes = Nes()
        let registers = nes.cpu.registers
        nes.cpu.registers.a = 0x2F
        nes.cpu.registers.x = 0xFF
        nes.memory.storage[0x00] = nes.cpu.opcode(.sta, .absoluteX)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x00
        nes.start(cycles: 5)
        XCTAssertEqual(nes.memory.storage[0x017F], 0x2F)
        testUnchangedRegisterFlags(nes, registers)
        XCTAssertEqual(nes.cpu.totalCycles, 5)
    }

    func testAbsoluteY() throws {
        let nes = Nes()
        let registers = nes.cpu.registers
        nes.cpu.registers.a = 0x2F
        nes.cpu.registers.y = 1
        nes.memory.storage[0x00] = nes.cpu.opcode(.sta, .absoluteY)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x01
        nes.start(cycles: 5)
        XCTAssertEqual(nes.memory.storage[0x0181], 0x2F)
        testUnchangedRegisterFlags(nes, registers)
        XCTAssertEqual(nes.cpu.totalCycles, 5)
    }

    func testAbsoluteYBoundary() throws {
        let nes = Nes()
        let registers = nes.cpu.registers
        nes.cpu.registers.a = 0x2F
        nes.cpu.registers.y = 0xFF
        nes.memory.storage[0x00] = nes.cpu.opcode(.sta, .absoluteY)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x00
        nes.start(cycles: 5)
        XCTAssertEqual(nes.memory.storage[0x017F], 0x2F)
        testUnchangedRegisterFlags(nes, registers)
        XCTAssertEqual(nes.cpu.totalCycles, 5)
    }

    func testIndexedIndirect() throws {
        let nes = Nes()
        let registers = nes.cpu.registers
        nes.cpu.registers.a = 0x2F
        nes.cpu.registers.x = 0x04
        nes.memory.storage[0x00] = nes.cpu.opcode(.sta, .indexedIndirect)
        nes.memory.storage[0x01] = 0x02
        nes.memory.storage[0x0006] = 0x80
        nes.memory.storage[0x0007] = 0x01
        nes.start(cycles: 6)
        XCTAssertEqual(nes.memory.storage[0x0180], 0x2F)
        testUnchangedRegisterFlags(nes, registers)
        XCTAssertEqual(nes.cpu.totalCycles, 6)
    }

    func testIndirectIndexed() throws {
        let nes = Nes()
        let registers = nes.cpu.registers
        nes.cpu.registers.a = 0x2F
        nes.cpu.registers.y = 0x04
        nes.memory.storage[0x00] = nes.cpu.opcode(.sta, .indirectIndexed)
        nes.memory.storage[0x01] = 0x02
        nes.memory.storage[0x0002] = 0x80
        nes.memory.storage[0x0003] = 0x01
        nes.start(cycles: 6)
        XCTAssertEqual(nes.memory.storage[0x0184], 0x2F)
        testUnchangedRegisterFlags(nes, registers)
        XCTAssertEqual(nes.cpu.totalCycles, 6)
    }

    func testIndirectIndexedBoundary() throws {
        let nes = Nes()
        let registers = nes.cpu.registers
        nes.cpu.registers.a = 0x2F
        nes.cpu.registers.y = 0xFF
        nes.memory.storage[0x00] = nes.cpu.opcode(.sta, .indirectIndexed)
        nes.memory.storage[0x01] = 0x02
        nes.memory.storage[0x0002] = 0x80
        nes.memory.storage[0x0003] = 0x00
        nes.start(cycles: 6)
        XCTAssertEqual(nes.memory.storage[0x017F], 0x2F)
        testUnchangedRegisterFlags(nes, registers)
        XCTAssertEqual(nes.cpu.totalCycles, 6)
    }
}
