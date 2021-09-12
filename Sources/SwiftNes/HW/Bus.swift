//
//  Bus.swift
//  SwiftNes
//
//  Created by Tibor Bodecs on 2021. 09. 08..
//

import Foundation

protocol BusDevice {
    /// reads a byte from a given address
    func readByte(from: Address) -> Byte
    /// writes a byte to a given address
    func writeByte(_: Byte, to: Address)
}

protocol BusDelegate: AnyObject {
    /// handles actual read operation using the bus devices
    func bus(_: Bus, shouldReadFrom: Address) -> Byte
    /// handles actual write operation using the bus devices
    func bus(_: Bus, shouldWrite: Byte, to: Address)
}

final class Bus {

    /// bus delegate
    weak var delegate: BusDelegate?
 
    /// initialize a bus object
    init() {
        
    }

    /// reads a byte from a given address on the bus
    func readByte(from address: Address) -> Byte {
        delegate?.bus(self, shouldReadFrom: address) ?? 0
    }
    
    /// writes a byte to a given address on the bus
    func writeByte(_ data: Byte, to address: Address) {
        delegate?.bus(self, shouldWrite: data, to: address)
    }
}
