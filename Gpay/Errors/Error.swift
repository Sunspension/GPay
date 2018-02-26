//
//  Error.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 26/02/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import Foundation

enum Error: Swift.Error {
    
    case response(response: ResponseError)
    
    case system
    
    case any(error: Swift.Error)
    
    
    init(response: ResponseError) {
        
        switch response.errorCode {
            
        case "LT-1":
            self = .system
            
        default:
            self = .response(response: response)
        }
    }
}

extension Error: LocalizedError {
    
     public var errorDescription: String? {
        
        switch self {
            
        case .any(let error):
            return error.localizedDescription
            
        case .system:
            return "System error"
            
        case .response(let response):
            return response.errorMessage
        }
    }
}
