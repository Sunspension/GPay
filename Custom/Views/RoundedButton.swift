//
//  RoundedButton.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 21/02/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    private lazy var shadowLayer: CAShapeLayer = {
        
        let layer = CAShapeLayer()
        layer.shadowColor = R.color.mainBlue()?.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 8
        
        return layer
    }()
    
    private var isShadowEnabled: Bool = false
    
    override var isEnabled: Bool {
        
        willSet {
            
            self.alpha = newValue ? 1 : 0.5
        }
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if self.shadowLayer.superlayer == nil {
            
            layer.insertSublayer(self.shadowLayer, at: 0)
        }
        
        let radius = min(self.bounds.width, self.bounds.height) / 2
        layer.cornerRadius = radius
        
        if isShadowEnabled {
            
            let path = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
            shadowLayer.path = path
            shadowLayer.shadowPath = path
        }
    }
    
    func setButtonColor(_ color: UIColor) {
        
        self.shadowLayer.fillColor = color.cgColor
    }
    
    func enableShadow(color: UIColor, radius: CGFloat = 7, offset: CGSize = CGSize(width: 0, height: 7)) {
        
        self.isShadowEnabled = true
        
        shadowLayer.shadowColor = color.cgColor
        shadowLayer.shadowOffset = offset
        shadowLayer.shadowOpacity = 0.4
        shadowLayer.shadowRadius = radius
    }
}
