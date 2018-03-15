//
//  TableFooterView.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 14/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import UIKit

class TableFooterView: UIView {

    @IBOutlet weak var totalPrice: UITextField!
    
    @IBOutlet weak var totalLiters: UITextField!
    
    @IBOutlet weak var currency: UILabel!
    
    @IBOutlet weak var liters: UILabel!
    
    @IBOutlet weak var separator: UIView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        currency.text = "\u{20BD}"
        separator.backgroundColor = .separatorGray
    }
}
