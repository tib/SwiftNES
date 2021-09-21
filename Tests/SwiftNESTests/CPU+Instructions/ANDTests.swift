//
//  ANDTests.swift
//  SwiftNesTests
//
//  Created by Tibor Bodecs on 2021. 09. 12..
//

import XCTest
@testable import SwiftNes

final class ANDTests: XCTestCase {
    
    private func testUnchangedRegisterFlags(_ nes: Nes) {
        XCTAssertFalse(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.interruptFlag)
        XCTAssertFalse(nes.cpu.registers.decimalFlag)
        XCTAssertFalse(nes.cpu.registers.breakFlag)
        XCTAssertFalse(nes.cpu.registers.overflowFlag)
    }
    
    private func checkResults(_ nes: Nes) {
        XCTAssertEqual(nes.cpu.registers.a, 0xCC & 0x84)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
    }
        
    func testImmediate() throws {
        let nes = Nes()
        nes.cpu.registers.a = 0xCC
        nes.memory.storage[0x00] = nes.cpu.opcode(.and, .immediate)
        nes.memory.storage[0x01] = 0x84
        nes.start(cycles: 2)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 2)
    }
    
    func testZeroPage() throws {
        let nes = Nes()
        nes.cpu.registers.a = 0xCC
        nes.memory.storage[0x00] = nes.cpu.opcode(.and, .zeroPage)
        nes.memory.storage[0x01] = 0x42
        nes.memory.storage[0x42] = 0x84
        nes.start(cycles: 3)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 3)
    }
    
    func testZeroPageX() throws {
        let nes = Nes()
        nes.cpu.registers.a = 0xCC
        nes.cpu.registers.x = 5
        nes.memory.storage[0x00] = nes.cpu.opcode(.and, .zeroPageX)
        nes.memory.storage[0x01] = 0x42
        nes.memory.storage[0x47] = 0x84
        nes.start(cycles: 4)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }
    
    func testZeroPageXOverflow () throws {
        let nes = Nes()
        nes.cpu.registers.a = 0xCC
        nes.cpu.registers.x = 0xFF
        nes.memory.storage[0x00] = nes.cpu.opcode(.and, .zeroPageX)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x007F] = 0x84
        nes.start(cycles: 4)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }
    
    func testAbsolute() throws {
        let nes = Nes()
        nes.cpu.registers.a = 0xCC
        nes.memory.storage[0x00] = nes.cpu.opcode(.and, .absolute)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x01
        nes.memory.storage[0x0180] = 0x84
        nes.start(cycles: 4)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }
    
    func testAbsoluteX() throws {
        let nes = Nes()
        nes.cpu.registers.a = 0xCC
        nes.cpu.registers.x = 1
        nes.memory.storage[0x00] = nes.cpu.opcode(.and, .absoluteX)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x01
        nes.memory.storage[0x0181] = 0x84
        nes.start(cycles: 4)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }
    
    func testAbsoluteXBoundary() throws {
        let nes = Nes()
        nes.cpu.registers.a = 0xCC
        nes.cpu.registers.x = 0xFF
        nes.memory.storage[0x00] = nes.cpu.opcode(.and, .absoluteX)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x00
        nes.memory.storage[0x017F] = 0x84
        nes.start(cycles: 5)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 5)
    }
    
    func testAbsoluteY() throws {
        let nes = Nes()
        nes.cpu.registers.a = 0xCC
        nes.cpu.registers.y = 1
        nes.memory.storage[0x00] = nes.cpu.opcode(.and, .absoluteY)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x01
        nes.memory.storage[0x0181] = 0x84
        nes.start(cycles: 4)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }
    
    func testAbsoluteYBoundary() throws {
        let nes = Nes()
        nes.cpu.registers.a = 0xCC
        nes.cpu.registers.y = 0xFF
        nes.memory.storage[0x00] = nes.cpu.opcode(.and, .absoluteY)
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x00
        nes.memory.storage[0x017F] = 0x84
        nes.start(cycles: 5)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 5)
    }
    
    func testIndexedIndirect() throws {
        let nes = Nes()
        nes.cpu.registers.a = 0xCC
        nes.cpu.registers.x = 0x04
        nes.memory.storage[0x00] = nes.cpu.opcode(.and, .indexedIndirect)
        nes.memory.storage[0x01] = 0x02
        nes.memory.storage[0x0006] = 0x80
        nes.memory.storage[0x0007] = 0x01
        nes.memory.storage[0x0180] = 0x84
        nes.start(cycles: 6)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 6)
    }
    
    func testIndirectIndexed() throws {
        let nes = Nes()
        nes.cpu.registers.a = 0xCC
        nes.cpu.registers.y = 0x04
        nes.memory.storage[0x00] = nes.cpu.opcode(.and, .indirectIndexed)
        nes.memory.storage[0x01] = 0x02
        nes.memory.storage[0x0002] = 0x80
        nes.memory.storage[0x0003] = 0x01
        nes.memory.storage[0x0184] = 0x84
        nes.start(cycles: 5)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 5)
    }
    
    func testIndirectIndexedBoundary() throws {
        let nes = Nes()
        nes.cpu.registers.a = 0xCC
        nes.cpu.registers.y = 0xFF
        nes.memory.storage[0x00] = nes.cpu.opcode(.and, .indirectIndexed)
        nes.memory.storage[0x01] = 0x02
        nes.memory.storage[0x0002] = 0x80
        nes.memory.storage[0x0003] = 0x00
        nes.memory.storage[0x017F] = 0x84
        nes.start(cycles: 6)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 6)
    }
    
}
