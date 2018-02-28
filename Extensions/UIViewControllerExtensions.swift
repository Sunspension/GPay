//
//  UIViewControllerExtensions.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 26/02/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import UIKit
import RxSwift

extension UIViewController {
    
    func showOkAlert(title: String?, message: String?, okAction: ((UIAlertAction) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okTitle = "Ok"
        let action = UIAlertAction.cancelAction(title: okTitle)
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
}
