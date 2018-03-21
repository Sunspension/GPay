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
        
        Observable<OrderStatus>.create { [unowned self] observer in
            
            API.orderStatus(orderId: self.orderId)
                .subscribe(onSuccess: { status in
            
                    self.loadingActivity.accept(false)
                    observer.on(.next(status))
                    
                    if status.state == .waitingRefueling || status.state == .canceled {
                        
                        observer.on(.completed)
                    }
                    
                }, onError: { observer.onError($0) }).disposed(by: self._bag)
            
            return Disposables.create()
            
            }.bind(onNext: { [weak self] status in
                
                self?.orderStatus.accept(status)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                    
                    self?.requestOrderStatus()
                })
                
            }).disposed(by: _bag)
    }
}
