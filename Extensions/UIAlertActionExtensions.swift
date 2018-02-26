//
//  UIAlertActionExtensions.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 26/02/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import UIKit

extension UIAlertAction {
    
    @objc class var cancel: UIAlertAction {
        
        return UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
    }
    
    @objc class func cancelAction(title: String, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        
        return UIAlertAction(title: title, style: .cancel, handler: handler)
    }
    
    @objc class func defaultAction(title: String, handler: @escaping (UIAlertAction) -> Void) -> UIAlertAction {
        
        return UIAlertAction(title: title, style: .default, handler: handler)
    }
    
    @objc class func destructiveAction(title: String, handler: @escaping (UIAlertAction) -> Void) -> UIAlertAction {
        
        return UIAlertAction(title: title, style: .destructive, handler: handler)
    }
}
