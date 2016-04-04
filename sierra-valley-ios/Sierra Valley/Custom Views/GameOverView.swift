//
//  GameOverView.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/24/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import UIKit

protocol GameOverViewDelegate : class {
    func gameOverViewDidHitRetry(gameOverView : GameOverView)
    func gameOverViewDidHitNewCar(gameOverView : GameOverView)
    func gameOverViewDidHitShare(gameOverView : GameOverView)
    func gameOverViewDidHitLeaderboard(gameOverView : GameOverView)
}

class GameOverView: SVPauseBaseView {
    
    weak var delegate : GameOverViewDelegate?
    
    var canWinNewCar = false
    
    private let shareButton = SVBorderedButton()
    private let leaderboardButton = SVBorderedButton()
    private let highScoreLabel = UILabel()
    
    override var distance: Int {
        didSet {
            if distance == Database.database.user.highScore {
                highScoreLabel.text = "NEW PEAK!"
            } else {
                highScoreLabel.text = "PEAK: " + Database.database.user.highScore.description
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        titleText = "GAME OVER"
        subtitleText = "TAP TO RETRY"
        
        shareButton.frame = CGRect(x: 40, y: bounds.height - 70, width: bounds.width/2 - 60, height: 45)
        shareButton.setTitle("SHARE", forState: .Normal)
        shareButton.setFontSize(25)
        shareButton.addTarget(self, action: #selector(GameOverView.shareButtonTapped(_:)), forControlEvents: .TouchUpInside)
        addSubview(shareButton)
        
        leaderboardButton.frame = CGRect(x: bounds.width/2, y: bounds.height - 70, width: bounds.width/2 - 60, height: 45)
        leaderboardButton.setTitle("LEADERBOARD", forState: .Normal)
        leaderboardButton.setFontSize(25)
        leaderboardButton.addTarget(self, action: #selector(GameOverView.leaderboardButtonTapped(_:)), forControlEvents: .TouchUpInside)
        addSubview(leaderboardButton)
        
        highScoreLabel.frame = CGRect(x: distanceLabel.frame.origin.x, y: distanceLabel.frame.maxY, width: bounds.width/2, height: 25)
        highScoreLabel.textColor = SVColor.lightColor()
        highScoreLabel.font = UIFont.svHeavyFont(25)
        addSubview(highScoreLabel)
    }
    
    override func tapGestureRecognized(gesture: UITapGestureRecognizer) {
        if canWinNewCar {
            delegate?.gameOverViewDidHitNewCar(self)
        } else {
            delegate?.gameOverViewDidHitRetry(self)
        }
    }
    
    func shareButtonTapped(button : SVBorderedButton) {
        delegate?.gameOverViewDidHitShare(self)
    }
    
    func leaderboardButtonTapped(button : SVBorderedButton) {
        delegate?.gameOverViewDidHitLeaderboard(self)
    }

}
