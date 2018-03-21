//
//  OrderDetailsController.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 15/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import UIKit
import RxSwift

class OrderDetailsController: UIViewController {

    private let bag = DisposeBag()
    
    @IBOutlet weak var close: UIButton!
    
    @IBOutlet weak var stationTitle: UILabel!
    
    @IBOutlet weak var stationAddress: UILabel!
    
    @IBOutlet weak var dispenserNumber: UILabel!
    
    @IBOutlet weak var fuel: UILabel!
    
    @IBOutlet weak var liters: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var payment: RoundedButton!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var viewModel: OrderDetailsViewModel!
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupView()
        setupViewModel()
    }
    
    private func setupView() {
        
        payment.setButtonColor(.mainBlue)
        payment.enableShadow(color: .mainBlue)
        
        self.stationTitle.text = self.viewModel.station.name
        self.stationAddress.text = self.viewModel.station.address
        self.dispenserNumber.text = "\(self.viewModel.order.dispenserIndex)"
        self.fuel.text = self.viewModel.order.nozzle.fuel.name
        self.liters.text = String(format: "%.2f", self.viewModel.order.liters) + " Л"
        self.price.text = String(format: "%.2f", self.viewModel.order.liters * self.viewModel.order.nozzle.fuel.price) + " \u{20BD}"
        
        close.rx.tap
            .subscribe(onNext: { [unowned self] in self.dismiss(animated: true, completion: nil) })
            .disposed(by: bag)
    }
    
    private func setupViewModel() {
        
        viewModel.activity
            .subscribe(onNext: { [unowned self] isActive in
                
                if isActive {
                    
                    self.activity.startAnimating()
                }
                else {
                    
                    self.activity.stopAnimating()
                }
            })
            .disposed(by: bag)
        
        viewModel.dismiss
            .subscribe(onNext: { [unowned self] in self.dismiss(animated: true, completion: nil) })
            .disposed(by: bag)
        
        viewModel.makePayment = self.payment.rx.tap.asObservable()
    }
}

extension OrderDetailsController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        return OrderDetailsPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return presented == self ? OrderDetailsAnimationController(.present) : nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return dismissed == self ? OrderDetailsAnimationController(.dismiss) : nil
    }
}
