//
//  SVFadeSegue.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/21/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import UIKit

/// Custom fade animation for the SVBaseViewController.
/// It will fade the source's contentView, then apply the destination's view and fade in the destination view controller's
/// contentView.
class SVFadeAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    /// Whether the animator is presenting a view controller or dismissing one.
    var presenting = false
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5 // transition for half a second
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // get the source and destination view controllers
        guard let source = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? SVBaseViewController else {
            return
        }
        guard let dest = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? SVBaseViewController else {
            return
        }
        
        if presenting {
            transitionContext.containerView()?.addSubview(source.view)
            transitionContext.containerView()?.addSubview(dest.view)
            
            // set the destination views to 0
            dest.view.alpha = 0
            dest.contentView.alpha = 0
            
            // hide source contentView, then present dest view & contentView
            UIView.animateWithDuration(transitionDuration(transitionContext)/2.0, animations: {
                source.contentView.alpha = 0
            }, completion: { finished in
                dest.view.alpha = 1
                UIView.animateWithDuration(self.transitionDuration(transitionContext)/2.0, animations: {
                    dest.contentView.alpha = 1
                }, completion: { finished in
                    transitionContext.completeTransition(true) // call completion
                })
            })
        } else {
            transitionContext.containerView()?.addSubview(dest.view)
            transitionContext.containerView()?.addSubview(source.view)
            
            // show background view, but hide contentView of background vc
            dest.view.alpha = 1
            dest.contentView.alpha = 0
            
            // hide the source contentView, then the whole source, then show dest contentView
            UIView.animateWithDuration(transitionDuration(transitionContext)/2.0, animations: {
                source.contentView.alpha = 0
            }, completion: { finished in
                source.view.alpha = 0
                UIView.animateWithDuration(self.transitionDuration(transitionContext)/2.0, animations: {
                    dest.contentView.alpha = 1
                }, completion: { finished in
                    transitionContext.completeTransition(true) // call completion
                })
            })
        }
    }
}