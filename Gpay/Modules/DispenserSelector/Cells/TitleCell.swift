//
//  TitleCell.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 19/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import UIKit
import RxSwift

class TitleCell: UITableViewCell {

    var bag = DisposeBag()
    
    @IBOutlet weak var mainTitle: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        
        bag = DisposeBag()
    }
}
