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
    
    /// Handles all of the rendering of sprites on the screen
    var renderer : Renderer!
    
    /// The background mountains that parallax with the game
    var backgroundNode : ParallaxBackgroundNode!
    
    /// The car that is part of the game.  Currently just set as the only available car.  will change later
    let car = CarNode(car: .SierraTurbo)
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        // create game manager and renderer
        gameManager = GameManager(delegate: self)
        renderer = Renderer(scene: self)
        
        // create the camera node, and make it the default camera of the game
        let newCamera = CameraNode()
        newCamera.position = CGPoint(x: gameManager.gameSettings.actualWidth/2, y: view.bounds.height/2)
        newCamera.xScale = view.bounds.width / size.width
        newCamera.yScale = view.bounds.height / size.height
        camera = newCamera
        addChild(newCamera)

        blendMode = .Alpha

        backgroundNode = ParallaxBackgroundNode()
        backgroundNode.position = CGPoint(x: gameManager.gameSettings.actualWidth/2 + 50, y: view.bounds.height/2)
        addChild(backgroundNode)
        
        // start the game when the scene is set up
        gameManager.startGame()
        
        let carYPos = gameManager.gameSettings.maxMountainHeight + car.size.height/2
        let carXPos = (gameManager.gameSettings.actualWidth - gameManager.gameSettings.screenWidth)/2 + car.size.width/2 + 20
        car.position = CGPoint(x: carXPos, y: carYPos)
        addChild(car)
        car.zPosition = 101
        swipeRightGestureRecognized(UISwipeGestureRecognizer()) // GET RID OF THIS NONSENSE
    }
    
    override func tapGestureRecognized(tap: UITapGestureRecognizer) {
        car.jump()
    }
    
    override func swipeLeftGestureRecognized(swipeLeft: UISwipeGestureRecognizer) {
        car.switchDirection(.Left)
        car.removeAllActions()
        let moveLeftAction = SKAction.moveBy(CGVector(dx: -gameManager.gameSettings.rowWidth, dy: 0), duration: gameManager.gameSettings.rowRefreshRate)
        car.runAction(SKAction.repeatActionForever(moveLeftAction))
        
        renderer.alterCategoryBitMask()
    }
    
    override func swipeRightGestureRecognized(swipeRight: UISwipeGestureRecognizer) {
        car.switchDirection(.Right)
        car.removeAllActions()
        let moveRightAction = SKAction.moveBy(CGVector(dx: gameManager.gameSettings.rowWidth, dy: 0), duration: gameManager.gameSettings.rowRefreshRate)
        car.runAction(SKAction.repeatActionForever(moveRightAction))
        
        renderer.alterCategoryBitMask()
    }
   
    override func update(currentTime: CFTimeInterval) {
        // every time the game loop updates, send that update to the game manager, and send the current camera position
        gameManager.update(currentTime)
    }
}

// MARK: - GameManagerDelegate
extension GameScene : GameManagerDelegate {
    func levelDequeuedWithCameraAction(width: CGFloat, height: CGFloat, time: CFTimeInterval) {
        renderer.incrementBufferPool()
        if let camera = camera as? CameraNode {
            camera.enqueueGameAction(width, height: height, time: time) // enqueue camera action
        }
        var backgroundWidth = width - 100
        if width < 0 {
            backgroundWidth = width + 100
        }
        
        backgroundNode.enqueueGameAction(backgroundWidth, height: height, time: time)
    }
    
    func renderRow(row: ResourceRow, color : UIColor, direction : CarDirection, position: CGPoint, duration : CFTimeInterval) {
        // get a list of nodes from the renderer to show on the screen
        renderer.renderResourceRow(row, color: color, direction: direction, position: position, duration: duration)
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
        
        if contact.bodyA.node?.name == SVLevelResource.Spike.rawValue && contact.bodyB.node?.name == SVLevelResource.Spike.rawValue {
            pause() // pause the scene
            gameDelegate?.gameDidEnd(0, newAvalanches: 0) // end the game
        }
    }
    
    override func didEndContact(contact: SKPhysicsContact) {
        car.endJump()
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
