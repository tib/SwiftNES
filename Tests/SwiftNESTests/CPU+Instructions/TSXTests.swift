//
//  TSXTests.swift
//  SwiftNesTests
//
//  Created by Tibor Bodecs on 2021. 09. 18..
//

import XCTest
@testable import SwiftNes

final class TSXTests: XCTestCase {

    private func testUnchangedRegisterFlags(_ nes: Nes, _ registers: Cpu.Registers) {
        XCTAssertEqual(nes.cpu.registers.zeroFlag, registers.zeroFlag)
        XCTAssertEqual(nes.cpu.registers.signFlag, registers.signFlag)
        XCTAssertEqual(nes.cpu.registers.carryFlag, registers.carryFlag)
        XCTAssertEqual(nes.cpu.registers.interruptFlag, registers.interruptFlag)
        XCTAssertEqual(nes.cpu.registers.decimalFlag, registers.decimalFlag)
        XCTAssertEqual(nes.cpu.registers.breakFlag, registers.breakFlag)
        XCTAssertEqual(nes.cpu.registers.overflowFlag, registers.overflowFlag)
    }
    
    func testImplied() throws {
        let nes = Nes()
        nes.cpu.registers.zeroFlag = true
        nes.cpu.registers.signFlag = true
        nes.cpu.registers.x = 0x00
        nes.cpu.registers.sp = 0x01
        nes.memory.storage[0x00] = nes.cpu.opcode(.tsx, .implicit)
        
        let cycles = 2
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
    }
    
    func testImpliedZeroFlag() throws {
        let nes = Nes()
        nes.cpu.registers.zeroFlag = false
        nes.cpu.registers.signFlag = true
        nes.cpu.registers.x = 0x01
        nes.cpu.registers.sp = 0x00
        nes.memory.storage[0x00] = nes.cpu.opcode(.tsx, .implicit)
        
        let cycles = 2
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
        XCTAssertTrue(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
    }
    
    func testImpliedNegativeFlag() throws {
        let nes = Nes()
        nes.cpu.registers.zeroFlag = true
        nes.cpu.registers.signFlag = false
        nes.cpu.registers.x = 0x00
        nes.cpu.registers.sp = 0b10000000
        nes.memory.storage[0x00] = nes.cpu.opcode(.tsx, .implicit)
        
        let cycles = 2
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
    }
}
