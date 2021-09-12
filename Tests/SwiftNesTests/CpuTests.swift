//
//  CpuTests.swift
//  SwiftNesTests
//
//  Created by Tibor Bodecs on 2021. 09. 12..
//

import XCTest
@testable import SwiftNes

final class CpuTests: XCTestCase {
    
    func testLDA() throws {
        let nes = Nes()
        nes.memory.storage[0x00] = 0xa9
        nes.memory.storage[0x01] = 0x42
        nes.start()
        XCTAssertEqual(nes.cpu.registers.a, 0x42)
    }
    
    func testLDAZeroPage() throws {
        let nes = Nes()
        nes.memory.storage[0x00] = 0xa5
        nes.memory.storage[0x01] = 0x42
        nes.memory.storage[0x42] = 11
        nes.start()
        XCTAssertEqual(nes.cpu.registers.a, 11)
    }
    
    func testJSR() throws {
        let nes = Nes()
        nes.memory.storage[0x00] = 0x20
        nes.memory.storage[0x01] = 0x11
        nes.memory.storage[0x02] = 0x00
        nes.memory.storage[0x0011] = 0xa9
        nes.memory.storage[0x0012] = 0xcf
        nes.start()
        XCTAssertEqual(nes.cpu.registers.a, 0xcf)
    }
}
