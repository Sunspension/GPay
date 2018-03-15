//
//  Payment.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 15/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import Foundation

struct Payment: Decodable {
    
    let status: String
    
    var isSuccess: Bool {
        
        return status == "success"
    }
}

extension Payment: CustomStringConvertible {
    
    var description: String {
        
        return "isSuccess: \(isSuccess)"
    }
}
