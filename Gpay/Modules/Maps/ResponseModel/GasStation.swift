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
    let number: Int
    
    var position: CLLocationCoordinate2D {
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension GasStation: CustomStringConvertible {
    
    var description: String {
        
        return """
        GasStation:
        id: \(id), latitude: \(latitude), longitude: \(longitude), name: \(name), number: \(number)
        """
    }
}
