//
//  Refueler.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 06/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import Foundation

struct Refueler: Decodable {
    
    private enum CodingKeys: String, CodingKey {

        case isLock = "lock"
        case deviceNumber
        case nozzles
    }
    
    let deviceNumber: Int
    let isLock: Bool
    let nozzles: [Nozzle]
}

struct Nozzle: Decodable {
    
    private enum CodingKeys: String, CodingKey {

        case isLock = "lock"
        case number
        case guid
        case fuel
    }
    
    let isLock: Bool
    let number: Int
    let guid: String
    let fuel: Fuel
}

struct Fuel: Decodable {
    
    private enum CodingKeys: String, CodingKey {

        case isLock = "lock"
        case name
        case price
    }
    
    let name: String
    let isLock: Bool
    let price: Double
}

extension Fuel: Equatable {
    
    static func ==(lhs: Fuel, rhs: Fuel) -> Bool {
        
        return lhs.name == rhs.name
    }
}

extension Fuel: Hashable {
    
    var hashValue: Int {
        
        return name.hashValue ^ 66
    }
}
