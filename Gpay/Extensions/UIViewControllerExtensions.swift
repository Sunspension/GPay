//
//  UIViewControllerExtensions.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 26/02/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UIViewController {
    
    func showOkAlert(title: String?, message: String?, okAction: ((UIAlertAction) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okTitle = "Ok"
        let action = UIAlertAction.cancelAction(title: okTitle)
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showError(error: Swift.Error) {
        
        showOkAlert(title: "Ошибка", message: error.localizedDescription)
    }
    
    func showBusy() {
        
        guard self.view.subviews.first(where: { $0 is UIActivityIndicatorView }) == nil else {
            
            return
        }
        
        let busy = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        busy.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        busy.hidesWhenStopped = true
        busy.startAnimating()
        
        let container = UIView(frame: self.view.bounds)
        container.backgroundColor = UIColor.clear
        container.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        container.tag = container.hash ^ 99
        container.isUserInteractionEnabled = false
        
        container.addSubview(busy)
        
        busy.translatesAutoresizingMaskIntoConstraints = false
        busy.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        busy.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        
        self.view.addSubview(container)
    }
    
    func hideBusy() {
        
        self.view.subviews.forEach { view in
            
            if view.tag == view.hash ^ 99 {
                
                view.removeFromSuperview()
            }
        }
    }
}

public extension Reactive where Base: UIViewController {
    
    public var viewDidLoad: ControlEvent<Void> {
        
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }
    
    public var viewWillAppear: ControlEvent<Bool> {
        
        let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    public var viewDidAppear: ControlEvent<Bool> {
        
        let source = self.methodInvoked(#selector(Base.viewDidAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    public var viewWillDisappear: ControlEvent<Bool> {
        
        let source = self.methodInvoked(#selector(Base.viewWillDisappear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    public var viewDidDisappear: ControlEvent<Bool> {
        
        let source = self.methodInvoked(#selector(Base.viewDidDisappear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    public var viewWillLayoutSubviews: ControlEvent<Void> {
        
        let source = self.methodInvoked(#selector(Base.viewWillLayoutSubviews)).map { _ in }
        return ControlEvent(events: source)
    }
    
    public var viewDidLayoutSubviews: ControlEvent<Void> {
        
        let source = self.methodInvoked(#selector(Base.viewDidLayoutSubviews)).map { _ in }
        return ControlEvent(events: source)
    }
    
    public var willMoveToParentViewController: ControlEvent<UIViewController?> {
        
        let source = self.methodInvoked(#selector(Base.willMove)).map { $0.first as? UIViewController }
        return ControlEvent(events: source)
    }
    
    public var didMoveToParentViewController: ControlEvent<UIViewController?> {
        
        let source = self.methodInvoked(#selector(Base.didMove)).map { $0.first as? UIViewController }
        return ControlEvent(events: source)
    }
    
    public var didReceiveMemoryWarning: ControlEvent<Void> {
        
        let source = self.methodInvoked(#selector(Base.didReceiveMemoryWarning)).map { _ in }
        return ControlEvent(events: source)
    }
    
    /// Rx observable, triggered when the ViewController appearance state changes (true if the View is being displayed, false otherwise)
    public var isVisible: Observable<Bool> {
        
        let viewDidAppearObservable = self.base.rx.viewDidAppear.map { _ in true }
        let viewWillDisappearObservable = self.base.rx.viewWillDisappear.map { _ in false }
        return Observable<Bool>.merge(viewDidAppearObservable, viewWillDisappearObservable)
    }
    
    /// Rx observable, triggered when the ViewController is being dismissed
    public var isDismissing: ControlEvent<Bool> {
        
        let source = self.sentMessage(#selector(Base.dismiss)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    public var keyboardHeight: Observable<CGFloat> {
        
        let willShow = NotificationCenter.default.rx
            .notification(Notification.Name.UIKeyboardWillShow)
            .map({ ($0.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0 })
        
        let willHide = NotificationCenter.default.rx
            .notification(Notification.Name.UIKeyboardWillHide)
            .map({ _ in CGFloat(0) })
        
        return Observable.from([willShow, willHide]).merge()
    }
}
