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
    
    func scoreDidChange(newScore : Int)
    
    /// Called when an avalanche is avoided and the UI needs to react to that
    func avalancheAvoided()
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
    
    var starNode : StarBackgroundManager!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        gestureDelegate = self
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
        backgroundNode.zPosition = -100000000
        addChild(backgroundNode)
        
        starNode = StarBackgroundManager(position: newCamera.position, scene: self)
        starNode.zPosition = backgroundNode.zPosition - 3
        
        // start the game when the scene is set up
        gameManager.startGame()
        
        let carYPos = gameManager.gameSettings.maxMountainHeight + car.size.height/2
        let carXPos = (gameManager.gameSettings.actualWidth - gameManager.gameSettings.screenWidth)/2 + car.size.width/2 + 20
        car.position = CGPoint(x: carXPos, y: carYPos)
        car.zPosition = 1000001
        car.switchDirection(.Left)
        addChild(car)
        
        swipeRight()
        
        // start for analytics
        AnalyticsManager.gameStarted(car.car!)
    }
    
    override func update(currentTime: CFTimeInterval) {
        // every time the game loop updates, send that update to the game manager, and send the current camera position
        gameManager.update(time: currentTime)
        if gameManager.checkCarPosition(position: car.position, size: car.size, cameraPosition: camera!.position) {
            pause()
        }
        car.explosion?.position = car.position
    }
    
    func endGame(finalScore : Int, avalanches : Int) {
        AnalyticsManager.gameEnded(finalScore, newAvalanches: avalanches, car: car.car!)
        
        camera?.removeAllActions()
        car.removeAllActions()
        backgroundNode.removeAllActions()
        starNode.removeAllActions()
        car.explode()
        weak var weakself = self
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 0.75)), dispatch_get_main_queue(), {
            if let weakself = weakself {
                weakself.gameDelegate?.gameDidEnd(weakself.gameManager.score, newAvalanches: weakself.gameManager.avalanches) // send that action to the delegate for handling
            }
        })
        
    }
}

extension GameScene : SceneGestureDelegate {
    func jump() {
        car.jump()
    }
    
    func endJump() {
        car.stopJump()
    }
    
    func swipeLeft() {
        if car.direction == .Left {
            return
        }
        car.switchDirection(.Left)
        car.removeAllActions()
        let dy = sin(atan(gameManager.gameSettings.angle))/2
        let moveLeftAction = SKAction.moveBy(CGVector(dx: -gameManager.gameSettings.rowWidth * (1 + dy), dy: 0), duration: gameManager.gameSettings.rowRefreshRate)
        car.runAction(SKAction.repeatActionForever(moveLeftAction))
        
        renderer.alterCategoryBitMask()
    }
    
    func swipeRight() {
        if car.direction == .Right {
            return
        }
        car.switchDirection(.Right)
        car.removeAllActions()
        let dy = sin(atan(gameManager.gameSettings.angle))/2
        let moveRightAction = SKAction.moveBy(CGVector(dx: gameManager.gameSettings.rowWidth * (1 + dy), dy: 0), duration: gameManager.gameSettings.rowRefreshRate)
        car.runAction(SKAction.repeatActionForever(moveRightAction))
        
        renderer.alterCategoryBitMask()
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
        starNode.enqueueGameAction(width, height: height, time: time)
    }
    
    func renderRow(row: ResourceRow, color : UIColor, direction : CarDirection, position: CGPoint, duration : CFTimeInterval) {
        // get a list of nodes from the renderer to show on the screen
        renderer.renderResourceRow(row, color: color, direction: direction, position: position, duration: duration)
    }

    func scoreChanged(newScore: Int) {
        gameDelegate?.scoreDidChange(newScore)
    }

    func gameEnded(finalScore finalScore: Int, avalanches: Int) {
        endGame(finalScore, avalanches: avalanches)
    }
    
    func alterBackground(avalanche: Bool) {
        backgroundNode.avalancheActive = avalanche
    }
    
    func avalancheAvoided(gameTotal total: Int) {
        gameDelegate?.avalancheAvoided()
    }
}

// MARK: - Physics Contact delegate methods
extension GameScene {
    override func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == CollisionBitmaskCategory.Spike || contact.bodyB.categoryBitMask == CollisionBitmaskCategory.Spike {
            var spike = contact.bodyA
            var car = contact.bodyB
            if contact.bodyA.categoryBitMask == CollisionBitmaskCategory.Car {
                car = contact.bodyA
                spike = contact.bodyB
            }
            if validateSpikeCollision(spike, car: car, contactPoint: contact.contactPoint) {
                gameManager.pauseRendering()
                endGame(gameManager.score, avalanches: gameManager.avalanches)
            }
        } else if contact.bodyA.categoryBitMask & CollisionBitmaskCategory.Car > 0 && contact.bodyB.categoryBitMask & (CollisionBitmaskCategory.Triangle | CollisionBitmaskCategory.Rectangle) > 0{
            handleCarCollision()
        } else if contact.bodyA.categoryBitMask & (CollisionBitmaskCategory.Triangle | CollisionBitmaskCategory.Rectangle) > 0 && contact.bodyB.categoryBitMask & CollisionBitmaskCategory.Car > 0 {
            handleCarCollision()
        }
    }
    
    /// Method that handles when the car touches back down to the level
    private func handleCarCollision() {
        car.endJump()
        if gameManager.checkCarRotation(car.zRotation) {
            gameManager.pauseRendering()
        }
    }
    
    private func validateSpikeCollision(spike : SKPhysicsBody, car : SKPhysicsBody, contactPoint : CGPoint) -> Bool {
        return true
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
        return gameManager.score
    }
    
    func currentAvalanches() -> Int {
        return gameManager.avalanches
    }
}
