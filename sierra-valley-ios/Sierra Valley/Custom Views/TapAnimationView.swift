//
//  TapAnimationView.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/22/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import UIKit

/// UIView subclass that illustrates to a user to tap the screen
class TapAnimationView: UIView {
    
    /// The tint color of the tap view
    var fillColor = SVColor.lightColor() {
        didSet {
            outerCircle.strokeColor = fillColor.CGColor
            innerCircle.fillColor = fillColor.CGColor
        }
    }
    
    private let outerCircle = CAShapeLayer()
    private let innerCircle = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let outerCirclePath = UIBezierPath(ovalInRect: bounds)
        outerCircle.path = outerCirclePath.CGPath
        outerCircle.fillColor = UIColor.clearColor().CGColor
        outerCircle.strokeColor = fillColor.CGColor
        outerCircle.lineWidth = 2.0
        layer.addSublayer(outerCircle)
        
        let innerCirclePath = UIBezierPath(ovalInRect: CGRect(x: 3*bounds.width/10, y: 3*bounds.height/10, width: 2*bounds.width/5, height: 2*bounds.height/5))
        innerCircle.path = innerCirclePath.CGPath
        innerCircle.fillColor = SVColor.lightColor().CGColor
        innerCircle.fillMode = kCAFillModeForwards
        layer.addSublayer(innerCircle)
    }
    
    /// Animates the tap animation by growing and shrinking the the inner circle
    /// - Note: Does not work yet, reason unknown
    func animate() {
        let smallPath = UIBezierPath(ovalInRect: CGRect(x: 2*bounds.width/5, y: 2*bounds.height/5, width: 1*bounds.width/5, height: 1*bounds.height/5))
        let normalPath = UIBezierPath(ovalInRect: CGRect(x: 3*bounds.width/10, y: 3*bounds.height/10, width: 2*bounds.width/5, height: 2*bounds.height/5))
        
        let initial = createAnimation(toPath: smallPath, fromPath: normalPath, alpha: 1, beginTime: 0, duration: 0.5)
        layer.addAnimation(initial, forKey: "initial")
        
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(TapAnimationView.infiniteAnimation), userInfo: nil, repeats: false)
    }
    
    /// Stops the tap animation and returns the inner circle to the original value
    func stopAnimation() {
        
    }
    
    func infiniteAnimation() {
        let smallPath = UIBezierPath(ovalInRect: CGRect(x: 2*bounds.width/5, y: 2*bounds.height/5, width: 1*bounds.width/5, height: 1*bounds.height/5))
        let largePath = UIBezierPath(ovalInRect: CGRect(x: bounds.width/5, y: bounds.height/5, width: 3*bounds.width/5, height: 3*bounds.height/5))
        
        // create animations
        let largeAnimation = createAnimation(toPath: largePath, fromPath: smallPath, alpha: 0.5, beginTime: 0)
        let finalSmallAnimation = createAnimation(toPath: smallPath, fromPath: largePath, alpha: 1.0, beginTime: 1)
        
        // group them together
        let group = CAAnimationGroup()
        group.animations = [largeAnimation, finalSmallAnimation]
        group.duration = group.animations!.reduce(0, combine: { (sum, animation) -> CFTimeInterval in
            return sum + animation.duration // get the total animation duration
        })
        
        group.repeatCount = Float.infinity // inifinitely loop these together
        layer.addAnimation(group, forKey: "infinite")
    }
    
    /// Helper function that creates the animation
    private func createAnimation(toPath toPath: UIBezierPath, fromPath: UIBezierPath, alpha : CGFloat, beginTime : CFTimeInterval, duration: CFTimeInterval = 1.0) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "path")
        animation.beginTime = beginTime
        animation.duration = duration
        animation.fromValue = fromPath.CGPath
        animation.toValue = toPath.CGPath
        animation.removedOnCompletion = false
        return animation
    }
}
