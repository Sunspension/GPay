//
//  SHSPhoneComponentExtension.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 01/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import SHSPhoneComponent
import RxSwift
import RxCocoa

extension Reactive where Base: SHSPhoneTextField {
    
    var phoneNumber: ControlProperty<String?> {
        
        return value
    }
    
    var value: ControlProperty<String?> {
        
        return base.rx.controlProperty(
            
            editingEvents: [.allEditingEvents, .valueChanged],
            getter: { textField in textField.phoneNumber() },
            setter: { textField, value in }
        )
    }
}
