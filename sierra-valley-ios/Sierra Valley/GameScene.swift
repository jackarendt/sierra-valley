//
//  GameScene.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/18/16.
//  Copyright (c) 2016 John Arendt. All rights reserved.
//

import SpriteKit

/// Protocol for relaying information from the game scene to the view controller
protocol GameSceneDelegate : class {
    /// Called when the game has finished (car ran into an obstacle, or off the map)
    /// - Parameter finalScore: The final score that the user ended up with
    /// - Parameter newAvalanches: The number of new avalanches that the user got
    func gameDidEnd(finalScore : Int, newAvalanches : Int)
}

/// The GameScene is where the actual game takes place.  A majority of the game logic has been loaded off of the scene
/// so that it can be easily expanded to other platforms easily.  It mainly acts as a router of logic and rendering.
/// However, it does experience all of the different actions throughout the lifetime of the game.
class GameScene: SVBaseScene {
    
    /// Delegate for relaying all pertinent information about the game
    weak var gameDelegate : GameSceneDelegate?
    
    /// Manages all of the important game operations such as level creation and what to render
    var gameManager : GameManager!
    
    /// Handles all of the rendering and actions of a scene.  It will setup the level by managing all of the different
    /// buffers, and handle rendering the correct row & different obstacles along the way.
    var renderer : Renderer!
    
    /// The car that is part of the game.  Currently just set as the only available car.  will change later
    let car = CarNode(car: .SierraTurbo)
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        // create game manager and renderer
        gameManager = GameManager(delegate: self)
        renderer = Renderer(scene: self)
        
        // create the camera node, and make it the default camera of the game
        let newCamera = SKCameraNode()
        newCamera.position = CGPoint(x: gameManager.gameSettings.actualWidth/2, y: view.bounds.height/2)
        newCamera.xScale = view.bounds.width / size.width
        newCamera.yScale = view.bounds.height / size.height
        camera = newCamera
        
        renderer.camera = newCamera
        blendMode = .Replace

        
        // start the game when the scene is set up
        gameManager.startGame()
    }
    
    override func tapGestureRecognized(tap: UITapGestureRecognizer) {
        
    }
    
    override func swipeLeftGestureRecognized(swipeLeft: UISwipeGestureRecognizer) {
        car.switchDirection(.Left)
    }
    
    override func swipeRightGestureRecognized(swipeRight: UISwipeGestureRecognizer) {
        car.switchDirection(.Right)
    }
   
    override func update(currentTime: CFTimeInterval) {
        // every time the game loop updates, send that update to the game manager, and send the current camera position
        gameManager.update(currentTime)
    }
}

// MARK: - GameManagerDelegate
extension GameScene : GameManagerDelegate {
    func levelDequeuedWithCameraAction(width: CGFloat, height: CGFloat, time: CFTimeInterval) {
        renderer.enqueueCameraAction(width, height: height, time: time) // enqueue camera action
    }
    
    
    func renderRow(row: ResourceRow, color : UIColor, direction : CarDirection, position: CGPoint, background : Bool) {
        // get a list of nodes from the renderer to show on the screen
        renderer.renderResourceRow(row, color: color, direction: direction, position: position, background: background)
    }

    func scoreChanged(newScore: Int) {
        // TODO: update the score of the game
    }

    func gameEnded(finalScore: Int) {
        gameDelegate?.gameDidEnd(0, newAvalanches: 0) // send that action to the delegate for handling
    }
}

// MARK: - Physics Contact delegate methods
extension GameScene {
    override func didBeginContact(contact: SKPhysicsContact) {
        pause() // pause the scene
        gameDelegate?.gameDidEnd(0, newAvalanches: 0) // end the game
    }
    
    override func didEndContact(contact: SKPhysicsContact) {
        
    }
}

// MARK: - Selectors
extension GameScene {
    /// Pauses the game
    func pause() {
        gameManager.pause()
        view?.paused = true
    }
    
    /// Resumes the game
    func resume() {
        view?.paused = false
    }
    
    /// Returns the current distance that the car has traveled
    func currentDistance() -> Int {
        return 0 // TODO: update this with real data
    }
}
