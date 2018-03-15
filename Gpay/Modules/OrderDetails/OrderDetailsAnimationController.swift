//
//  OrderDetailsAnimationController.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 15/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import UIKit

enum OrderDetailsAnimationDirection {
    
    case present, dismiss
}

class OrderDetailsAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var direction: OrderDetailsAnimationDirection
    
    init(_ direction: OrderDetailsAnimationDirection) {
        
        self.direction = direction
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 0.5
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
        container.backgroundColor = UIColor(white: 0, alpha: 0.5)
        container.addSubview(view)
        
        view.frame = transitionContext.finalFrame(for: controller)
        view.center.y -= container.bounds.height
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        
        // Animate the presented view to it final position
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 10,
                       initialSpringVelocity: 20,
                       options: .allowUserInteraction,
                       animations: { view.center.y = container.bounds.height / 2 },
                       completion: { transitionContext.completeTransition($0) })
    }
    
    private func animateDismissal(with transitionContext: UIViewControllerContextTransitioning) {
        
        guard let view = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
        
        let container = transitionContext.containerView
        let height = container.bounds.height
        
        // Animate the presented view off the bottom of the view
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: .allowUserInteraction,
                       animations: { view.center.y += height },
                       completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            
            transitionContext.completeTransition(true)
        }
    }
}
