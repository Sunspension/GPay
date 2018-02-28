//
//  API.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 21/02/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import Foundation
import Moya
import RxSwift

struct API {
    
    private static let provider = MoyaProvider<ApiClient>(plugins: [NetworkLoggerPlugin(verbose: true)])
    
    private init() {}
    
    static func signup(login: String, password: String) -> Single<AuthResponse> {
        
        return provider
            .rx
            .request(.signup(login: login, password: password))
            .mapResponse(AuthResponse.self)
    }
    
    static func handleError(_ response: Response) -> Error {
        
        do {
            
            let response = try response.map(ResponseError.self)
            return Error(response: response)
        }
        catch let error {
            
            return Error.any(error: error)
        }
    }
}

extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    
    public func mapResponse<D: Decodable>(_ type: D.Type, atKeyPath keyPath: String? = "result", using decoder: JSONDecoder = JSONDecoder(), failsOnEmptyData: Bool = true) -> Single<D> {
        
        return flatMap { res -> Single<D> in
            
            do {
                
                let response = try res.map(type, atKeyPath: keyPath, using: decoder, failsOnEmptyData: failsOnEmptyData)
                return Single.just(response)
            }
            catch {
                
                throw API.handleError(res)
            }
        }
    }
}
