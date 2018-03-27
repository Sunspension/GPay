//
//  MapsController.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 22/02/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import UIKit
import GoogleMaps
import RxSwift
import RxCocoa
import RxGoogleMaps

class MapsController: UIViewController {

    private let bag = DisposeBag()
    
    private var mapView: GMSMapView {
        
        return view as! GMSMapView
    }
    
    private var selectedMarker: GMSMarker?
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var zoomIn: UIButton!
    
    @IBOutlet weak var zoomOut: UIButton!
    
    @IBOutlet weak var myLocation: UIButton!
    
    var router: MapsRoutable!
    
    var viewModel: MapsViewModel! {
        
        willSet {
            
            self.rx.viewDidLoad
                .bind(to: newValue.viewDidLoad)
                .disposed(by: bag)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupMapView()
        setupViewModel()
    }
    
    private func setupViewModel() {
        
        self.viewModel.stations
            .bind(onNext: { [unowned self] in self.onStations($0) })
            .disposed(by: bag)
    }
    
    private func setupMapView() {
        
        self.mapView.bringSubview(toFront: stackView)
        self.mapView.isMyLocationEnabled = true
        
        self.mapView.rx.myLocation
            .filter({ $0 != nil }).take(1)
            .map { GMSCameraUpdate.setTarget($0!.coordinate, zoom: 13) }
            .bind(to: mapView.rx.animate)
            .disposed(by: bag)
        
        self.zoomIn.rx.tap.map { GMSCameraUpdate.zoomIn() }
            .bind(to: mapView.rx.animate)
            .disposed(by: bag)
        
        self.zoomOut.rx.tap.map { GMSCameraUpdate.zoomOut() }
            .bind(to: mapView.rx.animate)
            .disposed(by: bag)
        
        self.myLocation.rx.tap
            .map { [unowned self] in self.mapView.myLocation }
            .filter { $0 != nil }
            .map { GMSCameraUpdate.setTarget($0!.coordinate, zoom: 13) }
            .bind(to: mapView.rx.animate)
            .disposed(by: bag)
        
        self.mapView.rx.handleTapMarker { [unowned self] in
            
            self.selectedMarker?.icon = R.image.pin()
            $0.icon = R.image.pinSelected()
            self.selectedMarker = $0
            self.mapView.animate(with: GMSCameraUpdate.setTarget($0.position))
            self.router.openStationInfo($0.userData as! GasStation, in: self)
            
            return true
        }
        
        self.mapView.rx.didTapAt
            .subscribe(onNext: { [unowned self] coordinates in
                
                let marker = self.selectedMarker
                marker?.icon = R.image.pin()
                self.selectedMarker = nil
                self.router.closeStationInfo()
                
            }).disposed(by: bag)
    }
    
    private func onStations(_ stations: [GasStation]) {
        
        for station in stations {
            
            let marker = GMSMarker(position: station.position)
            marker.icon = R.image.pin()
            marker.map = mapView
            marker.userData = station
        }
    }
}
