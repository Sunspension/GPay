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

class MapsController: UIViewController {

    private var bag = DisposeBag()
    
    private var mapView: GMSMapView {
        
        return self.view as! GMSMapView
    }
    
    @IBOutlet weak var stackView: UIStackView!
    
    var viewModel: MapsViewModel! {
        
        willSet {
            
            newValue.stations
                .bind(onNext: self.onStations(_:))
                .disposed(by: bag)
            
            self.rx.viewDidLoad
                .map { self.mapView.bringSubview(toFront: self.stackView) }
                .bind(to: newValue.viewDidLoad)
                .disposed(by: bag)
        }
    }
    
    private func onStations(_ stations: [GasStation]) {
        
        for station in stations {
            
            let position = CLLocationCoordinate2D(latitude: station.latitude, longitude: station.longitude)
            let marker = GMSMarker(position: position)
            marker.icon = R.image.pin()
            marker.map = mapView
            
            let camera = GMSCameraPosition.camera(withTarget: position, zoom: 10)
            mapView.animate(to: camera)
        }
    }
}
