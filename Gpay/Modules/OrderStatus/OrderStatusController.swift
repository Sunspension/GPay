//
//  OrderStatusController.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 16/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import UIKit
import RxSwift

class OrderStatusController: UIViewController {

    private let bag = DisposeBag()
    
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var action: RoundedButton!
    
    @IBOutlet weak var actionBottomSpace: NSLayoutConstraint!

    var viewModel: OrderStatusViewModel! {
        
        willSet {
            
            self.rx.viewDidLoad
                .bind(to: newValue.viewDidLoad)
                .disposed(by: bag)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        action.setButtonColor(.mainBlue)
        action.enableShadow(color: .mainBlue)
        
        container.layer.cornerRadius = 20
        container.clipsToBounds = true
        self.navigationItem.hidesBackButton = true
        
        action.rx.tap
            .bind(onNext: { [unowned self] in self.dismiss(animated: true, completion: nil) })
            .disposed(by: bag)
    }
    
    @available(iOS 11.0, *)
    override func viewLayoutMarginsDidChange() {
        
        super.viewLayoutMarginsDidChange()
        
        if self.view.directionalLayoutMargins.bottom == 0 {
            
            self.actionBottomSpace.constant = 20
        }
    }
    
    private func requestOrderStatus() {
        
//        API.orderStatus(orderId: <#T##String#>)
    }
}
