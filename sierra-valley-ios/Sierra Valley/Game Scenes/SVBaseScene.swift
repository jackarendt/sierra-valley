//
//  SVBaseScene.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/23/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

public protocol SceneGestureDelegate : class {
    func jump()
    func endJump()
    func swipeLeft()
    func swipeRight()
}

/// Base SKScene class that has the tap gestures involved with the game.
public class SVBaseScene: SKScene {
    
    /// Delegate methods for when game gestures happen
    public weak var gestureDelegate : SceneGestureDelegate?
    
    /// The original location of a touch event
    private var originalTouch = CGPoint.zero
    
    private var currentTouch = CGPoint.zero
    
    /// Timer for starting to jump
    private var touchTimer : NSTimer?
    
    /// Start time of a touch event
    private var startTouchTime = NSDate.distantPast()
    
    /// The interval in which the timer fires
    private let timerInterval : NSTimeInterval = 0.05
    
    /// Boolean for whether a gesture has been handled or not
    private var gestureHandled = false
    
    override public init(size: CGSize) {
        super.init(size: size)
        // set the gravity
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -19.6)
        physicsWorld.contactDelegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        view.allowsTransparency = true
        backgroundColor = SKColor.clearColor()
    }
    
    // MARK: - Gesture recognizer selectors
    
    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        if let touch = touches.first, view = view {
            originalTouch = touch.locationInView(view)
            touchTimer = NSTimer.scheduledTimerWithTimeInterval(timerInterval, target: self, selector: "timerFired", userInfo: nil, repeats: true)
            currentTouch = originalTouch
            startTouchTime = NSDate()
        }
    }
    
    public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        if let touch = touches.first, view = view {
            currentTouch = touch.locationInView(view)
            
            let threshold : CGFloat = 40
            let xDiff = currentTouch.x - originalTouch.x
            
            if xDiff > 0 && abs(xDiff) > threshold && !gestureHandled {
                gestureDelegate?.swipeRight()
                gestureHandled = true
            } else if xDiff < 0 && abs(xDiff) > threshold && !gestureHandled {
                gestureDelegate?.swipeLeft()
                gestureHandled = true
            }
        }
    }
    
    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        // if the touch is less than the timer interval, then just automatically jump
        // symbolizes a super fast jump
        if NSDate().timeIntervalSinceDate(startTouchTime) < timerInterval {
            gestureDelegate?.jump()
        }
        touchTimer?.invalidate()
        touchTimer = nil
        gestureDelegate?.endJump()
        gestureHandled = false
    }
    
    func timerFired() {
        let xDiff = currentTouch.x - originalTouch.x
        if abs(xDiff) < 1 {
            gestureDelegate?.jump()
        }
    }
}

// MARK: - Physics world contact delegate
extension SVBaseScene : SKPhysicsContactDelegate {
    public func didBeginContact(contact: SKPhysicsContact) {

    }
    
    public func didEndContact(contact: SKPhysicsContact) {
        
    }
}

// MARK: - Gesture recorgnizer delegate
extension SVBaseScene : UIGestureRecognizerDelegate {
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
