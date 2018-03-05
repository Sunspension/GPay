//
//  StationInfoController.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 05/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import UIKit
import RxSwift

class StationInfoController: UIViewController {
    
    private var bag = DisposeBag()
    
    @IBOutlet weak var stationTitle: UILabel!
    
    @IBOutlet weak var stationAddress: UILabel!
    
    @IBOutlet weak var stationFuelList: UILabel!
    
    @IBOutlet weak var action: RoundedButton!
    
    var viewModel: StationInfoViewModel! {
        
        willSet {
            
            self.rx.viewDidLoad
                .bind(to: newValue.viewDidLoad)
                .disposed(by: bag)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        action.setButtonColor(UIColor.mainBlue)
        action.enableShadow(color: UIColor.mainBlue)
        
        self.viewModel.onStation
            .bind(onNext: { [unowned self] in self.onStation($0) })
            .disposed(by: bag)
    }
    
    func onStation(_ station: GasStation) {
        
        stationTitle.text = station.name
        stationAddress.text = station.address
    }
}

extension StationInfoController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        return StationInfoPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return presented == self ? StationInfoAnimationController(.present) : nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return dismissed == self ? StationInfoAnimationController(.dismiss) : nil
    }
}
