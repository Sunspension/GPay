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
    
    private let _bag = DisposeBag()
    
    private let orderId: String
    
    var viewDidLoad = PublishRelay<Void>()
    
    var orderStatus = PublishRelay<OrderStatus>()
    
    var loadingActivity = PublishRelay<Bool>()
    
    deinit {
        
        print("\(self): \(#function)")
    }
    
    init(_ orderId: String) {
        
        self.orderId = orderId
        
        viewDidLoad.bind(onNext: { [unowned self] in
            
            self.loadingActivity.accept(true)
            self.requestOrderStatus()
            
        }).disposed(by: _bag)
    }
    
    private func requestOrderStatus() {
        
        API.orderStatus(orderId: self.orderId)
            .subscribe(onSuccess: { [weak self] status in
                
                self?.loadingActivity.accept(false)
                self?.orderStatus.accept(status)
                
                print(status)
                
                if status.state != .waitingRefueling &&
                    status.state != .canceled {
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                        
                        self?.requestOrderStatus()
                    })
                }
                
            }).disposed(by: self._bag)
    }
}
