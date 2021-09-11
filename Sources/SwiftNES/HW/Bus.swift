//
//  Bus.swift
//  SwiftNES
//
//  Created by Tibor Bodecs on 2021. 09. 08..
//

import Foundation

protocol BusDevice {
    func readByte(from: Address) -> Byte
    func writeByte(_: Byte, to: Address)
}

protocol BusDelegate: AnyObject {
    func bus(_: Bus, shouldReadFrom: Address) -> Byte
    func bus(_: Bus, shouldWrite: Byte, to: Address)
}

final class Bus {

    weak var delegate: BusDelegate?
 
    init() {
        
    }

    func readByte(from address: Address) -> Byte {
        delegate?.bus(self, shouldReadFrom: address) ?? 0
    }
    
    func writeByte(_ data: Byte, to address: Address) {
        delegate?.bus(self, shouldWrite: data, to: address)
    }
}
