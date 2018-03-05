//
//  MapsController.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 22/02/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import UIKit
import GoogleMaps
import Swinject
import RxSwift
import RxCocoa
import RxGoogleMaps

class MapsController: UIViewController {

    private var bag = DisposeBag()
    
    private var mapView: GMSMapView {
        
        return self.view as! GMSMapView
    }
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var zoomIn: UIButton!
    
    @IBOutlet weak var zoomOut: UIButton!
    
    @IBOutlet weak var myLocation: UIButton!
    
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
            .bind(onNext: self.onStations(_:))
            .disposed(by: bag)
    }
    
    private func setupMapView() {
        
        self.mapView.bringSubview(toFront: self.stackView)
        self.mapView.isMyLocationEnabled = true
        
        self.mapView.rx.myLocation
            .filter({ $0 != nil }).take(1)
            .map { GMSCameraUpdate.setTarget($0!.coordinate, zoom: 13) }
            .bind(to: self.mapView.rx.animate)
            .disposed(by: bag)
        
        self.zoomIn.rx.tap.map { GMSCameraUpdate.zoomIn() }
            .bind(to: self.mapView.rx.animate)
            .disposed(by: bag)
        
        self.zoomOut.rx.tap.map { GMSCameraUpdate.zoomOut() }
            .bind(to: self.mapView.rx.animate)
            .disposed(by: bag)
        
        self.myLocation.rx.tap
            .map { self.mapView.myLocation }
            .filter { $0 != nil }
            .map { GMSCameraUpdate.setTarget($0!.coordinate, zoom: 13) }
            .bind(to: self.mapView.rx.animate)
            .disposed(by: bag)
        
        self.mapView.rx.handleTapMarker {
            
            self.mapView.selectedMarker = $0
            self.mapView.animate(with: GMSCameraUpdate.setTarget($0.position))
            self.viewModel.router.openStationInfo($0.userData as! GasStation, in: self)
            return true
        }
        
        self.mapView.rx.didTapAt
            .subscribe(onNext: { coordinates in
                
                self.viewModel.router.closeStationInfo()
                self.mapView.selectedMarker = nil
                
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
