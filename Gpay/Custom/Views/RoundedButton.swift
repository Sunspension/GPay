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
        self.layer.insertSublayer(layer, at: 0)
        return layer
    }()
    
    override var isEnabled: Bool {
        
        willSet {
            
            self.alpha = newValue ? 1 : 0.5
        }
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let radius = min(self.bounds.width, self.bounds.height) / 2
        layer.cornerRadius = radius
        
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        shadowLayer.path = path
        shadowLayer.shadowPath = path
    }
    
    func setButtonColor(_ color: UIColor) {
        
        self.shadowLayer.fillColor = color.cgColor
    }
    
    func enableShadow(color: UIColor, radius: CGFloat = 7, offset: CGSize = CGSize(width: 0, height: 7), opacity: Float = 0.4) {
        
        shadowLayer.shadowColor = color.cgColor
        shadowLayer.shadowOffset = offset
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = radius
    }
    
    func disableShadow() {
        
        shadowLayer.shadowColor = UIColor.white.cgColor
        shadowLayer.shadowOffset = CGSize.zero
        shadowLayer.shadowOpacity = 1
        shadowLayer.shadowRadius = 0
    }
}
