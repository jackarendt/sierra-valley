//
//  PauseView.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/23/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import UIKit

protocol PauseViewDelegate : class {
    func pauseViewDidHitResume(pauseView : PauseView)
}

/// Shows the view for when the game is pause
class PauseView: SVPauseBaseView {
    
    weak var delegate : PauseViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        titleText = "PAUSE"
        subtitleText = "TAP TO RESUME"
    }
    
    override func tapGestureRecognized(gesture: UITapGestureRecognizer) {
        super.tapGestureRecognized(gesture)
        delegate?.pauseViewDidHitResume(self)
    }
}
