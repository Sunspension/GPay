//
//  StationInfoRouter.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 07/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import UIKit

protocol StationInfoRoutable {
    
    func openDispenserSelector(station: GasStation, in view: UIViewController)
}

class StationInfoRouter: RouterBase, StationInfoRoutable {
    
    func openDispenserSelector(station: GasStation, in view: UIViewController) {
        
        let controller = self.wireframe.container.resolve(DispenserSelectorController.self, argument: station)!
        let navi = UINavigationController(rootViewController: controller)
        
        view.present(navi, animated: true, completion: nil)
    }
}
