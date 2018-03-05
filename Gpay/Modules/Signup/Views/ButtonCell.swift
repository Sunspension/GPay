//
//  ButtonCell.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 21/02/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import UIKit
import RxSwift

class ButtonCell: UITableViewCell {
    
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var button: RoundedButton!
    
    
    override func prepareForReuse() {
        
        disposeBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        button.setButtonColor(UIColor.mainBlue)
        button.enableShadow(color: UIColor.mainBlue)
    }
}
