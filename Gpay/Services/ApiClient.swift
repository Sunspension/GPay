//
//  ApiClient.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 21/02/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import Foundation
import Moya

enum ApiClient {
    
    case signup(login: String, password: String)
}

extension ApiClient: TargetType {
    
    var baseURL: URL {
        
        return URL(string: Constants.API.baseURL)!
    }
    
    var path: String {
        
        switch self {
            
        case .signup:
            return Constants.API.singupPath
        }
    }
    
    var method: Moya.Method {
        
        switch self {
            
        case .signup:
            return .post
            
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        
        return Data()
    }
    
    var task: Moya.Task {
        
        switch self {
            
        default:
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        
        return nil
    }
}
