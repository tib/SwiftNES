//
//  LDATests.swift
//  SwiftNesTests
//
//  Created by Tibor Bodecs on 2021. 09. 12..
//

import XCTest
@testable import SwiftNes

final class LDATests: XCTestCase {
    
    private func testUnchangedLDARegisterFlags(_ nes: Nes) {
        XCTAssertFalse(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.interruptFlag)
        XCTAssertFalse(nes.cpu.registers.decimalFlag)
        XCTAssertFalse(nes.cpu.registers.breakFlag)
        XCTAssertFalse(nes.cpu.registers.overflowFlag)
    }
    
    func testLDAZeroFlag() throws {
        let nes = Nes()
        nes.memory.storage[0x00] = 0xA9
        nes.memory.storage[0x01] = 0
        nes.start(cycles: 2)
        XCTAssertEqual(nes.cpu.registers.a, 0)
        XCTAssertTrue(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 2)
    }
    
    func testLDA() throws {
        let nes = Nes()
        nes.memory.storage[0x00] = 0xA9
        nes.memory.storage[0x01] = 0x84
        nes.start(cycles: 2)
        XCTAssertEqual(nes.cpu.registers.a, 0x84)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 2)
    }
    
    func testLDAZeroPage() throws {
        let nes = Nes()
        nes.memory.storage[0x00] = 0xA5
        nes.memory.storage[0x01] = 0x42
        nes.memory.storage[0x42] = 11
        nes.start(cycles: 3)
        XCTAssertEqual(nes.cpu.registers.a, 11)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 3)
    }
    
    func testLDAZeroPageX() throws {
        let nes = Nes()
        nes.cpu.registers.x = 5
        nes.memory.storage[0x00] = 0xB5
        nes.memory.storage[0x01] = 0x42
        nes.memory.storage[0x47] = 0x37
        nes.start(cycles: 4)
        XCTAssertEqual(nes.cpu.registers.a, 0x37)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }
    
    func testLDAZeroPageXOverflow () throws {
        let nes = Nes()
        nes.cpu.registers.x = 0xFF
        nes.memory.storage[0x00] = 0xB5
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x007F] = 0x37
        nes.start(cycles: 4)
        XCTAssertEqual(nes.cpu.registers.a, 0x37)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }
    
    func testLDAAbsolute() throws {
        let nes = Nes()
        nes.memory.storage[0x00] = 0xAD
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x01
        nes.memory.storage[0x0180] = 0x84
        nes.start(cycles: 4)
        XCTAssertEqual(nes.cpu.registers.a, 0x84)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }
    
    func testLDAAbsoluteX() throws {
        let nes = Nes()
        nes.cpu.registers.x = 1
        nes.memory.storage[0x00] = 0xBD
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x01
        nes.memory.storage[0x0181] = 0x84
        nes.start(cycles: 4)
        XCTAssertEqual(nes.cpu.registers.a, 0x84)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }
    
    func testLDAAbsoluteXBoundary() throws {
        let nes = Nes()
        nes.cpu.registers.x = 0xFF
        nes.memory.storage[0x00] = 0xBD
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x00
        nes.memory.storage[0x017F] = 0x84
        nes.start(cycles: 5)
        XCTAssertEqual(nes.cpu.registers.a, 0x84)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 5)
    }
    
    func testLDAAbsoluteY() throws {
        let nes = Nes()
        nes.cpu.registers.y = 1
        nes.memory.storage[0x00] = 0xB9
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x01
        nes.memory.storage[0x0181] = 0x84
        nes.start(cycles: 4)
        XCTAssertEqual(nes.cpu.registers.a, 0x84)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }
    
    func testLDAAbsoluteYBoundary() throws {
        let nes = Nes()
        nes.cpu.registers.y = 0xFF
        nes.memory.storage[0x00] = 0xB9
        nes.memory.storage[0x01] = 0x80
        nes.memory.storage[0x02] = 0x00
        nes.memory.storage[0x017F] = 0x84
        nes.start(cycles: 5)
        XCTAssertEqual(nes.cpu.registers.a, 0x84)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 5)
    }
    
    func testLDAIndexedIndirect() throws {
        let nes = Nes()
        nes.cpu.registers.x = 0x04
        nes.memory.storage[0x00] = 0xA1
        nes.memory.storage[0x01] = 0x02
        nes.memory.storage[0x0006] = 0x80
        nes.memory.storage[0x0007] = 0x01
        nes.memory.storage[0x0180] = 0x84
        nes.start(cycles: 6)
        XCTAssertEqual(nes.cpu.registers.a, 0x84)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 6)
    }
    
    func testLDAIndirectIndexed() throws {
        let nes = Nes()
        nes.cpu.registers.y = 0x04
        nes.memory.storage[0x00] = 0xB1
        nes.memory.storage[0x01] = 0x02
        nes.memory.storage[0x0002] = 0x80
        nes.memory.storage[0x0003] = 0x01
        nes.memory.storage[0x0184] = 0x84
        nes.start(cycles: 5)
        XCTAssertEqual(nes.cpu.registers.a, 0x84)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 5)
    }
    
    func testLDAIndirectIndexedBoundary() throws {
        let nes = Nes()
        nes.cpu.registers.y = 0xFF
        nes.memory.storage[0x00] = 0xB1
        nes.memory.storage[0x01] = 0x02
        nes.memory.storage[0x0002] = 0x80
        nes.memory.storage[0x0003] = 0x00
        nes.memory.storage[0x017F] = 0x84
        nes.start(cycles: 6)
        XCTAssertEqual(nes.cpu.registers.a, 0x84)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 6)
    }
    
//    func testJSR() throws {
//        let nes = Nes()
//        nes.memory.storage[0x00] = 0x20
//        nes.memory.storage[0x01] = 0x11
//        nes.memory.storage[0x02] = 0x00
//        nes.memory.storage[0x0011] = 0xa9
//        nes.memory.storage[0x0012] = 0xcf
//        nes.start(cycles: 6)
//        XCTAssertEqual(nes.cpu.registers.a, 0xcf)
//    }
}
