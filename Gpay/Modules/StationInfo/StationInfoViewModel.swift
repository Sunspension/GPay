//
//  StationInfoViewModel.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 05/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class StationInfoViewModel {
    
    private let station: GasStation
    
    private var bag = DisposeBag()
    
    var onStation = PublishSubject<GasStation>()
    
    var viewDidLoad = PublishRelay<Void>()
    
    
    init(_ station: GasStation) {
        
        self.station = station
        
        self.viewDidLoad
            .subscribe(onNext: { [unowned self] _ in
            
                self.onStation.onNext(self.station)
        
            }).disposed(by: bag)
    }
    
    func nextStation(_ station: GasStation) {
        
        self.onStation.onNext(station)
    }
}
