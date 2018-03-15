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
    case wrongPhoneFormat
    case emptyPhone
    case incorrectPassword
    case authorization
    case any(error: Swift.Error)
    
    
    init(response: ResponseError) {
        
        switch response.errorCode {
            
        case "LT--1":
            self = .system
            
        case "LT-33":
            self = .wrongPhoneFormat
            
        case "LT-32":
            self = .emptyPhone
            
        case "LT-86":
            self = .incorrectPassword
            
        case "LT-403":
            self = .authorization
            
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
            
        case .wrongPhoneFormat:
            return "Phone number must contains 10 digits"
            
        case .emptyPhone:
            return "Phone number can not be empty"
            
        case .incorrectPassword:
            return "Incorrect password"
            
        case .authorization:
            return "Unauthorized request"
            
        case .response(let response):
            return response.errorMessage
        }
    }
}
