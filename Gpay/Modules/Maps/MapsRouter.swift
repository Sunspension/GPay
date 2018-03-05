//
//  MapsRouter.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 02/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import UIKit

protocol MapsRoutable {
    
    func openStationInfo(_ station: GasStation, in view: UIViewController)
    
    func closeStationInfo()
}

class MapsRouter: MapsRoutable {
    
    private let wireframe: Wireframe
    
    private var station: GasStation?
    
    private weak var presentedInfo: StationInfoController?
    
    
    init(wireframe: Wireframe) {
        
        self.wireframe = wireframe
    }
    
    func openStationInfo(_ station: GasStation, in view: UIViewController) {
        
        guard station != self.station else { return }
        
        if self.presentedInfo != nil {
            
            self.presentedInfo?.viewModel.nextStation(station)
        }
        else {
            
            let info = wireframe.container.resolve(StationInfoController.self, argument: station)!
            view.present(info, animated: true, completion: nil)
            self.presentedInfo = info
        }
        
        self.station = station
    }
    
    func closeStationInfo() {
        
        guard let info = self.presentedInfo else { return }
        
        info.dismiss(animated: true, completion: nil)
        self.station = nil
    }
}
