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
    
    case dispensers(stationId: String)
    
    case order(order: Order)
    
    case payment(orderId: String, paymentData: String)
    
    case orderStatus(orderId: String)
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
        
        let first = "/loyalty."
        var last = ""
        
        switch self {
            
        case .signup:
            last = "customer"
            break
            
        case .gasStations, .dispensers:
            last = "gazstation"
            break
            
        case .order, .payment, .orderStatus:
            last = "ticket"
            break
        }
        
        return first + last
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
            break
            
        case .gasStations:
            
            request.method = "list"
            break
            
        case .dispensers(let stationId):
            
            request.method = "dispensers"
            request.params["gazStationId"] = stationId
            break
            
        case .order(let order):
            
            request.method = "order"
            request.params["gazStationId"] = order.stationId
            request.params["deviceNumber"] = order.dispenserId
            request.params["nozzleGuid"] = order.nozzle.guid
            request.params["amount"] = order.liters * order.nozzle.fuel.price
            request.params["quantity"] = order.liters
            break
            
        case .payment(let orderId, let paymentData):
            
            request.method = "apple-pay"
            request.params["orderId"] = orderId
            request.params["paymentToken"] = paymentData
            break
            
        case .orderStatus(let orderId):
            
            request.method = "order-status"
            request.params["orderId"] = orderId
            break
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
