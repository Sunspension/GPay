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
    
    private var bag = DisposeBag()
    
    private var _station: GasStation
    
    
    var station: GasStation {
        
        return _station
    }
    
    var onStation = PublishSubject<GasStation>()
    
    var onDispensers = PublishSubject<[Dispenser]>()
    
    var viewDidLoad = PublishRelay<Void>()
    
    
    init(_ station: GasStation) {
        
        _station = station
        
        self.viewDidLoad
            .subscribe(onNext: { [unowned self] _ in self.onStation(station) })
            .disposed(by: bag)
    }
    
    func nextStation(_ station: GasStation) {
        
        self.onStation(station)
    }
    
    private func onStation(_ station: GasStation) {
        
        _station = station
        self.onStation.onNext(station)
        
        API.dispensers(for: station.id)
            .subscribe(onSuccess: { [weak self] result in
                
                result.onSucess({ self?.onDispensers.onNext($0) })
                
            }).disposed(by: self.bag)
    }
}
