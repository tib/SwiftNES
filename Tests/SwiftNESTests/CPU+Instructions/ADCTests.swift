//
//  ADCTests.swift
//  SwiftNESTests
//
//  Created by Tibor Bodecs on 2021. 09. 14..
//

import XCTest
@testable import SwiftNes

final class ADCTests: XCTestCase {
    
    private func testUnchangedRegisterFlags(_ nes: Nes) {
        XCTAssertFalse(nes.cpu.registers.interruptFlag)
        XCTAssertFalse(nes.cpu.registers.decimalFlag)
        XCTAssertFalse(nes.cpu.registers.breakFlag)
    }

    
    // MARK: - test using absolute addressing mode
    
    func testZeroFlag() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 0
        nes.memory.storage[0x0000] = nes.cpu.opcode(.adc, .absolute)
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x01
        nes.memory.storage[0x0180] = 0
        let cycles = 4
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 0)
        XCTAssertTrue(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        XCTAssertFalse(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.overflowFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testNegativeFlagPositive() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 0
        nes.memory.storage[0x0000] = nes.cpu.opcode(.adc, .absolute)
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x01
        nes.memory.storage[0x0180] = 1
        let cycles = 4
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 1)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        XCTAssertFalse(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.overflowFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testNegativeFlag() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 0
        nes.memory.storage[0x0000] = nes.cpu.opcode(.adc, .absolute)
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x01
        nes.memory.storage[0x0180] = 0b11111111 // -1
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
    
    func testPositiveAndNegativeWithCarry() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = true
        nes.cpu.registers.a = 20
        nes.memory.storage[0x0000] = nes.cpu.opcode(.adc, .absolute)
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x01
        nes.memory.storage[0x0180] = 0b11101111 // -17
        let cycles = 4
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 4) // -4
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.overflowFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testNegativesWithCarry() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = true
        nes.cpu.registers.a = 0b10000000 // -128
        nes.memory.storage[0x0000] = nes.cpu.opcode(.adc, .absolute)
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x01
        nes.memory.storage[0x0180] = 0b11111111 // -1
        let cycles = 4
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 0b10000000) // -128
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.overflowFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }

    func testCarryFlagAddition() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = true
        nes.cpu.registers.a = 20
        nes.memory.storage[0x0000] = nes.cpu.opcode(.adc, .absolute)
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x01
        nes.memory.storage[0x0180] = 17
        let cycles = 4
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 38)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        XCTAssertFalse(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.overflowFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testCarryFlag() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 0xFF
        nes.memory.storage[0x0000] = nes.cpu.opcode(.adc, .absolute)
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x01
        nes.memory.storage[0x0180] = 1
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
    
    func testOverflowFlag() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 127
        nes.memory.storage[0x0000] = nes.cpu.opcode(.adc, .absolute)
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x01
        nes.memory.storage[0x0180] = 1
        let cycles = 4
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 128)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        XCTAssertFalse(nes.cpu.registers.carryFlag)
        XCTAssertTrue(nes.cpu.registers.overflowFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testOverflowFlagNegative() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 0b10000000 // -128
        nes.memory.storage[0x0000] = nes.cpu.opcode(.adc, .absolute)
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x01
        nes.memory.storage[0x0180] = 0b11111111 // -1
        let cycles = 4
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.a, 0b01111111)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertTrue(nes.cpu.registers.overflowFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    // MARK: - test other addressing modes
    
    private func checkResults(_ nes: Nes) {
        XCTAssertEqual(nes.cpu.registers.a, 0b01111111)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        XCTAssertTrue(nes.cpu.registers.overflowFlag)
        testUnchangedRegisterFlags(nes)
    }
    
    func testZeroPageAddressingMode() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 0b10000000 // -128
        nes.memory.storage[0x0000] = nes.cpu.opcode(.adc, .zeroPage)
        nes.memory.storage[0x0001] = 0x42
        nes.memory.storage[0x0042] = 0b11111111 // -1
        let cycles = 3
        nes.start(cycles: cycles)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testZeroPageXAddressingMode() throws {
        let nes = Nes()
        nes.cpu.registers.x = 5
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 0b10000000 // -128
        nes.memory.storage[0x0000] = nes.cpu.opcode(.adc, .zeroPageX)
        nes.memory.storage[0x0001] = 0x42
        nes.memory.storage[0x0047] = 0b11111111 // -1
        let cycles = 4
        nes.start(cycles: cycles)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testAbsoluteXAddressingMode() throws {
        let nes = Nes()
        nes.cpu.registers.x = 1
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 0b10000000 // -128
        nes.memory.storage[0x0000] = nes.cpu.opcode(.adc, .absoluteX)
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x01
        nes.memory.storage[0x0181] = 0b11111111 // -1
        let cycles = 4
        nes.start(cycles: cycles)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testAbsoluteXBoundary() throws {
        let nes = Nes()
        nes.cpu.registers.x = 0xFF
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 0b10000000 // -128
        nes.memory.storage[0x0000] = nes.cpu.opcode(.adc, .absoluteX)
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x00
        nes.memory.storage[0x017F] = 0b11111111 // -1
        let cycles = 5
        nes.start(cycles: cycles)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testAbsoluteYAddressingMode() throws {
        let nes = Nes()
        nes.cpu.registers.y = 1
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 0b10000000 // -128
        nes.memory.storage[0x0000] = nes.cpu.opcode(.adc, .absoluteY)
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x01
        nes.memory.storage[0x0181] = 0b11111111 // -1
        let cycles = 4
        nes.start(cycles: cycles)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testAbsoluteYBoundary() throws {
        let nes = Nes()
        nes.cpu.registers.y = 0xFF
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 0b10000000 // -128
        nes.memory.storage[0x0000] = nes.cpu.opcode(.adc, .absoluteY)
        nes.memory.storage[0x0001] = 0x80
        nes.memory.storage[0x0002] = 0x00
        nes.memory.storage[0x017F] = 0b11111111 // -1
        let cycles = 5
        nes.start(cycles: cycles)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    
    func testIndexedIndirectAddressingMode() throws {
        let nes = Nes()
        nes.cpu.registers.x = 0x04
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 0b10000000 // -128
        nes.memory.storage[0x0000] = nes.cpu.opcode(.adc, .indexedIndirect)
        nes.memory.storage[0x0001] = 0x02
        nes.memory.storage[0x0006] = 0x80
        nes.memory.storage[0x0007] = 0x01
        nes.memory.storage[0x0180] = 0b11111111 // -1
        let cycles = 6
        nes.start(cycles: cycles)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testIndirectIndexedAddressingMode() throws {
        let nes = Nes()
        nes.cpu.registers.y = 0x04
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 0b10000000 // -128
        nes.memory.storage[0x0000] = nes.cpu.opcode(.adc, .indirectIndexed)
        nes.memory.storage[0x0001] = 0x02
        nes.memory.storage[0x0002] = 0x80
        nes.memory.storage[0x0003] = 0x01
        nes.memory.storage[0x0184] = 0b11111111 // -1
        let cycles = 5
        nes.start(cycles: cycles)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testIndirectIndexedBoundary() throws {
        let nes = Nes()
        nes.cpu.registers.y = 0xFF
        nes.cpu.registers.carryFlag = false
        nes.cpu.registers.a = 0b10000000 // -128
        nes.memory.storage[0x0000] = nes.cpu.opcode(.adc, .indirectIndexed)
        nes.memory.storage[0x0001] = 0x02
        nes.memory.storage[0x0002] = 0x80
        nes.memory.storage[0x0003] = 0x00
        nes.memory.storage[0x017F] = 0b11111111 // -1
        let cycles = 6
        nes.start(cycles: cycles)
        checkResults(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }

}
