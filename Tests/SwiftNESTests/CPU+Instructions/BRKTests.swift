//
//  BRKTests.swift
//  SwiftNesTests
//
//  Created by Tibor Bodecs on 2021. 09. 12..
//

import XCTest
@testable import SwiftNes

final class BRKTests: XCTestCase {
    
    private func testUnchangedRegisterFlags(_ nes: Nes) {
        XCTAssertFalse(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.interruptFlag)
        XCTAssertFalse(nes.cpu.registers.decimalFlag)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertFalse(nes.cpu.registers.signFlag)
        XCTAssertFalse(nes.cpu.registers.overflowFlag)
    }
        
    func testImmediate() throws {
        let nes = Nes()
        nes.cpu.registers.breakFlag = false
        nes.memory.storage[0x00] = nes.cpu.opcode(.brk, .implicit)
        nes.memory.storage[0x00FE] = 0x80
        nes.memory.storage[0x00FF] = 0x00
        let registers = nes.cpu.registers
        let cycles = 7
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.pc, 0x0080)
        XCTAssertTrue(nes.cpu.registers.breakFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
        XCTAssertEqual(nes.cpu.registers.sp, registers.sp - 3)
        XCTAssertEqual(nes.memory.storage[Int(0x100|UInt16(registers.sp)-0)], 0x00)
        XCTAssertEqual(nes.memory.storage[Int(0x100|UInt16(registers.sp)-1)], 0x01)
        XCTAssertEqual(nes.memory.storage[Int(0x100|UInt16(registers.sp)-2)], registers.p)
    }
}
