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
    
    var onRefuelers = PublishSubject<[Refueler]>()
    
    var viewDidLoad = PublishRelay<Void>()
    
    
    init(_ station: GasStation) {
        
        self.station = station
        
        self.viewDidLoad
            .subscribe(onNext: { [unowned self] _ in self.onStation(station) })
            .disposed(by: bag)
    }
    
    func nextStation(_ station: GasStation) {
        
        self.onStation(station)
    }
    
    private func onStation(_ station: GasStation) {
        
        self.onStation.onNext(station)
        
        API.refuelers(for: station.id)
            .subscribe(onSuccess: { result in
                
                result.onSucess({ self.onRefuelers.onNext($0) })
                
            }).disposed(by: self.bag)
    }
}
