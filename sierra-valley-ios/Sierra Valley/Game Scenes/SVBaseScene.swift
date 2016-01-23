//
//  SVBaseScene.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/23/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

/// Base SKScene class that has the tap gestures involved with the game.
public class SVBaseScene: SKScene, UIGestureRecognizerDelegate, SKPhysicsContactDelegate {
    
    public var tapGesture : UITapGestureRecognizer?
    public var swipeLeftGesture : UISwipeGestureRecognizer?
    public var swipeRightGesture : UISwipeGestureRecognizer?
    
    
    override public init(size: CGSize) {
        super.init(size: size)
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -8.0)
        physicsWorld.contactDelegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func didMoveToView(view: SKView) {
        // Add tap gesture for jumping
        tapGesture = UITapGestureRecognizer(target: self, action: "tapGestureRecognized:")
        tapGesture?.delegate = self
        view.addGestureRecognizer(tapGesture!)
        
        // Add swipe left gesture for facing the car to the left
        swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: "swipeLeftGestureRecognized:")
        swipeLeftGesture?.delegate = self
        swipeLeftGesture?.direction = .Left
        view.addGestureRecognizer(swipeLeftGesture!)
        
        // Add swipe right gesture for facing the car to the right
        swipeRightGesture = UISwipeGestureRecognizer(target: self, action: "swipeRightGestureRecognized:")
        swipeRightGesture?.delegate = self
        swipeRightGesture?.direction = .Right
        view.addGestureRecognizer(swipeRightGesture!)
    }
    
    // MARK: - Gesture recognizer selectors
    
    public func tapGestureRecognized(tap : UITapGestureRecognizer) {
        
    }
    
    public func swipeLeftGestureRecognized(swipeLeft : UISwipeGestureRecognizer) {
        
    }
    
    public func swipeRightGestureRecognized(swipeRight : UISwipeGestureRecognizer) {
        
    }
    
    // MARK: - Gesture recorgnizer delegate
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: - Physics world contact delegate
    public func didBeginContact(contact: SKPhysicsContact) {
        
    }
}
