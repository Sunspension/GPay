//
//  DispenserSelectorRouter.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 15/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import UIKit

protocol DispenserSelectorRoutable {
    
    func openOrderDetails(order: Order, station: GasStation, in view: UIViewController)
    
    func openPaymentController(order: Order, orderId: String, in view: UIViewController)
    
    func openOrderStatusController(orderId: String, orderNumber: String, in view: UIViewController)
}

class DispenserSelectorRouter: RouterBase, DispenserSelectorRoutable {
    
    let payment = PaymentController()
    
    func openOrderDetails(order: Order, station: GasStation, in view: UIViewController) {
        
        let controller = wireframe.container.resolve(OrderDetailsController.self, arguments: order, station)!
        view.present(controller, animated: true, completion: nil)
    }
    
    func openPaymentController(order: Order, orderId: String, in view: UIViewController) {
        
        payment.startPayment(with: order, orderId: orderId)
    }
    
    func openOrderStatusController(orderId: String, orderNumber: String, in view: UIViewController) {
        
        let controller = wireframe.container.resolve(OrderStatusController.self, arguments: orderId, orderNumber)!
        view.navigationController?.pushViewController(controller, animated: true)
    }
}
