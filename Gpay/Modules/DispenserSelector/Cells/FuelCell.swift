//
//  FuelCellTableViewCell.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 14/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import UIKit

class FuelCell: UITableViewCell {

    private var fuel: Fuel?
    
    @IBOutlet weak var check: UIButton!
    
    @IBOutlet weak var fuelTitle: UILabel!
    
    @IBOutlet weak var fuelPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }
    
    override func prepareForReuse() {
        
        fuel = nil
        fuelPrice.attributedText = nil
        fuelTitle.attributedText = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if backgroundView == nil {
            
            backgroundView = UIView()
        }
        
        if selected {
            
            self.check.isSelected = true
            backgroundView?.backgroundColor = .mainBlue
            fuelTitle.attributedText = attributedFuelName(name: fuel!.name, nameColor: .white)
            fuelPrice.attributedText = attributedPrice(price: fuel!.price, priceColor: .white)
        }
        else {
            
            self.check.isSelected = false
            backgroundView?.backgroundColor = .white
            fuelTitle.attributedText = attributedFuelName(name: fuel!.name, nameColor: .black)
            fuelPrice.attributedText = attributedPrice(price: fuel!.price, priceColor: .black)
        }
    }
    
    func configure(_ fuel: Fuel) {
        
        self.fuel = fuel
        fuelTitle.attributedText = attributedFuelName(name: fuel.name, nameColor: .black)
        fuelPrice.attributedText = attributedPrice(price: fuel.price, priceColor: .black)
    }
    
    private func attributedPrice(price: Double, priceColor: UIColor) -> NSAttributedString {
        
        let attributes = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor : priceColor]
        return NSAttributedString(string: "\(price)" + " " + "\u{20BD}", attributes: attributes)
    }
    
    private func attributedFuelName(name: String, nameColor: UIColor) -> NSAttributedString {
        
        let nameAttributes = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor : nameColor]
        let name = NSAttributedString(string: name + " ", attributes: nameAttributes)
        
        let attachment = NSTextAttachment()
        attachment.image = R.image.fuelBig()?.withRenderingMode(.alwaysTemplate)
        
        attachment.bounds = CGRect(x: 0, y: -1, width: attachment.image!.size.width, height: attachment.image!.size.height)
        
        let icon = NSAttributedString(attachment: attachment)
        let iconRange = NSMakeRange(name.length - 1, icon.length)
        
        let finalString = NSMutableAttributedString(attributedString: name)
        finalString.append(icon)
        finalString.addAttributes([NSAttributedStringKey.foregroundColor : UIColor.red], range: iconRange)
        
        return finalString
    }
}
