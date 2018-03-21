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
    
    var viewDidLoad = PublishRelay<Void>()
    
    
    init(_ orderId: String) {
        
        viewDidLoad.bind(onNext: {
            
            API.orderStatus(orderId: orderId)
                .subscribe(onSuccess: { result in
                
                    result.onSucess({ print($0) })
                    
                }, onError: { error in
                    
                    print(error.localizedDescription)
                    
                }).disposed(by: self._bag)
            
        }).disposed(by: _bag)
    }
}
