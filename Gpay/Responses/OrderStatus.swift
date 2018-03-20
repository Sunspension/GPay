//
//  OrderStatus.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 16/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import Foundation

enum OrderStatusEnum: String {
    
    case undefined
    case new = "NEW"
    case pendingPayment = "PENDING_PAYMENT"
    case waitingRefueling = "WAITING_REFUELING"
    case completed = "COMPLETED"
    case canceled =  "CANCELED"
}

struct OrderStatus: Decodable {
    
    let status: String
    
    var state: OrderStatusEnum {
        
        return OrderStatusEnum(rawValue: status) ?? OrderStatusEnum.undefined
    }
}
