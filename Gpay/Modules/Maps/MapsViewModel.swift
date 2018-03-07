//
//  MapsViewModel.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 02/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MapsViewModel {
    
    private var bag = DisposeBag()
    
    var stations = PublishSubject<[GasStation]>()
    
    var viewDidLoad = PublishRelay<Void>()
    
    
    init() {
        
        viewDidLoad
            .flatMap { API.gasStations() }
            .subscribe(onNext: { result in
                
                result.onSucess({ stations in
                    
                    self.stations.onNext(stations)
                })
                
            }).disposed(by: bag)
    }
}
