//
//  Refueler.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 06/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import Foundation
import RxDataSources

struct Dispenser: Decodable {
    
    private enum CodingKeys: String, CodingKey {

        case isLocked = "lock"
        case deviceNumber
        case nozzles
    }
    
    let deviceNumber: Int
    let isLocked: Bool
    let nozzles: [Nozzle]
}

struct Nozzle: Decodable {
    
    private enum CodingKeys: String, CodingKey {

        case isLocked = "lock"
        case number
        case guid
        case fuel
    }
    
    let isLocked: Bool
    let number: Int
    let guid: String
    let fuel: Fuel
}

struct Fuel: Decodable {
    
    private enum CodingKeys: String, CodingKey {

        case isLocked = "lock"
        case name
        case price
    }
    
    let name: String
    let isLocked: Bool
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

extension Fuel: IdentifiableType {
    
    typealias Identity = Fuel
    
    var identity: Fuel {
        
        return self
    }
}
