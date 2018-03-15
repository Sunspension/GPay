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

enum Result<T: Decodable> {
    
    case success(object: T)
    
    case error(error: Swift.Error)
    
    func onSucess(_ completion: (_ object: T) -> Void) {
        
        switch self {
            
        case .success(let object):
            completion(object)
            break
            
        default:
            break
        }
    }
    
    func onError(_ completion: (_ error: Swift.Error) -> Void) {
        
        switch self {
            
        case .error(let error):
            completion(error)
            break
            
        default:
            break
        }
    }
}

struct API {
    
    private static let provider = MoyaProvider<ApiClient>(plugins: [NetworkLoggerPlugin(verbose: true)])
    
    private init() {}
    
    static func signup(login: String, password: String) -> Single<Result<AuthResponse>> {
        
        return provider.rx.request(.signup(login: login, password: password))
            .mapResponse(AuthResponse.self)
    }
    
    static func gasStations() -> Single<Result<[GasStation]>> {
        
        return provider.rx.request(.gasStations).mapResponse([GasStation].self)
    }
    
    static func dispensers(for stationId: String) -> Single<Result<[Dispenser]>> {
        
        return provider.rx.request(.dispensers(stationId: stationId))
            .mapResponse([Dispenser].self)
    }
    
    static func makeOrder(_ order: Order) -> Single<Result<OrderResponse>> {
        
        return provider.rx.request(.order(order: order)).mapResponse(OrderResponse.self)
    }
    
    // Apple Pay payment method
    static func makePayment(orderId: String, paymentData: String) -> Single<Result<Payment>> {
        
        return provider.rx.request(.payment(orderId: orderId, paymentData: paymentData))
            .mapResponse(Payment.self)
    }
    
    fileprivate static func handleError(_ response: Response) -> Error {
        
        do {
            
            let response = try response.map(ResponseError.self, atKeyPath: "result")
            let error = Error(response: response)
            
            switch error {
                
            case .authorization:
                
                let notification = Notification(name: Notification.Name(Constants.Notification.showSingupNotification))
                NotificationCenter.default.post(notification)
                break
                
            default:
                break
            }
            
            return error
        }
        catch let error {
            
            return Error.any(error: error)
        }
    }
}

extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    
    func mapResponse<D: Decodable>(_ type: D.Type, atKeyPath keyPath: String? = "result", using decoder: JSONDecoder = JSONDecoder(), failsOnEmptyData: Bool = true) -> Single<Result<D>> {
        
        return flatMap { res -> Single<Result<D>> in
            
            do {
                
                let response = try res.map(type, atKeyPath: keyPath, using: decoder, failsOnEmptyData: failsOnEmptyData)
                return Single.just(Result.success(object: response))
            }
            catch {
                
                let error = API.handleError(res)
                return Single.just(Result.error(error: error))
            }
        }
    }
}
