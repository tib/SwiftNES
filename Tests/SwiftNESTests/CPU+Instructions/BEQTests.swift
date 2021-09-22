//
//  BEQTests.swift
//  SwiftNesTests
//
//  Created by Tibor Bodecs on 2021. 09. 12..
//

import XCTest
@testable import SwiftNes

final class BEQTests: XCTestCase {

    func testIf() throws {
        let nes = Nes()
        nes.cpu.registers.zeroFlag = true
        let registers = nes.cpu.registers
        nes.memory.storage[0x00] = nes.cpu.opcode(.beq, .relative)
        nes.memory.storage[0x01] = 0x01
        let cycles = 3
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.pc, 0x03)
        XCTAssertEqual(nes.cpu.registers.p, registers.p)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testIfNewPage() throws {
        let nes = Nes()
        nes.cpu.registers.pc = 0x00FC
        nes.cpu.registers.zeroFlag = true
        nes.memory.storage[0x00FC] = nes.cpu.opcode(.beq, .relative)
        nes.memory.storage[0x00FD] = 0x42
        let registers = nes.cpu.registers
        let cycles = 5
        
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.pc, 0x0140)
        XCTAssertEqual(nes.cpu.registers.p, registers.p)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testIfBackwards() throws {
        let nes = Nes()
        nes.cpu.registers.pc = 0x00FC
        nes.cpu.registers.zeroFlag = true
        nes.memory.storage[0xFC] = nes.cpu.opcode(.beq, .relative)
        nes.memory.storage[0xFD] = 0b11111110
        let registers = nes.cpu.registers
        let cycles = 3

        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.pc, 0xFC)
        XCTAssertEqual(nes.cpu.registers.p, registers.p)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testElse() throws {
        let nes = Nes()
        nes.cpu.registers.zeroFlag = false
        let registers = nes.cpu.registers
        nes.memory.storage[0x00] = nes.cpu.opcode(.beq, .relative)
        nes.memory.storage[0x01] = 0x01
        let cycles = 2
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.pc, 0x02)
        XCTAssertEqual(nes.cpu.registers.p, registers.p)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testElseBackwards() throws {
        let nes = Nes()
        nes.cpu.registers.pc = 0x00FC
        nes.cpu.registers.zeroFlag = false
        nes.memory.storage[0xFC] = nes.cpu.opcode(.beq, .relative)
        nes.memory.storage[0xFD] = 0b11111110
        let registers = nes.cpu.registers
        let cycles = 2
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.pc, 0xFE)
        XCTAssertEqual(nes.cpu.registers.p, registers.p)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }
    
    func testElseNewPage() throws {
        let nes = Nes()
        nes.cpu.registers.pc = 0x00FE
        nes.cpu.registers.zeroFlag = false
        nes.memory.storage[0x00FE] = nes.cpu.opcode(.beq, .relative)
        nes.memory.storage[0x00FF] = 0x42
        let registers = nes.cpu.registers
        let cycles = 2
        nes.start(cycles: cycles)
        XCTAssertEqual(nes.cpu.registers.pc, 0x0100)
        XCTAssertEqual(nes.cpu.registers.p, registers.p)
        XCTAssertEqual(nes.cpu.totalCycles, cycles)
    }

}
