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
        return address
    }
    
    func fetchZeroPageYAddress() -> Address {
        /// Add the fetched address using the overlfow operator (&+) to the y register value
        /// +1 cycle
        let address = Address(fetch() &+ registers.y)
        return address
    }
    
    func fetchAbsoluteAddress() -> Address {
        fetchWord()
    }
    
    func fetchAbsoluteXAddress(cycles: inout Int) -> Address {
        let address = fetchWord()
        let addressX = address + Address(registers.x)
        /// if diff is bigger than 0xFF, we've crossed a page
        if addressX - address >= 0xFF {
            cycles += 1
        }
        return addressX
    }
    
    func fetchAbsoluteXAddress() -> Address {
        var cycles: Int = 0
        return fetchAbsoluteXAddress(cycles: &cycles)
    }
    
    func fetchAbsoluteYAddress(cycles: inout Int) -> Address {
        let address = fetchWord()
        let addressY = address + Address(registers.y)
        /// if diff is bigger than 0xFF, we've crossed a page
        if addressY - address >= 0xFF {
            cycles += 1
        }
        return addressY
    }
    
    func fetchAbsoluteYAddress() -> Address {
        var cycles: Int = 0
        return fetchAbsoluteYAddress(cycles: &cycles)
    }
    
    func fetchIndexedIndirectAddress() -> Address {
        /// Add the fetched address using the overlfow operator (&+) to the x register value
        /// +1 cycle
        let address = Address(fetch() &+ registers.x)
        let pointerAddress = readWord(address)
        return pointerAddress
    }
    
    func fetchIndirectIndexedAddress(cycles: inout Int) -> Address {
        let pointerAddress = Address(fetch())
        let indirectAddress = readWord(pointerAddress)
        let address = indirectAddress + Address(registers.y)
        /// if diff is bigger than 0xFF, we've crossed a page
        if address - indirectAddress >= 0xFF {
            cycles += 1
        }
        return address
    }
    
    func fetchIndirectIndexedAddress() -> Address {
        var cycles: Int = 0
        return fetchIndirectIndexedAddress(cycles: &cycles)
    }
}
