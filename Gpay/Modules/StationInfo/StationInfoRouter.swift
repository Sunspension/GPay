//
//  StationInfoRouter.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 07/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import UIKit

protocol StationInfoRoutable {
    
    func openRefuelerSelector(stationId: String, stationName: String, in view: UIViewController)
}

class StationInfoRouter: StationInfoRoutable {
    
    private let wireframe: Wireframe
    
    
    init(wireframe: Wireframe) {
        
        self.wireframe = wireframe
    }
    
    func openRefuelerSelector(stationId: String, stationName: String, in view: UIViewController) {
        
        let controller = self.wireframe.container.resolve(RefuelerSelectorController.self, arguments: stationId, stationName)!
        view.present(controller, animated: true, completion: nil)
    }
}
