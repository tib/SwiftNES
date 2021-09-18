//
//  LDXTests.swift
//  SwiftNesTests
//
//  Created by Tibor Bodecs on 2021. 09. 18..
//

import XCTest
@testable import SwiftNes

final class LDXTests: XCTestCase {
    
    private func testUnchangedRegisterFlags(_ nes: Nes) {
        XCTAssertFalse(nes.cpu.registers.carryFlag)
        XCTAssertFalse(nes.cpu.registers.interruptFlag)
        XCTAssertFalse(nes.cpu.registers.decimalFlag)
        XCTAssertFalse(nes.cpu.registers.breakFlag)
        XCTAssertFalse(nes.cpu.registers.overflowFlag)
    }

    func testLDXImmediate() throws {
        let nes = Nes()
        nes.memory.storage[0x00] = 0xA2
        nes.memory.storage[0x01] = 0x84
        nes.start(cycles: 2)
        XCTAssertEqual(nes.cpu.registers.x, 0x84)
        XCTAssertFalse(nes.cpu.registers.zeroFlag)
        XCTAssertTrue(nes.cpu.registers.signFlag)
        testUnchangedRegisterFlags(nes)
        XCTAssertEqual(nes.cpu.totalCycles, 2)
    }
}
