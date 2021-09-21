//
//  INCTests.swift
//  SwiftNesTests
//
//  Created by Tibor Bodecs on 2021. 09. 18..
//

import XCTest
@testable import SwiftNes

final class INCTests: XCTestCase {
    
    private func testUnchangedRegisterFlags(_ nes: Nes, _ registers: Cpu.Registers) {
        XCTAssertEqual(nes.cpu.registers.carryFlag, registers.carryFlag)
        XCTAssertEqual(nes.cpu.registers.interruptFlag, registers.interruptFlag)
        XCTAssertEqual(nes.cpu.registers.decimalFlag, registers.decimalFlag)
        XCTAssertEqual(nes.cpu.registers.breakFlag, registers.breakFlag)
        XCTAssertEqual(nes.cpu.registers.overflowFlag, registers.overflowFlag)
    }

    func testZeroPage() throws {
        let nes = Nes()
        let registers = nes.cpu.registers
        nes.cpu.registers.zeroFlag = true
        nes.cpu.registers.signFlag = true
        nes.memory.storage[0x00] = nes.cpu.opcode(.inc, .zeroPage)
        nes.memory.storage[0x01] = 0x42
        nes.memory.storage[0x42] = 0x57
        let cycles = 5
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.memory.storage[0x42], 0x58)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes, registers)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testZeroPageX() throws {
        let nes = Nes()
        let registers = nes.cpu.registers
        nes.cpu.registers.x = 0x1
        nes.cpu.registers.zeroFlag = true
        nes.cpu.registers.signFlag = true
        nes.memory.storage[0x00] = nes.cpu.opcode(.inc, .zeroPageX)
        nes.memory.storage[0x01] = 0x42
        nes.memory.storage[0x43] = 0x57
        let cycles = 6
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.memory.storage[0x43], 0x58)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes, registers)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testAbsolute() throws {
        let nes = Nes()
        let registers = nes.cpu.registers
        nes.cpu.registers.zeroFlag = true
        nes.cpu.registers.signFlag = true
        nes.memory.storage[0x00] = nes.cpu.opcode(.inc, .absolute)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x01
        nes.memory.storage[0x0180] = 0x57
        let cycles = 6
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.memory.storage[0x0180], 0x58)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes, registers)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testAbsoluteX() throws {
        let nes = Nes()
        let registers = nes.cpu.registers
        nes.cpu.registers.x = 0x1
        nes.cpu.registers.zeroFlag = true
        nes.cpu.registers.signFlag = true
        nes.memory.storage[0x00] = nes.cpu.opcode(.inc, .absoluteX)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x01
        nes.memory.storage[0x0181] = 0x57
        let cycles = 7
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.memory.storage[0x0181], 0x58)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes, registers)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
}
