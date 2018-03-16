//
//  OrderDetailsViewModel.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 15/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class OrderDetailsViewModel {
    
    private let bag = DisposeBag()
    
    let order: Order
    
    let station: GasStation
    
    let error = PublishRelay<Swift.Error?>()
    
    let activity = PublishRelay<Bool>()
    
    let dismiss = PublishRelay<Void>()
    
    var makePayment = Observable<Void>.empty() {
        
        willSet {
            
            newValue.subscribe(onNext: { [unowned self] in
                
                self.activity.accept(true)
                
                API.makeOrder(self.order)
                    .subscribe(onSuccess: { result in
                    
                        self.activity.accept(false)
                        
                        result.onSucess({ order in
                            
                            self.orderNotify(order)
                            self.dismiss.accept(Void())
                        })
                        result.onError({ self.error.accept($0) })
                        
                    }, onError: {
                    
                        self.activity.accept(true)
                        self.error.accept($0)
                    })
                    .disposed(by: self.bag)
                
            }).disposed(by: bag)
        }
    }
    
    init(order: Order, station: GasStation) {
        
        self.station = station
        self.order = order
    }
    
    private func orderNotify(_ order: OrderResponse) {
        
        let name = Notification.Name(Constants.Notification.orderReadyToPayment)
        let notification = Notification(name: name, object: order, userInfo: nil)
        NotificationCenter.default.post(notification)
    }
}
