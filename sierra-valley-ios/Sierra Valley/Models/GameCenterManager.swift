//
//  GameCenterManager.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 4/17/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import Foundation
import GameKit


public class GameCenterManager : NSObject {
    
    static public let sharedManager = GameCenterManager()
    
    public var defaultLeaderboard = ""
    
    public var userLoggedIn : Bool {
        get {
            return GKLocalPlayer.localPlayer().authenticated
        }
    }
    
    public override init() {
        super.init()
        GKLocalPlayer.localPlayer().authenticateHandler = { (viewController, error) in
            AnalyticsManager.gameCenterEnabled(error == nil, errorCode: error?.code)
            self.loadLeaderBoards()
        }
    }
    
    private func loadLeaderBoards() {
        guard userLoggedIn else {
            return
        }
        
        GKLocalPlayer.localPlayer().loadDefaultLeaderboardIdentifierWithCompletionHandler { (leaderboard, error) in
            if let leaderboard = leaderboard {
                self.defaultLeaderboard = leaderboard
                print("default leaderboard: " + leaderboard)
                self.loadHighScores(leaderboard)
            }
        }
    }
    
    func loadHighScores(leaderboard: String) {
        let request = GKLeaderboard()
        request.identifier = leaderboard
        request.loadScoresWithCompletionHandler { (scores, error) in
            guard error == nil else {
                print(error)
                return
            }
            if let highScore = request.localPlayerScore?.value where Int(highScore) > Database.database.user.highScore {
                Database.database.user.highScore = Int(highScore)
                Database.database.save()
            }
        }
    }
    
    public func reportScore(peak : Int) {
        guard defaultLeaderboard.characters.count > 0 else {
            print("no default leaderboard")
            return
        }
        let score = GKScore(leaderboardIdentifier: defaultLeaderboard)
        score.shouldSetDefaultLeaderboard = true
        score.value = Int64(peak)
        
        GKScore.reportScores([score], withCompletionHandler: { error in
            if let error = error {
                print(error.debugDescription)
            } else {
                print("score reported")
            }
        })
    }
    
    public func showLeaderboard(fromViewController : UIViewController) {
        guard defaultLeaderboard.characters.count > 0 else {
            showGameCenterError(fromViewController, errorMessage: "Game Center Currently Unavailable")
            return
        }
        let gameCenterVC = GKGameCenterViewController()
        gameCenterVC.gameCenterDelegate = self
        gameCenterVC.viewState = .Leaderboards
        gameCenterVC.leaderboardIdentifier = self.defaultLeaderboard
        fromViewController.presentViewController(gameCenterVC, animated: true, completion: nil)
        
    }
    
    private func showGameCenterError(fromViewController: UIViewController, errorMessage: String) {
        print(errorMessage)
    }
}


extension GameCenterManager : GKGameCenterControllerDelegate {
    public func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}