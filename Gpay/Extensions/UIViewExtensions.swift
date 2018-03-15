//
//  UIViewExtensions.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 14/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import UIKit

extension UIView {
    
    class func loadFromNib<T: UIView>(view: T.Type) -> T? {
        
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: self, options: nil)?.first as? T
    }
}
