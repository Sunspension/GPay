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
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var router: StationInfoRoutable!
    
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
        
        self.viewModel.onDispensers
            .bind(onNext: { [unowned self] in self.onRefuelers($0) })
            .disposed(by: bag)
        
        self.action.rx.tap.subscribe(onNext: { [unowned self] in
            
            self.router.openDispenserSelector(station: self.viewModel.station, in: self)
            
        }).disposed(by: bag)
    }
    
    func onStation(_ station: GasStation) {
        
        stationTitle.text = station.name
        stationAddress.text = station.address
    }
    
    func onRefuelers(_ refuelers: [Dispenser]) {
        
        let fuelSet = Set(refuelers.flatMap ({ $0.nozzles.map({ $0.fuel }) }))
        
        let prices = NSMutableAttributedString(string: "")
        
        for fuel in fuelSet {
            
            let string = self.combineAttributedText(name: fuel.name,
                                                    price: String(format: "%.2f", fuel.price),
                                                    iconColor: UIColor.red)
            prices.append(string)
            
            let space = NSAttributedString(string:"  ", attributes: [ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16)])
            prices.append(space)
        }
        
        self.stationFuelList.attributedText = prices
        self.activity.stopAnimating()
    }
    
    private func combineAttributedText(name: String, price: String, iconColor: UIColor) -> NSAttributedString {
        
        let name = NSAttributedString(string: name + " ", attributes: [ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16)])
        
        let attachment = NSTextAttachment()
        attachment.image = R.image.fuelSmall()?.withRenderingMode(.alwaysTemplate)
        
        attachment.bounds = CGRect(x: 0, y: -1, width: attachment.image!.size.width, height: attachment.image!.size.height)
        
        let icon = NSAttributedString(attachment: attachment)
        let iconRange = NSMakeRange(name.length - 1, icon.length)
        
        let price = NSAttributedString(string: " " + price, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor : UIColor.mainBlue])
        
        let finalString = NSMutableAttributedString(attributedString: name)
        finalString.append(icon)
        finalString.addAttributes([NSAttributedStringKey.foregroundColor : iconColor], range: iconRange)
        finalString.append(price)
        
        return finalString
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
