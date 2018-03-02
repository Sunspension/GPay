//
//  MapsRouter.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 02/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import UIKit

protocol MapsRoutable {
    
    func openGasStationInfo(in view: UIViewController)
}

class MapsRouter: MapsRoutable {
    
    private let wireframe: Wireframe
    
    
    init(wireframe: Wireframe) {
        
        self.wireframe = wireframe
    }
    
    func openGasStationInfo(in view: UIViewController) {
        
    }
}
