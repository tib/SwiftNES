//
//  Cpu+AddressingModes.swift
//  SwiftNes
//
//  Created by Tibor Bodecs on 2021. 09. 09..
//

import Foundation

extension Cpu {

    /// http://www.obelisk.me.uk/6502/addressing.html
    enum AddressingMode {
        case implicit
        case accumulator
        case immediate
        case zeroPage
        case zeroPageX
        case zeroPageY
        case absolute
        case absoluteX
        case absoluteY
        case relative
        case indirect
        case indexedIndirect
        case indirectIndexed
    }
    
    // MARK: - fetch given address

    func fetchZeroPageAddress() -> Address {
        Address(fetch())
    }
    
    func fetchZeroPageXAddress() -> Address {
        /// Add the fetched address using the overlfow operator (&+) to the x register value
        /// +1 cycle
        let address = Address(fetch() &+ registers.x)
        totalCycles += 1
        return address
    }
    
    func fetchZeroPageYAddress() -> Address {
        /// Add the fetched address using the overlfow operator (&+) to the y register value
        /// +1 cycle
        let address = Address(fetch() &+ registers.y)
        totalCycles += 1
        return address
    }
    
    func fetchAbsoluteAddress() -> Address {
        fetchWord()
    }
    
    func fetchAbsoluteXAddress() -> Address {
        let address = fetchWord()
        let addressX = address + Address(registers.x)
        /// if diff is bigger than 0xFF, we've crossed a page
        if addressX - address >= 0xFF {
            totalCycles += 1
        }
        return addressX
    }

    func fetchAbsoluteYAddress() -> Address {
        let address = fetchWord()
        let addressY = address + Address(registers.y)
        /// if diff is bigger than 0xFF, we've crossed a page
        if addressY - address >= 0xFF {
            totalCycles += 1
        }
        return addressY
    }
    
    func fetchIndexedIndirectAddress() -> Address {
        /// Add the fetched address using the overlfow operator (&+) to the x register value
        /// +1 cycle
        let address = Address(fetch() &+ registers.x)
        totalCycles += 1
        let pointerAddress = readWord(address)
        return pointerAddress
    }
    
    func fetchIndirectIndexedAddress() -> Address {
        let pointerAddress = Address(fetch())
        let indirectAddress = readWord(pointerAddress)
        let address = indirectAddress + Address(registers.y)
        /// if diff is bigger than 0xFF, we've crossed a page
        if address - indirectAddress >= 0xFF {
            totalCycles += 1
        }
        return address
    }
}
