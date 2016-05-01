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
    func renderRow(row : ResourceRow, color : UIColor, direction : CarDirection, position : CGPoint, duration : CFTimeInterval)
    
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
    func gameEnded(finalScore finalScore : Int, avalanches : Int)
    
    /// Changes the background to make it either an avalanche or not
    /// - Parameter avalanche: Whether the background should resemeble an avalanche or not
    func alterBackground(avalanche : Bool)
    
    /// Called when the user avoids an avalanche successfully
    /// - Parameter total: The total number of avalanches passed that round
    func avalancheAvoided(gameTotal total : Int)
}

/// The GameManager manages level generation, and telling the delegate what to render, where it should placed and when. 
/// It also handles updating the score, and determining how hard a level should be.
final public class GameManager {
    
    weak public var delegate : GameManagerDelegate?
    
    /// The score of the game
    public var score = 0
    
    /// The number of avalanches that have passed
    public var avalanches = 0
    
    /// The number of total frames that have been passed since the beginning
    /// - Note: Used for scoring
    private var totalFrames = 0
    
    /// Game settings, specifically different things about the game such as frames/row, height difference between rows, amongst
    /// many other things
    public let gameSettings = GameSettings.sharedSettings
    
    /// The number of rows that need to pass for the score to change
    public let scoreOffset = 10
    
    /// The previous time the gameloop was updated. (used for counting frames)
    private var previousTime : CFTimeInterval = 0
    
    /// Number of frames that have passed since the last row was rendered on screen
    private var frameCount = 0
    
    /// Boolean denoting whether a scene is ready to be rendered.  This helps delay lag
    private var readyToRender = false
    
    /// Contains all of the levels of the game, and also creates new levels when needed
    private var levelQueue = LevelQueue()
    
    /// The current level being rendered
    private var level : Level!
    
    /// The current direction that the car is moving
    private var currentDirection : CarDirection = .Right
    
    /// The x-location where new rows should be rendered
    private var renderXLocation : CGFloat = 0
    
    /// The y-location where new rows should be rendered
    private var renderYLocation : CGFloat = 0
    
    /// Current color of the level being rendered
    private var color = SVColor.levelPrimaryColor()
    
    /// The color of the level when the car is heading to the right
    private let rightColor = SVColor.levelPrimaryColor()
    
    /// The color of the level when the car is heading to the left
    private let leftColor = SVColor.levelSecondaryColor()
    
    /// Initializes the game manager.  Using the game manager with the delegate is required.
    /// If the delegate was not used, this would basically be a useless class now wouldn't it?
    public init(delegate : GameManagerDelegate) {
        self.delegate = delegate // set the delegate
        self.level = levelQueue.dequeue()
    }

    /// Call this when the game starts to start placing sprites
    public func startGame() {
        let introLevelQueue = Queue<ResourceRow>()
        generateOpeningFlatLevel(Int(gameSettings.numFrames), queue: introLevelQueue)
        renderYLocation = UIScreen.mainScreen().bounds.height/2 + gameSettings.triangleHeight
        while let row = introLevelQueue.dequeue() {
            // make the beginning height half of the screen, plus adjust it up to the height of a triangle to simulate
            // it passing by one render before the level starts for a smooth transition
            let pos = CGPoint(x: renderXLocation, y:  renderYLocation)
            delegate?.renderRow(row, color: color, direction: currentDirection, position: pos, duration: -1)
            renderXLocation += gameSettings.rowWidth
        }
        delegate?.levelDequeuedWithCameraAction(level.levelWidth, height: level.levelHeight, time: level.levelTime)
        readyToRender = true
    }
    
    /// Call this to temporarily pause the game loop from updating.
    public func pause() {
        previousTime = 0
    }
    
    public func pauseRendering() {
        readyToRender = false
    }
    
    /// Checks to see if the car has rotated on to its back
    /// - Parameter rotation: The zRotation of the car
    /// - Returns: Boolean denoting whether the car is on it's back or not
    public func checkCarRotation(rotation : CGFloat) -> Bool {
        var adjustedRotation = rotation
        if rotation < 0 { // make the value between 0 and 2 pi
            adjustedRotation += CGFloat(2 * M_PI)
        }
        
        if adjustedRotation > CGFloat(M_PI) - gameSettings.angle && adjustedRotation < CGFloat(M_PI) + gameSettings.angle {
            pauseRendering()
            delegate?.gameEnded(finalScore: score, avalanches: avalanches)
            return true
        }
        return false
    }
    
    /// Checks to see if the car is still on the screen, only checks to make sure it is above the minimum height
    /// - Parameter position: The position of the car
    /// - Paremeter size: The size of the car
    /// - Returns: Whether the car is on or off screen
    public func checkCarPosition(position position : CGPoint, size : CGSize, cameraPosition : CGPoint) -> Bool {
        let minY = renderYLocation - size.height - gameSettings.maxMountainHeight
        let minX = cameraPosition.x - gameSettings.screenWidth/2 - size.width
        let maxX = cameraPosition.x + gameSettings.screenWidth/2 + size.width
        if position.y < minY || position.x < minX || position.x > maxX { // checks to see if the car is still above the screen
            pauseRendering()
            delegate?.gameEnded(finalScore: score, avalanches: avalanches)
            return true
        }
        return false
    }
    
    
    /// Updates the game state, and determines if new pieces should be rendered, or if a level should be dequeued, etc.
    /// - Parameter time: The time of the game loop
    public func update(time time : CFTimeInterval) {
        if previousTime != 0 { // if this is the first loop, just ignore it
            frameCount += calcPassedFrames(time) // add the new frames to the game
            
            // if the game is ready to render, and sufficient frames have passed, create a new row
            if frameCount >= gameSettings.framesPerRow && readyToRender {
                // get the difference of the frame count and suggested frames/row
                let diff = frameCount - gameSettings.framesPerRow
                frameCount = diff // assign it to the frame count for smooth operations
                
                // dequeue a new level
                if level.rows.isEmpty() {
                    dequeueNewLevel()
                }
                
                // dequeue a new row, and render it
                if let row = level.rows.dequeue() {
                    if !row.isEmpty {
                        totalFrames += 1
                        score = totalFrames/scoreOffset
                        delegate?.scoreChanged(score)
                    }
                    let position = CGPoint(x: renderXLocation, y: renderYLocation)
                    delegate?.renderRow(row, color: color, direction: currentDirection, position: position, duration: -1)
                    adjustRenderLocation()
                }
                
                let remainingLevelRows = level.rows.count - level.flatRowCount - 1
                if remainingLevelRows < gameSettings.framesToTop  && remainingLevelRows >= 0 {
                    dequeueBackgroundRow(remainingLevelRows)
                }
            }
        }
        previousTime = time
    }
    
    /// Updates where the next row is rendered
    private func adjustRenderLocation() {
        if currentDirection == .Left { // if heading to the left,
            renderXLocation -= gameSettings.rowWidth
        } else {
            renderXLocation += gameSettings.rowWidth
        }
        renderYLocation += gameSettings.triangleHeight
    }
    
    /// Dequeues a new level from the level queue and alerts the delegate that
    /// a new level has been dequeued.
    private func dequeueNewLevel() {
        if level.avalanche { // if the previous level was an avalanche, increment it and say that the avalanche was avoided
            avalanches += 1
            delegate?.avalancheAvoided(gameTotal: avalanches)
        }
        level = levelQueue.dequeue()
        
        delegate?.alterBackground(level.avalanche)
        var levelWidth = level.levelWidth
        if currentDirection == .Right {
            currentDirection = .Left
            levelWidth *= -1
            renderXLocation = renderXLocation - gameSettings.actualWidth
            color = leftColor
        } else {
            currentDirection = .Right
            renderXLocation = renderXLocation + gameSettings.actualWidth
            color = rightColor
        }
        delegate?.levelDequeuedWithCameraAction(levelWidth, height: level.levelHeight, time: level.levelTime)
    }
    
    /// Dequeues a new row for background use
    /// - Parameter remainingLevelRows: The number of rows until the flat row is 
    private func dequeueBackgroundRow(remainingLevelRows : Int) {
        let row = ResourceRow(row: [.Rectangle, .Triangle], depressedHeight: 0)
        var c = rightColor
        if currentDirection == .Right {
            c = leftColor // use the opposite color
        }
        let yPos = renderYLocation + (gameSettings.maxMountainHeight - gameSettings.minMountainHeight) * CGFloat(2 * remainingLevelRows) / CGFloat(gameSettings.framesToTop)
        delegate?.renderRow(row, color: c, direction: CarDirection.oppositeDirection(currentDirection), position: CGPoint(x: renderXLocation, y: yPos), duration: CFTimeInterval(gameSettings.numFrames) * 0.75 * gameSettings.vSyncTime)
    }
    
    /// Calculates the number of frames that have passed since the last update
    /// - Parameter time: The current time of the application
    /// - Returns: The number of frames that have passed
    private func calcPassedFrames(time : CFTimeInterval) -> Int {
        let diff = time - previousTime // get time difference
        return Int(round(60 * diff)) // get the approximate number of frames that have passed
    }
}