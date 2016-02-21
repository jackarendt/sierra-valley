//
//  SVBaseScene.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/23/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

/// Base SKScene class that has the tap gestures involved with the game.
public class SVBaseScene: SKScene {
    
    /// The tap gesture is primarily used for making the car jump
    public var tapGesture : UITapGestureRecognizer?
    /// The swipe left gesture is used to make the front of the car face left
    public var swipeLeftGesture : UISwipeGestureRecognizer?
    /// The swipe right gesture is used to make the front of the car face right
    public var swipeRightGesture : UISwipeGestureRecognizer?
    
    override public init(size: CGSize) {
        super.init(size: size)
        // set the gravity to be -8.0m/s^2 (regular gravity is -9.8m/s^2)
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -19.6)
        physicsWorld.contactDelegate = self
        
        // create gestures
        tapGesture = UITapGestureRecognizer(target: self, action: "tapGestureRecognized:")
        tapGesture?.delegate = self
        tapGesture?.numberOfTapsRequired = 1
        
        swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: "swipeLeftGestureRecognized:")
        swipeLeftGesture?.delegate = self
        swipeLeftGesture?.direction = .Left
        
        swipeRightGesture = UISwipeGestureRecognizer(target: self, action: "swipeRightGestureRecognized:")
        swipeRightGesture?.delegate = self
        swipeRightGesture?.direction = .Right
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        view.allowsTransparency = true
        backgroundColor = SKColor.clearColor()
        
        // Add gestures to the view
        view.addGestureRecognizer(tapGesture!)
        view.addGestureRecognizer(swipeLeftGesture!)
        view.addGestureRecognizer(swipeRightGesture!)
    }
    
    // MARK: - Gesture recognizer selectors
    
    /// Called when the view recognizes a tap gesture
    public func tapGestureRecognized(tap : UITapGestureRecognizer) {
        
    }
    
    /// Called when the player swipes to the left (<-)
    public func swipeLeftGestureRecognized(swipeLeft : UISwipeGestureRecognizer) {
        
    }
    
    /// Called when the player swipes to the right
    public func swipeRightGestureRecognized(swipeRight : UISwipeGestureRecognizer) {
        
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
