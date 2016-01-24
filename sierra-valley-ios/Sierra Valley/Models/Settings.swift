//
//  Settings.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/23/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import Foundation

/// Class maintaining the global settings of the game
class Settings {
    private let soundMutedKey = "sound-muted"
    private let musicMutedKey = "music-muted"
    
    init() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        soundMuted = userDefaults.boolForKey(soundMutedKey)
        musicMuted = userDefaults.boolForKey(musicMutedKey)
    }
    
    /// Boolean denoting whether sound is currently active or not
    var soundMuted : Bool {
        didSet {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setBool(soundMuted, forKey: soundMutedKey)
            userDefaults.synchronize()
        }
    }
    
    /// Boolean denoting whether music is currently active or not
    var musicMuted : Bool {
        didSet {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setBool(musicMuted, forKey: musicMutedKey)
            userDefaults.synchronize()
        }
    }
}