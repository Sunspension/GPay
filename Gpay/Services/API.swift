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
        
        return provider.rx.request(.signup(login: login, password: password))
            .mapResponse(AuthResponse.self)
    }
    
    static func gasStations() -> Single<[GasStation]> {
        
        return provider.rx.request(.gasStations).mapResponse([GasStation].self)
    }
    
    static func dispensers(for stationId: String) -> Single<[Dispenser]> {
        
        return provider.rx.request(.dispensers(stationId: stationId))
            .mapResponse([Dispenser].self)
    }
    
    static func makeOrder(_ order: Order) -> Single<OrderResponse> {
        
        return provider.rx.request(.order(order: order)).mapResponse(OrderResponse.self)
    }
    
    // Apple Pay payment method
    static func makePayment(orderId: String, paymentData: String) -> Single<Payment> {
        
        return provider.rx.request(.payment(orderId: orderId, paymentData: paymentData))
            .mapResponse(Payment.self)
    }
    
    static func orderStatus(orderId: String) -> Single<OrderStatus> {
        
        return provider.rx.request(.orderStatus(orderId: orderId)).mapResponse(OrderStatus.self)
    }
    
    fileprivate static func handleError(_ response: Response) -> Error {
        
        do {
            
            let response = try response.map(ResponseError.self, atKeyPath: "result")
            let error = Error(response: response)
            
            switch error {
                
            case .authorization:
                
                let notification = Notification(name: Notification.Name(Constants.Notification.showSingup))
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
    
    func mapResponse<D: Decodable>(_ type: D.Type, atKeyPath keyPath: String? = "result", using decoder: JSONDecoder = JSONDecoder(), failsOnEmptyData: Bool = true) -> Single<D> {
        
        return flatMap { res in
            
            return Single.create(subscribe: { event in
                
                do {
                    
                    let response = try res.map(type, atKeyPath: keyPath, using: decoder, failsOnEmptyData: failsOnEmptyData)
                    event(SingleEvent<D>.success(response))
                }
                catch {
                    
                    let error = API.handleError(res)
                    event(SingleEvent<D>.error(error))
                }
                
                return Disposables.create()
            })
        }
    }
}
