//
//  StationInfoPresentationController.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 05/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import UIKit

class StationInfoPresentationController: UIPresentationController {
    
    override var frameOfPresentedViewInContainerView: CGRect {
        
        guard let container = containerView else { return CGRect.zero }
        
        let frame = container.bounds
        
        let width: CGFloat = frame.size.width - 44
        let height: CGFloat = 224
        let x: CGFloat = 22
        let y: CGFloat = frame.height - height
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
//    override func presentationTransitionWillBegin() {
//        
//        guard let container = containerView, let view = presentedView else { return }
//        
//        view.layer.cornerRadius = 20
//        view.clipsToBounds = true
//        
//        container.addSubview(view)
//    }
}
