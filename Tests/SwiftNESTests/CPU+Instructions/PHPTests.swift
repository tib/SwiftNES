//
//  PHPTests.swift
//  SwiftNesTests
//
//  Created by Tibor Bodecs on 2021. 09. 18..
//

import XCTest
@testable import SwiftNes

final class PHPTests: XCTestCase {

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
        nes.cpu.registers.p = 0xCC

        let registers = nes.cpu.registers
        nes.memory.storage[0x00] = nes.cpu.opcode(.php, .implicit)

        let cycles = 3
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.sp, 0xFE)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
        XCTAssertEqual(nes.memory.storage[Int(nes.cpu.spAddress + 1)], 0xCC)
        testUnchangedRegisterFlags(nes, registers)
    }
}
