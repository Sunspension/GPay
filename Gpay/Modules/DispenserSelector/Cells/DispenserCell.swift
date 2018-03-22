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
    
    var isLocked: Bool = false {
        
        willSet {
            
            if newValue {
                
                index.setTitle(nil, for: .normal)
                index.setImage(R.image.locked())
                self.isUserInteractionEnabled = false
            }
            else {
                
                index.setImage(nil)
                self.isUserInteractionEnabled = true
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
        
        index.setTitle(nil, for: .normal)
        index.setButtonColor(.babyBlue)
        isActive = false
    }
    
    override func prepareForReuse() {
        
        index.setTitle(nil, for: .normal)
        isActive = true
        isSelected = false
        isLocked = false
    }
    
    func configure(_ item: (index: Int, dispenser: Dispenser?)) {
        
        if let dispenser = item.dispenser {
            
            isActive = true
            
            if dispenser.isLocked {
                
                isLocked = true
            }
            else {
                
                isLocked = false
                index.setTitle("\(item.index + 1)", for: .normal)
            }
        }
        else {
            
            index.setTitle("\(item.index + 1)", for: .normal)
            isActive = false
        }
    }
}
