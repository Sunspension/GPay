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
        
        let signup = ApiClient.signup(login: login, password: password)
        return provider.rx.request(signup).mapResponse(AuthResponse.self)
    }
    
    static func gasStations() -> Single<[GasStation]> {
        
        return provider.rx.request(.gasStations).mapResponse([GasStation].self)
    }
    
    static func dispensers(for stationId: String) -> Single<[Dispenser]> {
        
        let dispensers = ApiClient.dispensers(stationId: stationId)
        return provider.rx.request(dispensers).mapResponse([Dispenser].self)
    }
    
    static func makeOrder(_ order: Order) -> Single<OrderResponse> {
        
        let order = ApiClient.order(order: order)
        return provider.rx.request(order).mapResponse(OrderResponse.self)
    }
    
    static func makePayment(orderId: String, paymentData: String) -> Single<Payment> {
        
        let payment = ApiClient.payment(orderId: orderId, paymentData: paymentData)
        return provider.rx.request(payment).mapResponse(Payment.self)
    }
    
    static func orderStatus(orderId: String) -> Single<OrderStatus> {
        
        let status = ApiClient.orderStatus(orderId: orderId)
        return provider.rx.request(status).mapResponse(OrderStatus.self)
    }
    
    fileprivate static func handleError(_ response: Response) -> Error {
        
        do {
            
            let response = try response.map(ResponseError.self, atKeyPath: "result")
            let error = Error(response: response)
            
            switch error {
                
            case .authorization:
                
                let name = Notification.Name(Constants.Notification.showSingup)
                let notification = Notification(name: name)
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
