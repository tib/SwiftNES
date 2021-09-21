//
//  SwiftNesTests.swift
//  SwiftNesTests
//
//  Created by Tibor Bodecs on 2021. 09. 08..
//

import XCTest
@testable import SwiftNes

final class SwiftNesTests: XCTestCase {

    func testLoadProgram() throws {
        /*
         = $ 0004
         lda #$FF
         
         start
         sta $90
         sta $8000
         eor #$CC
         jmp start
         */
        let nes = Nes()
        let program: [UInt8] = [0x04, 0x00, 0xA9, 0xFF, 0x85, 0x90, 0x8D, 0x00, 0x80, 0x49, 0xCC, 0x4C, 0x04, 0x00]
        let pc = nes.cpu.load(program)
        
        XCTAssertEqual(pc, 0x0004)
        XCTAssertEqual(nes.memory.storage[0x0003], 0x0)
        XCTAssertEqual(nes.memory.storage[0x0004], 0xA9)
        XCTAssertEqual(nes.memory.storage[0x000E], 0x04)
        XCTAssertEqual(nes.memory.storage[0x000F], 0x00)
        XCTAssertEqual(nes.memory.storage[0x0010], 0x0)
    }
    
    func testLoadAndExecuteProgram() throws {
        let nes = Nes()
        let program: [UInt8] = [0x04, 0x00, 0xA9, 0xFF, 0x85, 0x90, 0x8D, 0x00, 0x80, 0x49, 0xCC, 0x4C, 0x04, 0x00]
        print(nes.cpu.load(program))
        nes.cpu.registers.pc = nes.cpu.load(program)
        nes.start(cycles: 32)
//        XCTAssertTrue(nes.cpu.registers.overflowFlag)
//        XCTAssertTrue(nes.cpu.registers.signFlag)
//        XCTAssertTrue(nes.cpu.registers.zeroFlag)
//        XCTAssertEqual(nes.cpu.registers.a, 0xCC)
//        XCTAssertEqual(nes.cpu.totalCycles, 3)
    }
}
