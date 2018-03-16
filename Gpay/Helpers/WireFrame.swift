//
//  WireFrame.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 02/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import UIKit
import RxSwift
import Swinject
import Rswift
import GoogleMaps

protocol Wireframe {
    
    var container: Container { get }
    
    func showSingup()
    
    func initialViewController() -> UIViewController
    
    func changeRootViewController(to viewController: UIViewController)
}

final class MainWireframe: Wireframe {
    
    var container = Container()
    
    static let shared = MainWireframe()
    
    private let bag = DisposeBag()
    
    var applicationWindow: UIWindow {
        
        return UIApplication.shared.keyWindow!
    }
    
    init() {
        
        NotificationCenter.default.rx
            .notification(Notification.Name(Constants.Notification.showSingup))
            .asObservable()
            .subscribe(onNext: { [unowned self] _ in self.showSingup() })
            .disposed(by: bag)
        
        self.registerServices()
        GMSServices.provideAPIKey("AIzaSyCZWPUk4qt5RD4k2sR__ehtoBJufy5FaI0")
    }
    
    func showSingup() {
        
        self.changeRootViewController(to: container.resolve(SingUpController.self)!)
    }
    
    func initialViewController() -> UIViewController {
        
        guard
            let auth = StorageManager.auth,
            Date(timeIntervalSince1970: auth.tokenExpirationAt / 1000) > Date()
            else { return container.resolve(SingUpController.self)! }
        
        let controller = container.resolve(MapsController.self)!
        return UINavigationController(rootViewController: controller)
    }
    
    func changeRootViewController(to viewController: UIViewController) {
        
        UIView.transition(with: self.applicationWindow,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
                            
                            UIView.performWithoutAnimation {
                                
                                self.applicationWindow.rootViewController = viewController
                            }
                            
        }, completion: nil)
    }
    
    private func registerServices() {
        
        container.register(SingUpController.self) { _ in
            
            let controller = SingUpController()
            controller.viewModel = SignUpViewModel()
            controller.router = SingUpRouter(wireframe: self)
            return controller
        }
        
        container.register(MapsController.self) { _ in
            
            let controller = R.storyboard.main()
                .instantiateViewController(withIdentifier: "Maps") as! MapsController
            controller.viewModel = MapsViewModel()
            controller.router = MapsRouter(wireframe: self)
            
            return controller
        }
        
        container.register(StationInfoController.self) { (resolver, station: GasStation) in
            
            let controller = R.storyboard.main()
                .instantiateViewController(withIdentifier: "StationInfo") as! StationInfoController
            controller.viewModel = StationInfoViewModel(station)
            controller.router = StationInfoRouter(wireframe: self)
            
            return controller
        }
        
        container.register(DispenserSelectorController.self) { (resolver, station: GasStation) in
            
            let controller = R.storyboard.main().instantiateViewController(withIdentifier: "DispenserSelector") as! DispenserSelectorController
            controller.title = station.name
            controller.viewModel = DispenserSelectorViewModel(station)
            controller.router = DispenserSelectorRouter(wireframe: self)
            
            return controller
        }
        
        container.register(OrderDetailsController.self) { (resolver, order: Order, station: GasStation) in
            
            let controller = R.storyboard.main().instantiateViewController(withIdentifier: "OrderDetails") as! OrderDetailsController
            controller.viewModel = OrderDetailsViewModel(order: order, station: station)
            
            return controller
        }
    }
}
