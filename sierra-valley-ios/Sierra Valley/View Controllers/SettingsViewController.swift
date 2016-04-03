//
//  SettingsViewController.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/19/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import UIKit

class SettingsViewController: SVBaseViewController {

    private let helpButton = SVBorderedButton()
    private let restoreButton = SVBorderedButton()
    private let removeButton = SVBorderedButton()
    
    private let musicButton = SVBorderedButton()
    private let soundButton = SVBorderedButton()
    
    private let scrollView = UIScrollView()
    
    private let settings = Settings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gaName = "Settings" // set the name for Google Analytics
        
        navigationTitle = "SETTINGS"
        leftNavigationButton.setImage(UIImage(asset: .CloseButton), forState: .Normal)
        // Do any additional setup after loading the view.
        
        scrollView.frame = CGRect(x: 0, y: navigationTitleLabel.frame.maxY, width: view.bounds.width, height: view.bounds.height - navigationTitleLabel.frame.maxY)
        scrollView.bounces = false
        scrollView.indicatorStyle = .White
        contentView.addSubview(scrollView)
        
        let _musicLabel = UILabel(frame: CGRect(x: 20, y: 20, width: scrollView.frame.width/2 - 80, height: 35))
        _musicLabel.text = "MUSIC"
        _musicLabel.font = UIFont.svHeavyFont(30)
        _musicLabel.textColor = SVColor.lightColor()
        scrollView.addSubview(_musicLabel)
        
        musicButton.frame = CGRect(x: scrollView.frame.width - 75, y: _musicLabel.frame.origin.y, width: 55, height: 35)
        musicButton.setImage(UIImage(asset: .VolumeIcon), forState: .Normal)
        musicButton.imageEdgeInsets = UIEdgeInsets(top: 3, left: 10, bottom: 3, right: 10)
        musicButton.addTarget(self, action: #selector(SettingsViewController.musicButtonTapped(_:)), forControlEvents: .TouchUpInside)
        scrollView.addSubview(musicButton)
        
        let _soundLabel = UILabel(frame: CGRect(x: 20, y: _musicLabel.frame.maxY + 40, width: scrollView.frame.width/2 - 80, height: 35))
        _soundLabel.text = "SOUND"
        _soundLabel.font = UIFont.svHeavyFont(30)
        _soundLabel.textColor = SVColor.lightColor()
        scrollView.addSubview(_soundLabel)
        
        soundButton.frame = CGRect(x: scrollView.frame.width - 75, y: _soundLabel.frame.origin.y, width: 55, height: 35)
        soundButton.setImage(UIImage(asset: .VolumeIcon), forState: .Normal)
        soundButton.imageEdgeInsets = UIEdgeInsets(top: 3, left: 10, bottom: 3, right: 10)
        soundButton.addTarget(self, action: #selector(SettingsViewController.soundButtonTapped(_:)), forControlEvents: .TouchUpInside)
        scrollView.addSubview(soundButton)
        
        let _themeLabel = UILabel(frame: CGRect(x: 20, y: _soundLabel.frame.maxY + 40, width: scrollView.frame.width/2 - 80, height: 35))
        _themeLabel.text = "THEME"
        _themeLabel.font = UIFont.svHeavyFont(30)
        _themeLabel.textColor = SVColor.lightColor()
        scrollView.addSubview(_themeLabel)
        
        let _segmented = SVSegmentedControl(items: ["TIME", "DAY", "NIGHT"])
        _segmented.frame = CGRect(x: scrollView.frame.width - 220, y: _themeLabel.frame.origin.y, width: 200, height: _themeLabel.frame.height)
        _segmented.setFont(UIFont.svHeavyFont(18)!)
        _segmented.selectedSegmentIndex = settings.theme.rawValue
        _segmented.addTarget(self, action: #selector(themeChanged(_:)), forControlEvents: .ValueChanged)
        scrollView.addSubview(_segmented)
        
        restoreButton.frame = CGRect(x: 20, y: _themeLabel.frame.maxY + 40, width: scrollView.bounds.width/2 - 40, height: 45)
        restoreButton.setTitle("RESTORE PURCHASES", forState: .Normal)
        restoreButton.setFontSize(min(25, scrollView.bounds.width * 0.03748))
        scrollView.addSubview(restoreButton)
        
        removeButton.frame = CGRect(x: scrollView.bounds.width/2 + 20, y: _themeLabel.frame.maxY + 40, width: scrollView.bounds.width/2 - 40, height: 45)
        removeButton.setTitle("REMOVE ADS", forState: .Normal)
        removeButton.setFontSize(min(25, scrollView.bounds.width * 0.03748))
        scrollView.addSubview(removeButton)
        
        helpButton.frame = CGRect(x: scrollView.bounds.width/4 + 20, y: removeButton.frame.maxY + 20, width: scrollView.bounds.width/2 - 40, height: 45)
        helpButton.setTitle("HELP", forState: .Normal)
        helpButton.setFontSize(min(25, scrollView.bounds.width * 0.03748))
        helpButton.addTarget(self, action: #selector(SettingsViewController.helpButtonPressed(_:)), forControlEvents: .TouchUpInside)
        scrollView.addSubview(helpButton)
        
        scrollView.contentSize = CGSize(width: view.bounds.width, height: helpButton.frame.maxY + 40)
        
        musicButton.selected = !settings.musicMuted
        soundButton.selected = !settings.soundMuted
        toggleButton(musicButton)
        toggleButton(soundButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func leftNavigationButtonTapped(button: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func soundButtonTapped(button : SVBorderedButton) {
        settings.soundMuted = !button.selected
        toggleButton(button)
    }
    
    func musicButtonTapped(button : SVBorderedButton) {
        settings.musicMuted = !button.selected
        toggleButton(button)
    }
    
    func helpButtonPressed(button : SVBorderedButton) {
        presentViewController(HelpViewController(), animated: true, completion: nil)
    }
    
    func themeChanged(segmentedControl : UISegmentedControl) {
        settings.theme = GameTheme(rawValue : segmentedControl.selectedSegmentIndex)!
        animateDuskView = true
        changeThemeAlpha()
    }
    
    private func toggleButton(button : SVBorderedButton) {
        button.selected = !button.selected
        if button.selected {
            button.setImage(UIImage(asset: .MuteIcon).imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        } else {
            button.setImage(UIImage(asset: .VolumeIcon).imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        }
    }
}
