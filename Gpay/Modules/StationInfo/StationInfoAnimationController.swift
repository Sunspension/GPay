//
//  StationInfoAnimationController.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 05/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import UIKit
import RxSwift

enum StationInfoAnimationDirection {
    
    case present, dismiss
}

class StationInfoAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var direction: StationInfoAnimationDirection
    
    private var bag = DisposeBag()
    
    init(_ direction: StationInfoAnimationDirection) {
        
        self.direction = direction
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        switch direction {
            
        case .present:
            
            self.animatePresenation(with: transitionContext)
            
        case .dismiss:
            
            self.animateDismissal(with: transitionContext)
        }
    }
    
    private func animatePresenation(with transitionContext: UIViewControllerContextTransitioning) {
        
        guard
            let controller = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let view = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        
        let container = transitionContext.containerView
        
        let frame = transitionContext.finalFrame(for: controller)
        container.frame = frame
        
        let visual = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visual.contentView.addSubview(view)
        
        container.addSubview(visual)
        
        visual.frame = container.bounds
        view.frame = container.bounds
        
        let height = frame.height
        container.center.y += height
        
        container.layer.cornerRadius = 20
        container.clipsToBounds = true
        
        // Animate the presented view to it final position
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 5,
                       initialSpringVelocity: 30,
                       options: .allowUserInteraction,
                       animations: { container.center.y -= height + 22 },
                       completion: { transitionContext.completeTransition($0) })
    }
    
    private func animateDismissal(with transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView
        let height = container.bounds.height + 22
        
        // Animate the presented view off the bottom of the view
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: .allowUserInteraction,
                       animations: { container.center.y += height },
                       completion: { transitionContext.completeTransition($0) })
    }
}
