//
//  TXSTests.swift
//  SwiftNesTests
//
//  Created by Tibor Bodecs on 2021. 09. 18..
//

import XCTest
@testable import SwiftNes

final class TXSTests: XCTestCase {

    private func testUnchangedRegisterFlags(_ nes: Nes, _ registers: Cpu.Registers) {
        XCTAssertEqual(nes.cpu.registers.zeroFlag, registers.zeroFlag)
        XCTAssertEqual(nes.cpu.registers.signFlag, registers.signFlag)
        XCTAssertEqual(nes.cpu.registers.carryFlag, registers.carryFlag)
        XCTAssertEqual(nes.cpu.registers.interruptFlag, registers.interruptFlag)
        XCTAssertEqual(nes.cpu.registers.decimalFlag, registers.decimalFlag)
        XCTAssertEqual(nes.cpu.registers.breakFlag, registers.breakFlag)
        XCTAssertEqual(nes.cpu.registers.overflowFlag, registers.overflowFlag)
    }
    
    func testImplicit() throws {
        let nes = Nes()
        let registers = nes.cpu.registers
        nes.cpu.registers.x = 0xFF
        nes.cpu.registers.sp = 0x01
        nes.memory.storage[0x00] = nes.cpu.opcode(.txs, .implicit)
        
        let cycles = 2
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
        XCTAssertEqual(nes.cpu.registers.sp, 0xFF)
        testUnchangedRegisterFlags(nes, registers)
    }
}
