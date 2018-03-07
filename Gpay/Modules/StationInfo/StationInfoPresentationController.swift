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
        let y: CGFloat = frame.height - height - 22
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
}
