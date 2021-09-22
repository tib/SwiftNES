//
//  CLVTests.swift
//  SwiftNesTests
//
//  Created by Tibor Bodecs on 2021. 09. 12..
//

import XCTest
@testable import SwiftNes

final class CLVTests: XCTestCase {

    private func testUnchangedRegisterFlags(_ nes: Nes) {
        XCTAssertFalse(nes.cpu.registers.signFlag)
        XCTAssertFalse(nes.cpu.registers.interruptFlag)
        XCTAssertFalse(nes.cpu.registers.decimalFlag)
        XCTAssertFalse(nes.cpu.registers.breakFlag)
        XCTAssertFalse(nes.cpu.registers.carryFlag)
    }
    
    func testClearFlag() throws {
        let nes = Nes()
        nes.cpu.registers.overflowFlag = true
        nes.memory.storage[0x00] = nes.cpu.opcode(.clv, .implicit)
        let cycles = 2
        nes.start(cycles: cycles)
        XCTAssertFalse(nes.cpu.registers.overflowFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
}
