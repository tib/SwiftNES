//
//  Cpu+Opcodes.swift
//  SwiftNes
//
//  Created by Tibor Bodecs on 2021. 09. 09..
//

import Foundation

extension Cpu {
    
    struct Opcode {
        let value: Byte
        let instruction: Instruction
        let addressingMode: AddressingMode

        init(_ value: Byte,
             _ instruction: Cpu.Instruction,
             _ addressingMode: Cpu.AddressingMode = .implicit) {
            self.value = value
            self.instruction = instruction
            self.addressingMode = addressingMode
        }
    }
 
    func opcode(_ instruction: Cpu.Instruction, _ addressingMode: Cpu.AddressingMode) -> Byte {
        opcodes.first(where: { $0.instruction == instruction && $0.addressingMode == addressingMode})!.value
    }

    var opcodes: [Opcode] {
        [
            .init(0x00, .brk),
            .init(0x01, .ora, .indexedIndirect),
            .init(0x02, .invalid),
            .init(0x03, .invalid),
            .init(0x04, .nop, .zeroPage),
            .init(0x05, .ora, .zeroPage),
            .init(0x06, .asl, .zeroPage),
            .init(0x07, .invalid),
            .init(0x08, .php),
            .init(0x09, .ora, .immediate),
            .init(0x0A, .asl, .accumulator),
            .init(0x0B, .invalid),
            .init(0x0C, .invalid),
            .init(0x0D, .ora, .absolute),
            .init(0x0E, .asl, .absolute),
            .init(0x0F, .invalid),
                  
            .init(0x10, .bpl, .relative),
            .init(0x11, .ora, .indirectIndexed),
            .init(0x12, .invalid),
            .init(0x13, .invalid),
            .init(0x14, .invalid),
            .init(0x15, .ora, .zeroPageX),
            .init(0x16, .asl, .zeroPageX),
            .init(0x17, .invalid),
            .init(0x18, .clc),
            .init(0x19, .ora, .absoluteY),
            .init(0x1A, .invalid),
            .init(0x1B, .invalid),
            .init(0x1C, .invalid),
            .init(0x1D, .ora, .absoluteX),
            .init(0x1E, .asl, .absoluteX),
            .init(0x1F, .invalid),
                  
            .init(0x20, .jsr, .absolute),
            .init(0x21, .and, .indexedIndirect),
            .init(0x22, .invalid),
            .init(0x23, .invalid),
            .init(0x24, .bit, .zeroPage),
            .init(0x25, .and, .zeroPage),
            .init(0x26, .rol, .zeroPage),
            .init(0x27, .invalid),
            .init(0x28, .plp),
            .init(0x29, .and, .immediate),
            .init(0x2A, .rol, .accumulator),
            .init(0x2B, .invalid),
            .init(0x2C, .bit, .absolute),
            .init(0x2D, .and, .absolute),
            .init(0x2E, .rol, .absolute),
            .init(0x2F, .invalid),
                  
            .init(0x30, .bmi, .relative),
            .init(0x31, .and, .indirectIndexed),
            .init(0x32, .invalid),
            .init(0x33, .invalid),
            .init(0x34, .invalid),
            .init(0x35, .and, .zeroPageX),
            .init(0x36, .rol, .zeroPageX),
            .init(0x37, .invalid),
            .init(0x38, .sec),
            .init(0x39, .and, .absoluteY),
            .init(0x3A, .invalid),
            .init(0x3B, .invalid),
            .init(0x3C, .invalid),
            .init(0x3D, .and, .absoluteX),
            .init(0x3E, .rol, .absoluteX),
            .init(0x3F, .invalid),
                  
            .init(0x40, .rti),
            .init(0x41, .eor, .indexedIndirect),
            .init(0x42, .invalid),
            .init(0x43, .invalid),
            .init(0x44, .invalid),
            .init(0x45, .eor, .zeroPage),
            .init(0x46, .lsr, .zeroPage),
            .init(0x47, .invalid),
            .init(0x48, .pha),
            .init(0x49, .eor, .immediate),
            .init(0x4A, .lsr, .accumulator),
            .init(0x4B, .invalid),
            .init(0x4C, .jmp, .absolute),
            .init(0x4D, .eor, .absolute),
            .init(0x4E, .lsr, .absolute),
            .init(0x4F, .invalid),
            
            .init(0x50, .bvc, .relative),
            .init(0x51, .eor, .indirectIndexed),
            .init(0x52, .invalid),
            .init(0x53, .invalid),
            .init(0x54, .invalid),
            .init(0x55, .eor, .zeroPageX),
            .init(0x56, .lsr, .zeroPageX),
            .init(0x57, .invalid),
            .init(0x58, .cli),
            .init(0x59, .eor, .absoluteY),
            .init(0x5A, .invalid),
            .init(0x5B, .invalid),
            .init(0x5C, .invalid),
            .init(0x5D, .eor, .absoluteX),
            .init(0x5E, .lsr, .absoluteX),
            .init(0x5F, .invalid),
            
            .init(0x60, .rts),
            .init(0x61, .adc, .indexedIndirect),
            .init(0x62, .invalid),
            .init(0x63, .invalid),
            .init(0x64, .invalid),
            .init(0x65, .adc, .zeroPage),
            .init(0x66, .ror, .zeroPage),
            .init(0x67, .invalid),
            .init(0x68, .pla),
            .init(0x69, .adc, .immediate),
            .init(0x6A, .ror, .accumulator),
            .init(0x6B, .invalid),
            .init(0x6C, .jmp, .indirect),
            .init(0x6D, .adc, .absolute),
            .init(0x6E, .ror, .absolute),
            .init(0x6F, .invalid),
                  
            .init(0x70, .bvs, .relative),
            .init(0x71, .adc, .indirectIndexed),
            .init(0x72, .invalid),
            .init(0x73, .invalid),
            .init(0x74, .invalid),
            .init(0x75, .adc, .zeroPageX),
            .init(0x76, .ror, .zeroPageX),
            .init(0x77, .invalid),
            .init(0x78, .sei),
            .init(0x79, .adc, .absoluteY),
            .init(0x7A, .invalid),
            .init(0x7B, .invalid),
            .init(0x7C, .invalid),
            .init(0x7D, .adc, .absoluteX),
            .init(0x7E, .ror, .absoluteX),
            .init(0x7F, .invalid),
            
            .init(0x80, .invalid),
            .init(0x81, .sta, .indexedIndirect),
            .init(0x82, .invalid),
            .init(0x83, .invalid),
            .init(0x84, .sty, .zeroPage),
            .init(0x85, .sta, .zeroPage),
            .init(0x86, .stx, .zeroPage),
            .init(0x87, .invalid),
            .init(0x88, .dey),
            .init(0x89, .invalid),
            .init(0x8A, .txa),
            .init(0x8B, .invalid),
            .init(0x8C, .sty, .absolute),
            .init(0x8D, .sta, .absolute),
            .init(0x8E, .stx, .absolute),
            .init(0x8F, .invalid),
            
            .init(0x90, .bcc, .relative),
            .init(0x91, .sta, .indirectIndexed),
            .init(0x92, .invalid),
            .init(0x93, .invalid),
            .init(0x94, .sty, .zeroPageX),
            .init(0x95, .sta, .zeroPageX),
            .init(0x96, .stx, .zeroPageY),
            .init(0x97, .invalid),
            .init(0x98, .tya),
            .init(0x99, .sta, .absoluteY),
            .init(0x9A, .txs),
            .init(0x9B, .invalid),
            .init(0x9C, .invalid),
            .init(0x9D, .sta, .absoluteX),
            .init(0x9E, .invalid),
            .init(0x9F, .invalid),
            
            .init(0xA0, .ldy, .immediate),
            .init(0xA1, .lda, .indexedIndirect),
            .init(0xA2, .ldx, .immediate),
            .init(0xA3, .invalid),
            .init(0xA4, .ldy, .zeroPage),
            .init(0xA5, .lda, .zeroPage),
            .init(0xA6, .ldx, .zeroPage),
            .init(0xA7, .invalid),
            .init(0xA8, .tay),
            .init(0xA9, .lda, .immediate),
            .init(0xAA, .tax),
            .init(0xAB, .invalid),
            .init(0xAC, .ldy, .absolute),
            .init(0xAD, .lda, .absolute),
            .init(0xAE, .ldx, .absolute),
            .init(0xAF, .invalid),
            
            .init(0xB0, .bcs, .relative),
            .init(0xB1, .lda, .indirectIndexed),
            .init(0xB2, .invalid),
            .init(0xB3, .invalid),
            .init(0xB4, .ldy, .zeroPageX),
            .init(0xB5, .lda, .zeroPageX),
            .init(0xB6, .ldx, .zeroPageY),
            .init(0xB7, .invalid),
            .init(0xB8, .clv),
            .init(0xB9, .lda, .absoluteY),
            .init(0xBA, .tsx),
            .init(0xBB, .invalid),
            .init(0xBC, .ldy, .absoluteX),
            .init(0xBD, .lda, .absoluteX),
            .init(0xBE, .ldx, .absoluteY),
            .init(0xBF, .invalid),
            
            .init(0xC0, .cpy, .immediate),
            .init(0xC1, .cmp, .indexedIndirect),
            .init(0xC2, .invalid),
            .init(0xC3, .invalid),
            .init(0xC4, .cpy, .zeroPage),
            .init(0xC5, .cmp, .zeroPage),
            .init(0xC6, .dec, .zeroPage),
            .init(0xC7, .invalid),
            .init(0xC8, .iny),
            .init(0xC9, .cmp, .immediate),
            .init(0xCA, .dex),
            .init(0xCB, .invalid),
            .init(0xCC, .cpy, .absolute),
            .init(0xCD, .cmp, .absolute),
            .init(0xCE, .dec, .absolute),
            .init(0xCF, .invalid),
            
            .init(0xD0, .bne, .relative),
            .init(0xD1, .cmp, .indirectIndexed),
            .init(0xD2, .invalid),
            .init(0xD3, .invalid),
            .init(0xD4, .invalid),
            .init(0xD5, .cmp, .zeroPageX),
            .init(0xD6, .dec, .zeroPageX),
            .init(0xD7, .invalid),
            .init(0xD8, .cld),
            .init(0xD9, .cmp, .absoluteY),
            .init(0xDA, .invalid),
            .init(0xDB, .invalid),
            .init(0xDC, .invalid),
            .init(0xDD, .cmp, .absoluteX),
            .init(0xDE, .dec, .absoluteX),
            .init(0xDF, .invalid),
            
            .init(0xE0, .cpx, .immediate),
            .init(0xE1, .sbc, .indexedIndirect),
            .init(0xE2, .invalid),
            .init(0xE3, .invalid),
            .init(0xE4, .cpx, .zeroPage),
            .init(0xE5, .sbc, .zeroPage),
            .init(0xE6, .inc, .zeroPage),
            .init(0xE7, .invalid),
            .init(0xE8, .inx),
            .init(0xE9, .sbc, .immediate),
            .init(0xEA, .nop),
            .init(0xEB, .invalid),
            .init(0xEC, .cpx, .absolute),
            .init(0xED, .sbc, .absolute),
            .init(0xEE, .inc, .absolute),
            .init(0xEF, .invalid),
            
            .init(0xF0, .beq, .relative),
            .init(0xF1, .sbc, .indirectIndexed),
            .init(0xF2, .invalid),
            .init(0xF3, .invalid),
            .init(0xF4, .invalid),
            .init(0xF5, .sbc, .zeroPageX),
            .init(0xF6, .inc, .zeroPageX),
            .init(0xF7, .invalid),
            .init(0xF8, .sed),
            .init(0xF9, .sbc, .absoluteY),
            .init(0xFA, .invalid),
            .init(0xFB, .invalid),
            .init(0xFC, .invalid),
            .init(0xFD, .sbc, .absoluteX),
            .init(0xFE, .inc, .absoluteX),
            .init(0xFF, .invalid),
        ]
    }
    
}
