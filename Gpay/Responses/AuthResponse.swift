//
//  AuthResponse.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 22/02/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import Foundation

struct AuthResponse: Codable {
    
    let token: String
    
    let tokenExpirationAt: TimeInterval
}

extension AuthResponse: CustomStringConvertible {
    
    var description: String {
        
        return "AuthResponse: token: \(token), tokenExpiration: \(tokenExpirationAt)"
    }
}
