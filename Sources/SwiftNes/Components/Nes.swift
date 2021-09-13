//
//  Nes.swift
//  SwiftNes
//
//  Created by Tibor Bodecs on 2021. 09. 09..
//

import Foundation

public final class Nes {

    let bus: Bus
    let memory: Memory
    let cpu: Cpu

    public init() {
        self.bus = Bus()
        self.memory = Memory(size: 0x0800) // 2k
        self.cpu = Cpu(bus: self.bus)

        self.bus.delegate = self
    }
    
    public func start(cycles: Int) {
        cpu.execute(cycles: cycles)
    }
}

extension Nes: BusDelegate {

    func bus(_ bus: Bus, shouldReadFrom address: Address) -> Byte {
        switch address {
        case 0..<0x0200:
            return memory.readByte(from: address)
        default:
            return 0
        }
    }
    
    func bus(_ bus: Bus, shouldWrite data: Byte, to address: Address) {
        switch address {
        case 0..<0x0200:
            return memory.writeByte(data, to: address)
        default:
            return
        }
    }
}
