//
//  GameManager.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/24/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import UIKit

/// The GameManagerDelegate is a collection of methods used to execute critical game functionality
/// such as rendering on screen objects, moving the camera, ending the game, and updating the score.
public protocol GameManagerDelegate : class {
    /// Tells the delegate to render a given row with a color
    /// - Parameter row: The specific row encoding for rendering.  Includes what pieces to use, and at what height
    /// - Parameter color: The color of the row to be rendered
    /// - Parameter direction: The direction of the triangle.
    /// - Parameter position: The position where the row should be rendered.
    func renderRow(row : ResourceRow, color : UIColor, direction : CarDirection, position : CGPoint)
    
    /// Tells the delegate to enqueue a camera action for the specific values
    /// - Parameter width: The length that the camera will pan across the x-axis
    /// - Parameter height: The height that the camera will pan across the y-axis
    /// - Parameter time: The time it takes to complete that action
    func levelDequeuedWithCameraAction(width : CGFloat, height : CGFloat, time : CFTimeInterval)
    
    /// Called when the score changed
    /// - Parameter newScore: The updated score of the game
    func scoreChanged(newScore : Int)
    
    /// Called when the game has ended.
    // TODO: revise this function
    func gameEnded(finalScore : Int)
}

/// The GameManager manages level generation, and telling the delegate what to render, where it should placed and when. 
/// It also handles updating the score, and determining how hard a level should be.
final public class GameManager {
    
    weak public var delegate : GameManagerDelegate?
    
    /// The score of the game
    public var score = 0
    
    /// Game settings, specifically different things about the game such as frames/row, height difference between rows, amongst
    /// many other things
    public let gameSettings = GameSettings()
    
    /// The previous time the gameloop was updated. (used for counting frames)
    private var previousTime : CFTimeInterval = 0
    
    /// Number of frames that have passed since the last row was rendered on screen
    private var frameCount = 0
    
    /// Boolean denoting whether a scene is ready to be rendered.  This helps delay lag
    private var readyToRender = false
    
    /// Initializes the game manager.  Using the game manager with the delegate is required.
    /// If the delegate was not used, this would basically be a useless class now wouldn't it?
    public init(delegate : GameManagerDelegate) {
        self.delegate = delegate // set the delegate
    }
    
    // bullshit temp variables until i get setup correctly
    private var orange = true
    private var level : Level!
    
    /// Call this when the game starts to start placing sprites
    public func startGame() {
        level = Level(settings: gameSettings, difficulty: 0)
        delegate?.levelDequeuedWithCameraAction(level.levelWidth, height: level.levelHeight, time: level.levelTime)
        readyToRender = true
    }
    
    /// Call this to temporarily pause the game loop from updating.
    public func pause() {
        previousTime = 0
//        readyToRender = false
    }
    
    /// Call this to resume the game after pausing
    public func resume() {
//        readyToRender = true
    }
    
    
    /// Updates the game state, and determines if new pieces should be rendered, or if a level should be dequeued, etc.
    /// - Parameter time: The time of the game loop
    /// - Parameter cameraPosition: the position of the camera at that specific time
    public func update(time : CFTimeInterval, var cameraPosition : CGPoint) {
        if previousTime != 0 { // if this is the first loop, just ignore it
            frameCount += calcPassedFrames(time) // add the new frames to the game
            
            // if the game is ready to render, and sufficient frames have passed, create a new row
            if frameCount >= gameSettings.framesPerRow && readyToRender {
                
                // get the difference of the frame count and suggested frames/row
                let diff = frameCount - gameSettings.framesPerRow
                frameCount = diff // assign it to the frame count for smooth operations
                
                // move the camera position accordingly so that the pieces line up correctly
                cameraPosition.x += (gameSettings.rowWidth/CGFloat(gameSettings.framesPerRow)) * CGFloat(diff)
                
                // FOR DEBUG USE ONLY
                var color = SVColor.maroonColor()
                if orange {
                    color = SVColor.orangeColor()
                }
                orange = !orange
                
                // dequeue a new row, and render it
                if let row = level.rows.dequeue() {
                    delegate?.renderRow(row, color: color, direction: .Right, position: cameraPosition)
                } else { // if false, do some bullshit temporarily.  TODO: actually move to new level
                    delegate?.levelDequeuedWithCameraAction(-900, height: 120, time: 3)
                }
            }
        }
        previousTime = time
    }
    
    /// Calculates the number of frames that have passed since the last update
    /// - Parameter time: The current time of the application
    private func calcPassedFrames(time : CFTimeInterval) -> Int {
        let diff = time - previousTime // get time difference
        return Int(round(60 * diff)) // get the approximate number of frames that have passed
    }
}