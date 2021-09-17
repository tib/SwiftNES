//
//  ADCTests.swift
//  SwiftNESTests
//
//  Created by Tibor Bodecs on 2021. 09. 14..
//

import XCTest
@testable import SwiftNes

final class ADCTests: XCTestCase {
    
    private func testUnchangedLDARegisterFlags(_ nes: Nes) {
        XCTAssertFalse(nes.cpu.registers.interruptFlag)
        XCTAssertFalse(nes.cpu.registers.decimalFlag)
        XCTAssertFalse(nes.cpu.registers.breakFlag)
    }

    
    // MARK: - test using absolute addressing mode
    
    func testADCZeroFlag() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 0
        nes.memory.storage[0x0000] = 0x6D
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x01
        nes.memory.storage[0x0180] = 0
        nes.start(cycles: 4)
        XCTAssertEqual(nes.cpu.registers.a, 0)
        XCTAssertTrue(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        XCTAssertFalse(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.overflowFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }
    
    func testADCNegativeFlagPositive() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 0
        nes.memory.storage[0x0000] = 0x6D
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x01
        nes.memory.storage[0x0180] = 1
        nes.start(cycles: 4)
        XCTAssertEqual(nes.cpu.registers.a, 1)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        XCTAssertFalse(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.overflowFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }
    
    func testADCNegativeFlag() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 0
        nes.memory.storage[0x0000] = 0x6D
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x01
        nes.memory.storage[0x0180] = 0b11111111 // -1
        nes.start(cycles: 4)
        XCTAssertEqual(nes.cpu.registers.a, 0b11111111)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        XCTAssertFalse(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.overflowFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }
    
    func testADCPositiveAndNegativeWithCarry() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = true
        nes.cpu.registers.a = 20
        nes.memory.storage[0x0000] = 0x6D
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x01
        nes.memory.storage[0x0180] = 0b11101111 // -17
        nes.start(cycles: 4)
        XCTAssertEqual(nes.cpu.registers.a, 4) // -4
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.overflowFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }
    
    func testADCNegativesWithCarry() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = true
        nes.cpu.registers.a = 0b10000000 // -128
        nes.memory.storage[0x0000] = 0x6D
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x01
        nes.memory.storage[0x0180] = 0b11111111 // -1
        nes.start(cycles: 4)
        XCTAssertEqual(nes.cpu.registers.a, 0b10000000) // -128
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.overflowFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }
    
    func testADCCarryFlagAddition() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = true
        nes.cpu.registers.a = 20
        nes.memory.storage[0x0000] = 0x6D
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x01
        nes.memory.storage[0x0180] = 17
        nes.start(cycles: 4)
        XCTAssertEqual(nes.cpu.registers.a, 38)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        XCTAssertFalse(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.overflowFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }
    
    func testADCCarryFlag() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 0xFF
        nes.memory.storage[0x0000] = 0x6D
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x01
        nes.memory.storage[0x0180] = 1
        nes.start(cycles: 4)
        XCTAssertEqual(nes.cpu.registers.a, 0)
        XCTAssertTrue(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.overflowFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }
    
    func testADCOverflowFlag() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 127
        nes.memory.storage[0x0000] = 0x6D
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x01
        nes.memory.storage[0x0180] = 1
        nes.start(cycles: 4)
        XCTAssertEqual(nes.cpu.registers.a, 128)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        XCTAssertFalse(nes.cpu.registers.carryFlag)
        XCTAssertTrue(nes.cpu.registers.overflowFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }
    
    func testADCOverflowFlagNegative() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 0b10000000 // -128
        nes.memory.storage[0x0000] = 0x6D
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x01
        nes.memory.storage[0x0180] = 0b11111111 // -1
        nes.start(cycles: 4)
        XCTAssertEqual(nes.cpu.registers.a, 0b01111111)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertTrue(nes.cpu.registers.overflowFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }
    
    // MARK: - test other addressing modes
    
    func testADCZeroPageAddressingMode() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 0b10000000 // -128
        nes.memory.storage[0x0000] = 0x65
        nes.memory.storage[0x0001] = 0x42
        nes.memory.storage[0x0042] = 0b11111111 // -1
        nes.start(cycles: 3)
        XCTAssertEqual(nes.cpu.registers.a, 0b01111111)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertTrue(nes.cpu.registers.overflowFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 3)
    }
    
    func testADCZeroPageXAddressingMode() throws {
        let nes = Nes()
        nes.cpu.registers.x = 5
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 0b10000000 // -128
        nes.memory.storage[0x0000] = 0x75
        nes.memory.storage[0x0001] = 0x42
        nes.memory.storage[0x0047] = 0b11111111 // -1
        nes.start(cycles: 4)
        XCTAssertEqual(nes.cpu.registers.a, 0b01111111)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertTrue(nes.cpu.registers.overflowFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }
    
    func testADCAbsoluteXAddressingMode() throws {
        let nes = Nes()
        nes.cpu.registers.x = 1
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 0b10000000 // -128
        nes.memory.storage[0x0000] = 0x7D
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x01
        nes.memory.storage[0x0181] = 0b11111111 // -1
        nes.start(cycles: 4)
        XCTAssertEqual(nes.cpu.registers.a, 0b01111111)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertTrue(nes.cpu.registers.overflowFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }
    
    func testADCAbsoluteXBoundary() throws {
        let nes = Nes()
        nes.cpu.registers.x = 0xFF
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 0b10000000 // -128
        nes.memory.storage[0x0000] = 0x7D
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x00
        nes.memory.storage[0x017F] = 0b11111111 // -1
        nes.start(cycles: 5)
        XCTAssertEqual(nes.cpu.registers.a, 0b01111111)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertTrue(nes.cpu.registers.overflowFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 5)
    }
    
    func testADCAbsoluteYAddressingMode() throws {
        let nes = Nes()
        nes.cpu.registers.y = 1
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 0b10000000 // -128
        nes.memory.storage[0x0000] = 0x79
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x01
        nes.memory.storage[0x0181] = 0b11111111 // -1
        nes.start(cycles: 4)
        XCTAssertEqual(nes.cpu.registers.a, 0b01111111)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertTrue(nes.cpu.registers.overflowFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 4)
    }
    
    func testADCAbsoluteYBoundary() throws {
        let nes = Nes()
        nes.cpu.registers.y = 0xFF
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 0b10000000 // -128
        nes.memory.storage[0x0000] = 0x79
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x00
        nes.memory.storage[0x017F] = 0b11111111 // -1
        nes.start(cycles: 5)
        XCTAssertEqual(nes.cpu.registers.a, 0b01111111)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertTrue(nes.cpu.registers.overflowFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 5)
    }
    
    
    func testADCIndexedIndirectAddressingMode() throws {
        let nes = Nes()
        nes.cpu.registers.x = 0x04
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 0b10000000 // -128
        nes.memory.storage[0x0000] = 0x61
        nes.memory.storage[0x0001] = 0x02
        nes.memory.storage[0x0006] = 0x80
        nes.memory.storage[0x0007] = 0x01
        nes.memory.storage[0x0180] = 0b11111111 // -1
        nes.start(cycles: 6)
        XCTAssertEqual(nes.cpu.registers.a, 0b01111111)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertTrue(nes.cpu.registers.overflowFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 6)
    }
    
    func testADCIndirectIndexedAddressingMode() throws {
        let nes = Nes()
        nes.cpu.registers.y = 0x04
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 0b10000000 // -128
        nes.memory.storage[0x0000] = 0x71
        nes.memory.storage[0x0001] = 0x02
        nes.memory.storage[0x0002] = 0x80
        nes.memory.storage[0x0003] = 0x01
        nes.memory.storage[0x0184] = 0b11111111 // -1
        nes.start(cycles: 5)
        XCTAssertEqual(nes.cpu.registers.a, 0b01111111)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertTrue(nes.cpu.registers.overflowFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 5)
    }
    
    func testADCIndirectIndexedBoundary() throws {
        let nes = Nes()
        nes.cpu.registers.y = 0xFF
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 0b10000000 // -128
        nes.memory.storage[0x0000] = 0x71
        nes.memory.storage[0x0001] = 0x02
        nes.memory.storage[0x0002] = 0x80
        nes.memory.storage[0x0003] = 0x00
        nes.memory.storage[0x017F] = 0b11111111 // -1
        nes.start(cycles: 6)
        XCTAssertEqual(nes.cpu.registers.a, 0b01111111)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertTrue(nes.cpu.registers.overflowFlag)
        testUnchangedLDARegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 6)
    }

}
