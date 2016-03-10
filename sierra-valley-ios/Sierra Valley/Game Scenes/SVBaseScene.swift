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
            touchTimer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "timerFired", userInfo: nil, repeats: true)
            currentTouch = originalTouch
        }
    }
    
    public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        if let touch = touches.first, view = view {
            currentTouch = touch.locationInView(view)
            
            let threshold : CGFloat = 40
            let xDiff = currentTouch.x - originalTouch.x
            
            if xDiff > 0 && abs(xDiff) > threshold {
                gestureDelegate?.swipeRight()
            } else if xDiff < 0 && abs(xDiff) > threshold {
                gestureDelegate?.swipeLeft()
            }
        }
    }
    
    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        touchTimer?.invalidate()
        touchTimer = nil
        gestureDelegate?.endJump()
    }
    
    func timerFired() {
        let xDiff = currentTouch.x - originalTouch.x
        if abs(xDiff) < 10 {
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
