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

enum CodingKeys: String, CodingKey {

    case jsonrpc, method, params
}

struct RequestObject {
    
    var method = ""
    
    var params = [String : Any]()
    
    
    func requestParams() -> [String : Any] {
        
        var par = [String : Any]()
        
        par["jsonrpc"] = "2.0"
        par["method"] = method
        par["params"] = params
        
        return par
    }
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
        }
    }
    
    var parameters: [String : Any] {
        
        var request = RequestObject()
        
        switch self {
            
        case .signup(let login, let password):

            request.method = "token"
            request.params["phone"] = login
            request.params["password"] = password
        }
        
        let params = request.requestParams()
        
        return params
    }
    
    var sampleData: Data {
        
        return Data()
    }
    
    var task: Moya.Task {
        
        switch self {
            
        default:
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        
        return nil
    }
}
