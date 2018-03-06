//
//  GasStation.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 02/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import Foundation
import CoreLocation

struct GasStation: Decodable {
    
    let id: String
    let latitude: Double
    let longitude: Double
    let name: String
    let address: String
    let number: Int
    
    var position: CLLocationCoordinate2D {
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension GasStation: CustomStringConvertible {
    
    var description: String {
        
        return """
        GasStation:
        id: \(id), latitude: \(latitude), longitude: \(longitude), name: \(name), address: \(address), number: \(number)
        """
    }
}

extension GasStation: Equatable {
    
    public static func ==(lhs: GasStation, rhs: GasStation) -> Bool {
        
        return lhs.id == rhs.id
    }
}

extension GasStation: Hashable {
    
    public var hashValue: Int {
        
        return self.id.hashValue ^ 56
    }
}
