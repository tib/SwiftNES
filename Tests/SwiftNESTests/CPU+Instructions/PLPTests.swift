//
//  PLPTests.swift
//  SwiftNesTests
//
//  Created by Tibor Bodecs on 2021. 09. 18..
//

import XCTest
@testable import SwiftNes

final class PLPTests: XCTestCase {

    func testImplicit() throws {
        let nes = Nes()
        nes.cpu.registers.sp = 0xFC
        nes.memory.storage[0x01FC] = 0x42
        nes.memory.storage[0x00] = nes.cpu.opcode(.plp, .implicit)

        let cycles = 4
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
        XCTAssertEqual(nes.cpu.registers.p, 0x42)
        XCTAssertEqual(nes.cpu.registers.sp, 0xFD)
    }
}
