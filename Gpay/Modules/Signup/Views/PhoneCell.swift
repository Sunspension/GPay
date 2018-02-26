//
//  PhoneCell.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 21/02/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import UIKit
import SHSPhoneComponent
import RxSwift

class PhoneCell: UITableViewCell {

    private var disposeBag = DisposeBag()
    
    @IBOutlet weak var phoneField: SHSPhoneTextField!
    
    
    override func prepareForReuse() {
        
        disposeBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    func enablePrefix() {
        
        let prefix = "+7"
        let formatter = self.phoneField.formatter
        
        self.phoneField.rx
            .controlEvent([.editingDidBegin])
            .asObservable()
            .subscribe(onNext: { formatter?.prefix = prefix })
            .disposed(by: disposeBag)
        
        self.phoneField.rx
            .controlEvent([.editingDidEnd])
            .asObservable()
            .subscribe(onNext: { [unowned self] in
                
                if self.phoneField.text != prefix { return }
                formatter?.prefix = ""
            })
            .disposed(by: disposeBag)
    }
}
