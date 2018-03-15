//
//  SingUpRouter.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 02/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import Foundation

protocol SingUpRoutable {
    
    func openRootController()
}

class SingUpRouter: RouterBase, SingUpRoutable{
    
    func openRootController() {
        
        let controller = wireframe.initialViewController()
        wireframe.changeRootViewController(to: controller)
    }
}
