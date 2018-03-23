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

    private let _bag = DisposeBag()
    
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var action: RoundedButton!
    
    @IBOutlet weak var actionBottomSpace: NSLayoutConstraint!

    @IBOutlet weak var orderStatusTitle: UILabel!
    
    @IBOutlet weak var orderStatusImage: UIImageView!
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var mainTitle: UILabel!
    
    var viewModel: OrderStatusViewModel! {
        
        willSet {
            
            self.rx.viewDidLoad
                .bind(to: newValue.viewDidLoad)
                .disposed(by: _bag)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        hideViews()
        action.setButtonColor(.mainBlue)
        action.enableShadow(color: .mainBlue)
        
        container.layer.cornerRadius = 20
        container.clipsToBounds = true
        self.navigationItem.hidesBackButton = true
        
        action.rx.tap
            .bind(onNext: { [unowned self] in self.dismiss(animated: true, completion: nil) })
            .disposed(by: _bag)
        
        viewModel.orderStatus
            .bind(onNext: { [unowned self] in self.onOrderStatus($0) })
            .disposed(by: _bag)
        
        viewModel.loadingActivity
            .subscribe(onNext: { [unowned self] isActive in
                
                if isActive {
                    
                    self.showBusy()
                }
                else {
                    
                    self.showViews()
                    self.hideBusy()
                }
                
            }).disposed(by: _bag)
    }
    
    @available(iOS 11.0, *)
    override func viewLayoutMarginsDidChange() {
        
        super.viewLayoutMarginsDidChange()
        
        if self.view.directionalLayoutMargins.bottom == 0 {
            
            self.actionBottomSpace.constant = 20
        }
    }
    
    private func hideViews() {
        
        self.image.isHidden = true
        self.mainTitle.isHidden = true
        self.container.isHidden = true
    }
    
    private func showViews() {
        
        self.container.isHidden = false
    }
    
    private func onOrderStatus(_ status: OrderStatus) {
        
        switch status.state {
            
        case .pendingPayment:
            
            self.orderStatusImage.image = R.image.timer()
            self.container.backgroundColor = .lightYellow
            self.orderStatusTitle.text = "Ожидание оплаты"
            break
            
        case .canceled:
            
            self.container.backgroundColor = .lightRed
            self.orderStatusTitle.text = "Ваш заказ отменен"
            self.orderStatusImage.image = R.image.canceled()
            break
            
        case .completed:
            
            self.container.isHidden = true
            self.image.image = R.image.completed()
            self.mainTitle.text = "Заправка завершена"
            break
            
        case .waitingRefueling:
            
            self.orderStatusImage.image = R.image.success()
            self.container.backgroundColor = .lightGreen
            self.orderStatusTitle.text = "Ваш заказ оплачен"
            self.image.isHidden = false
            self.mainTitle.isHidden = false
            
        default:
            break
        }
    }
}
