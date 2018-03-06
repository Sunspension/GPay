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
    
    case gasStations
    
    case refuelers(stationId: String)
}

private enum CodingKeys: String, CodingKey {

    case jsonrpc, method, params
}

struct RequestObject {
    
    var method = ""
    
    var params = [String : Any]()
    
    
    mutating func requestParams() -> [String : Any] {
        
        var par = [String : Any]()
        
        par["jsonrpc"] = "2.0"
        par["method"] = method
        
        if let auth = StorageManager.auth {
            
            params["token"] = auth.token
        }
        
        par["params"] = params
        
        return par
    }
}

extension ApiClient: TargetType {
    
    var baseURL: URL {
        
        return URL(string: "http://178.159.32.137:8080/api/jsonws")!
    }
    
    var path: String {
        
        switch self {
            
        case .signup:
            return "/loyalty.customer"
            
        case .gasStations,
             .refuelers:
            return "/loyalty.gazstation"
        }
    }
    
    var method: Moya.Method {
        
        return .post
    }
    
    var parameters: [String : Any] {
        
        var request = RequestObject()
        
        switch self {
            
        case .signup(let login, let password):
            
            request.method = "token"
            request.params["phone"] = login
            request.params["password"] = password
            
        case .gasStations:
            
            request.method = "list"
            
        case .refuelers(let stationId):
            
            request.method = "dispensers"
            request.params["gazStationId"] = stationId
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
