//
//  CPUTests.swift
//  SwiftNesTests
//
//  Created by Tibor Bodecs on 2021. 09. 08..
//

import XCTest
@testable import SwiftNes

final class CPUTests: XCTestCase {
    
    func testStackByte() {
        let nes = Nes()
        nes.cpu.pushByteToStack(0x1)
        XCTAssertEqual(nes.cpu.popByteFromStack(), 0x01)
        XCTAssertEqual(nes.cpu.registers.sp, 0xFF)
    }
    
    func testStackWord() {
        let nes = Nes()
        nes.cpu.pushWordToStack(0xFF01)
        XCTAssertEqual(nes.cpu.popWordFromStack(), 0xFF01)
        XCTAssertEqual(nes.cpu.registers.sp, 0xFF)
    }
    
    // MARK: - program tests
    
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
    }
    
    /// increment values
    func testProgram2() throws {
        /*
         * = 0004

         lda #00
         sta $42

         start
         inc $42
         ldx $42
         inx
         jmp start
         */
        let nes = Nes()
        let program: [UInt8] = [0x04, 0x00, 0xA9, 0x00, 0x85, 0x42, 0xE6, 0x42, 0xA6, 0x42, 0xE8, 0x4C, 0x08, 0x00]
        print(nes.cpu.load(program))
        nes.cpu.registers.pc = nes.cpu.load(program)
        nes.start(cycles: 32)
        XCTAssertEqual(nes.cpu.registers.x, 3)
        XCTAssertEqual(nes.memory.storage[0x42], 3)
    }
    
    /// for loop 3 times, then store value 20 in register x
    func testProgram3() throws {
        /*
         * = 0004

         lda #0
         clc
         loop
           adc #8
           cmp #24
           bne loop
         ldx #20
         */
        let nes = Nes()
        let program: [UInt8] = [0x04, 0x00, 0xA9, 0x00, 0x18, 0x69, 0x08, 0xC9, 0x18, 0xD0, 0xFA, 0xA2, 0x14]
        print(nes.cpu.load(program))
        nes.cpu.registers.pc = nes.cpu.load(program)
        nes.start(cycles: 26)
        XCTAssertEqual(nes.cpu.registers.a, 24)
        XCTAssertEqual(nes.cpu.registers.x, 20)
    }
}
