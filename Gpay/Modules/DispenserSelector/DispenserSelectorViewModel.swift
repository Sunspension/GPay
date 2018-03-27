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

typealias DispenserSelectorSection = AnimatableSectionModel<String, DispenserSelectorSectionData>


class DispenserSelectorViewModel {
    
    private var _bag = DisposeBag()
    
    private var _dispensers = [Dispenser]()
    
    private var _nozzles = [Nozzle]()
    
    private var _selectedDispenserIndex: Int?
    
    private var _dispenserSection: DispenserSelectorSection?
    
    var station: GasStation
    
    var order = BehaviorRelay<Order?>(value: nil)
    
    var payment = BehaviorRelay<(orderId: String, order: Order)?>(value: nil)
    
    var successPayment = BehaviorRelay<String?>(value: nil)
    
    var sections = BehaviorRelay<[DispenserSelectorSection]>(value: [DispenserSelectorSection]())
    
    var viewDidLoad = PublishRelay<Void>()
    
    var loadingActivity = PublishSubject<Bool>()
    
    var selectedFuelIndex = BehaviorRelay<Int?>(value: nil)
    
    var error = PublishSubject<Swift.Error>()
    
    var orderResponse: OrderResponse?
    
    var liters = BehaviorRelay(value: "")
    
    var amount = BehaviorRelay(value: "")
    
    var isCanMakePayments: Observable<Bool> {
        
        return liters.flatMap({ Observable.just((Double($0) ?? 0) != 0) })
    }
    
    var makeOrder = Observable<Void>.empty() {
        
        willSet {
            
            newValue
                .map({ (nozzle: self._nozzles[self.selectedFuelIndex.value!], liters: Double(self.liters.value)!) })
                .subscribe(onNext: { [unowned self] pair in
                    
                    let order = self.createOrder(pair.nozzle, liters: pair.liters)
                    self.order.accept(order)
                    
                }).disposed(by: _bag)
        }
    }
    
    init(_ station: GasStation) {
        
        self.station = station
        
        self.viewDidLoad
            .subscribe(onNext: { [unowned self] _ in self.loadDispensers() })
            .disposed(by: _bag)
        
        self.liters.bind { [unowned self] liters in
            
            guard
                self._nozzles.count > 0,
                self.selectedFuelIndex.value != nil else { return }
            
            let nozzle = self._nozzles[self.selectedFuelIndex.value!]
            self.calculateAmount(nozzle.fuel, liters: liters)
            
        }.disposed(by: _bag)
        
        let name = Notification.Name(Constants.Notification.orderReadyToPayment)
        NotificationCenter.default.rx
            .notification(name, object: nil)
            .asObservable()
            .subscribe(onNext: { [unowned self] notification in
                
                let orderResponse = notification.object as! OrderResponse
                self.orderResponse = orderResponse
                
                // Sometimes the order become to nil, probably it is cauze of a bug in RxCocoa
                // or cauze of disponsing. Couldn't find where is the problem.
                if let order = self.order.value {
                    
                    self.payment.accept((orderResponse.orderId, order))
                }
                
            }).disposed(by: _bag)
        
        let paymentName = Notification.Name(Constants.Notification.successPayment)
        NotificationCenter.default.rx
            .notification(paymentName, object: nil)
            .asObservable()
            .subscribe(onNext: { [unowned self] notification in
                
                self.successPayment.accept(self.orderResponse!.orderId)
                
            }).disposed(by: _bag)
        
        selectedFuelIndex.asObservable()
            .filter({ $0 != nil })
            .bind { index in
            
                let liters = Double(self.liters.value) ?? 0.00
                guard liters > 0 else { return }
                
                let nozzle = self._nozzles[index!]
                self.calculateAmount(nozzle.fuel, liters: self.liters.value)
            
        }.disposed(by: _bag)
    }
    
    private func calculateAmount(_ fuel: Fuel, liters: String) {
        
        let amount = (Double(liters) ?? 0) * fuel.price
        let amountString = amount == 0 ? "" : String(format: "%.2f", amount)
        self.amount.accept(amountString)
    }
    
    func onDidSelectDispenser(_ index: Int) {
        
        selectedFuelIndex.accept(nil)
        
        _selectedDispenserIndex = index
        _nozzles = _dispensers[index].nozzles
        
        let items = _nozzles.map({ DispenserSelectorSectionData(type: .fuel(fuel: $0.fuel)) })
        let fuelSection = DispenserSelectorSection(model: UUID().uuidString, items: items)
        
        self.sections.accept([_dispenserSection!, fuelSection])
    }
    
    func resetCalculator() {
        
        self.liters.accept("")
        self.amount.accept("")
    }
    
    private func loadDispensers() {
        
        self.loadingActivity.onNext(true)
        
        API.dispensers(for: station.id)
            .subscribe(onSuccess: { [unowned self] dispensers in
        
                self.loadingActivity.onNext(false)
                self._dispensers = dispensers
                self.createDispenserSection()
                self.sections.accept([self._dispenserSection!])
                
                }, onError: { [weak self] error in
                    
                    self?.loadingActivity.onNext(false)
                    self?.error.onNext(error)
            })
            .disposed(by: _bag)
    }
    
    private func createOrder(_ nozzle: Nozzle, liters: Double) -> Order {
        
        let index = _selectedDispenserIndex!
        let deviceNumber = _dispensers[index].deviceNumber
        
        return Order(dispenserIndex: index + 1, stationId: self.station.id, dispenserId: deviceNumber, nozzle: nozzle, liters: liters)
    }
    
    private func createDispenserSection() {
        
        var items = [(index: Int, dispenser: Dispenser?)]()
        
        for index in [0, 1, 2, 3, 4, 5, 6, 7] {
            
            if self._dispensers.count > index {
                
                let dispenser = self._dispensers[index]
                items.append((index: index, dispenser: dispenser))
            }
            else {
                
                items.append((index: index, dispenser: nil))
            }
        }
        
        let dispensers = DispenserSelectorSectionData(type: .dispensers(items: items))
        let title = DispenserSelectorSectionData(type: .title(text: "Выберите колонку"))
        
        _dispenserSection = DispenserSelectorSection(model: UUID().uuidString, items: [title, dispensers])
    }
}
