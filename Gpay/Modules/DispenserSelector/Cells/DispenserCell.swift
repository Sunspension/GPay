//
//  RefuelerCell.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 06/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import UIKit

class DispenserCell: UICollectionViewCell {
    
    @IBOutlet weak var index: RoundedButton!
    
    @IBOutlet weak var busyIcon: UIImageView!
    
    var isActive: Bool = false {
        
        willSet {
            
            if newValue {
                
                self.isUserInteractionEnabled = true
                self.index.isEnabled = true
            }
            else {
                
                self.isUserInteractionEnabled = false
                self.index.isEnabled = false
            }
        }
    }
    
    override var isSelected: Bool {
        
        willSet {
            
            if newValue {
                
                index.enableShadow(color: .mainBlue, radius: 8, offset: CGSize(width: 0, height: 8))
                index.setButtonColor(.mainBlue)
                index.titleLabel?.textColor = .white
            }
            else {
                
                index.disableShadow()
                index.setButtonColor(.babyBlue)
                index.titleLabel?.textColor = .black
            }
        }
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        index.setButtonColor(.babyBlue)
        isActive = false
    }
}
