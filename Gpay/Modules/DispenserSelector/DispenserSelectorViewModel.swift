//
//  DispenserSelectorViewModel.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 13/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

typealias FuelSection = AnimatableSectionModel<String, Fuel>

class DispenserSelectorViewModel {
    
    private var bag = DisposeBag()
    
    private var _dispensers = BehaviorRelay(value: [Dispenser]())
    
    private var _nozzles = [Nozzle]()
    
    private var _selectedDispenserIndex: Int?
    
    var station: GasStation
    
    var order = BehaviorRelay<Order?>(value: nil)
    
    var dispensers = PublishSubject<[Dispenser]>()
    
    var fuelSection = BehaviorRelay(value: [FuelSection]())
    
    var viewDidLoad = PublishRelay<Void>()
    
    var loadingActivity = PublishSubject<Bool>()
    
    var selectedFuelIndex = BehaviorRelay<Int?>(value: nil)
    
    var error = PublishSubject<Swift.Error>()
    
    var isCanMakePayments: Observable<Bool> {
        
        return selectedFuelIndex.flatMap({ Observable.just($0 != nil) })
    }
    
    var makeOrder = Observable<Void>.empty() {
        
        willSet {
            
            newValue
                .map({ self._nozzles[self.selectedFuelIndex.value!] })
                .subscribe(onNext: { nozzle in
                    
                    let order = self.createOrder(nozzle, liters: 10)
                    self.order.accept(order)
                    
                }).disposed(by: bag)
        }
    }
    
    init(_ station: GasStation) {
        
        self.station = station
        
        self.viewDidLoad
            .subscribe(onNext: { [unowned self] _ in self.loadDispensers() })
            .disposed(by: bag)
    }
    
    func onDidSelectDispenser(_ index: Int) {
        
        selectedFuelIndex.accept(nil)
        
        _selectedDispenserIndex = index
        _nozzles = _dispensers.value[index].nozzles
        
        let section = FuelSection(model: UUID().uuidString, items: _nozzles.map({ $0.fuel }))
        fuelSection.accept([section])
    }
    
    private func loadDispensers() {
        
        self.loadingActivity.onNext(true)
        
        API.dispensers(for: station.id)
            .subscribe(onSuccess: { [weak self] result in
        
                self?.loadingActivity.onNext(false)
                
                result.onSucess ({
                    
                    self?._dispensers.accept($0)
                    self?.dispensers.onNext($0) })
                
                result.onError({ error in
                    
                    self?.loadingActivity.onNext(false)
                    self?.error.onNext(error)
                })
                
                }, onError: { [weak self] error in
                    
                    self?.loadingActivity.onNext(false)
                    self?.error.onNext(error)
            })
            .disposed(by: self.bag)
    }
    
    private func createOrder(_ nozzle: Nozzle, liters: Double) -> Order {
        
        let index = _selectedDispenserIndex!
        let deviceNumber = _dispensers.value[index].deviceNumber
        
        return Order(dispenserIndex: index + 1, stationId: self.station.id, dispenserId: deviceNumber, nozzle: nozzle, liters: liters)
    }
}
