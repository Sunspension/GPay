//
//  OrderStatusViewModel.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 19/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class OrderStatusViewModel {
    
    private var orderId: String
    
    private let bag = DisposeBag()
    
    var viewDidLoad = PublishRelay<Void>()
    
    
    init(_ orderId: String) {
        
        self.orderId = orderId
        
        viewDidLoad.bind(onNext: {
            
            API.orderStatus(orderId: self.orderId)
                .subscribe(onSuccess: { result in
                
//                    result.onSucess(<#T##completion: (OrderStatus) -> Void##(OrderStatus) -> Void#>)
                    
                }, onError: { error in
                    
                    
                }).disposed(by: self.bag)
            
        }).disposed(by: bag)
    }
}
