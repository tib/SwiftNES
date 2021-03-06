//
//  LDATests.swift
//  SwiftNesTests
//
//  Created by Tibor Bodecs on 2021. 09. 12..
//

import XCTest
@testable import SwiftNes

final class LDATests: XCTestCase {
    
    private func testUnchangedRegisterFlags(_ nes: Nes) {
        XCTAssertFalse(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.interruptFlag)
        XCTAssertFalse(nes.cpu.registers.decimalFlag)
        XCTAssertFalse(nes.cpu.registers.breakFlag)
        XCTAssertFalse(nes.cpu.registers.overflowFlag)
    }
    
    func testZeroFlag() throws {
        let nes = Nes()
        nes.memory.storage[0x00] = nes.cpu.opcode(.lda, .immediate)
        nes.memory.storage[0x01] = 0
        let cycles = 2
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 0)
        XCTAssertTrue(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testImmediate() throws {
        let nes = Nes()
        nes.memory.storage[0x00] = nes.cpu.opcode(.lda, .immediate)
        nes.memory.storage[0x01] = 0x84
        let cycles = 2
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 0x84)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testZeroPage() throws {
        let nes = Nes()
        nes.memory.storage[0x00] = nes.cpu.opcode(.lda, .zeroPage)
        nes.memory.storage[0x01] = 0x42
        nes.memory.storage[0x42] = 11
        let cycles = 3
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 11)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testZeroPageX() throws {
        let nes = Nes()
        nes.cpu.registers.x = 5
        nes.memory.storage[0x00] = nes.cpu.opcode(.lda, .zeroPageX)
        nes.memory.storage[0x01] = 0x42
        nes.memory.storage[0x47] = 0x37
        let cycles = 4
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 0x37)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testZeroPageXOverflow () throws {
        let nes = Nes()
        nes.cpu.registers.x = 0xFF
        nes.memory.storage[0x00] = nes.cpu.opcode(.lda, .zeroPageX)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x007F] = 0x37
        let cycles = 4
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 0x37)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testAbsolute() throws {
        let nes = Nes()
        nes.memory.storage[0x00] = nes.cpu.opcode(.lda, .absolute)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x01
        nes.memory.storage[0x0180] = 0x84
        let cycles = 4
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 0x84)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testAbsoluteX() throws {
        let nes = Nes()
        nes.cpu.registers.x = 1
        nes.memory.storage[0x00] = nes.cpu.opcode(.lda, .absoluteX)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x01
        nes.memory.storage[0x0181] = 0x84
        let cycles = 4
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 0x84)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testAbsoluteXBoundary() throws {
        let nes = Nes()
        nes.cpu.registers.x = 0xFF
        nes.memory.storage[0x00] = nes.cpu.opcode(.lda, .absoluteX)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x00
        nes.memory.storage[0x017F] = 0x84
        let cycles = 5
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 0x84)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testAbsoluteY() throws {
        let nes = Nes()
        nes.cpu.registers.y = 1
        nes.memory.storage[0x00] = nes.cpu.opcode(.lda, .absoluteY)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x01
        nes.memory.storage[0x0181] = 0x84
        let cycles = 4
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 0x84)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testAbsoluteYBoundary() throws {
        let nes = Nes()
        nes.cpu.registers.y = 0xFF
        nes.memory.storage[0x00] = nes.cpu.opcode(.lda, .absoluteY)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x00
        nes.memory.storage[0x017F] = 0x84
        let cycles = 5
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 0x84)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testIndexedIndirect() throws {
        let nes = Nes()
        nes.cpu.registers.x = 0x04
        nes.memory.storage[0x00] = nes.cpu.opcode(.lda, .indexedIndirect)
        nes.memory.storage[0x01] = 0x02
        nes.memory.storage[0x0006] = 0x80
        nes.memory.storage[0x0007] = 0x01
        nes.memory.storage[0x0180] = 0x84
        let cycles = 6
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 0x84)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testIndirectIndexed() throws {
        let nes = Nes()
        nes.cpu.registers.y = 0x04
        nes.memory.storage[0x00] = nes.cpu.opcode(.lda, .indirectIndexed)
        nes.memory.storage[0x01] = 0x02
        nes.memory.storage[0x0002] = 0x80
        nes.memory.storage[0x0003] = 0x01
        nes.memory.storage[0x0184] = 0x84
        let cycles = 5
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 0x84)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testIndirectIndexedBoundary() throws {
        let nes = Nes()
        nes.cpu.registers.y = 0xFF
        nes.memory.storage[0x00] = nes.cpu.opcode(.lda, .indirectIndexed)
        nes.memory.storage[0x01] = 0x02
        nes.memory.storage[0x0002] = 0x80
        nes.memory.storage[0x0003] = 0x00
        nes.memory.storage[0x017F] = 0x84
        let cycles = 6
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 0x84)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
}
