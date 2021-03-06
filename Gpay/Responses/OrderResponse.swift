//
//  OrderResponse.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 15/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import Foundation

struct OrderResponse: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        
        case orderId
        
        case orderNumber = "orderNum"
    }
    
    let orderId: String
    
    let orderNumber: String
}

extension OrderResponse: CustomStringConvertible {
    
    var description: String {
        
        return "OrderId: " + orderId
    }
}
