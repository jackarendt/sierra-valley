//
//  SVBlinkAnimation.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/22/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import UIKit

/// SVBlinkAnimation blinks a given view over a set duration
class SVBlinkAnimation {
    /// The view that will blink
    weak var blinkView : UIView?
    
    /// The duration of a full blink (visible -> invisible -> visible)
    var blinkDuration : NSTimeInterval = 0.0
    
    /// Initializes a blink animation with a view to animate and a time interval
    /// - Parameter view: The view to blink
    /// - Parameter duration: The period of a blink
    init(view: UIView, duration : NSTimeInterval) {
        blinkView = view
        blinkDuration = duration
    }
    
    init() {
        
    }
    
    /// Blinks the view over a given duration
    func blink() {
        guard let _blinkView = blinkView else {
            print("ERROR: Cannot blink. No View")
            return
        }
        UIView.animateKeyframesWithDuration(blinkDuration, delay: 0, options: .Repeat, animations: {
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.25, animations: {
                _blinkView.alpha = 1
            })
            UIView.addKeyframeWithRelativeStartTime(0.75, relativeDuration: 0.25, animations: {
                _blinkView.alpha = 0
            })
        }, completion: nil)
    }
    
    /// Removes the blink animation and returns the desired state of visible or invisible
    /// - Parameter visible: Boolean denoting whether the view should be visible or invisible when the blink is finished
    func stopBlink(visible : Bool) {
        if let _blinkView = blinkView {
            _blinkView.layer.removeAllAnimations() // remove animation
            UIView.animateWithDuration(blinkDuration/2, animations: {
                _blinkView.alpha = visible ? 1 : 0 // set the correct alpha value
            })
        }
    }
}
