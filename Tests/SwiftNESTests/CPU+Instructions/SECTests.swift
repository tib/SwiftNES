//
//  SECTests.swift
//  SwiftNesTests
//
//  Created by Tibor Bodecs on 2021. 09. 12..
//

import XCTest
@testable import SwiftNes

final class SECTests: XCTestCase {

    private func testUnchangedRegisterFlags(_ nes: Nes) {
        XCTAssertFalse(nes.cpu.registers.signFlag)
        XCTAssertFalse(nes.cpu.registers.interruptFlag)
        XCTAssertFalse(nes.cpu.registers.decimalFlag)
        XCTAssertFalse(nes.cpu.registers.breakFlag)
        XCTAssertFalse(nes.cpu.registers.overflowFlag)
    }
    
    func testSetFlag() throws {
        let nes = Nes()
        nes.cpu.registers.carryFlag = false
        nes.memory.storage[0x00] = nes.cpu.opcode(.sec, .implicit)
        let cycles = 2
        nes.start(cycles: cycles)
        XCTAssertTrue(nes.cpu.registers.carryFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
}
