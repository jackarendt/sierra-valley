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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationTitle = "SETTINGS"
        leftNavigationButton.setImage(UIImage(asset: .CloseButton), forState: .Normal)
        // Do any additional setup after loading the view.
        
        let _musicLabel = UILabel(frame: CGRect(x: 20, y: contentView.frame.height/4 + 20, width: contentView.frame.width/2 - 80, height: 35))
        _musicLabel.text = "MUSIC"
        _musicLabel.font = UIFont.svHeavyFont(30)
        _musicLabel.textColor = UIColor.whiteColor()
        contentView.addSubview(_musicLabel)
        
        musicButton.frame = CGRect(x: contentView.frame.width/2 - 75, y: _musicLabel.frame.origin.y, width: 55, height: 35)
        musicButton.setImage(UIImage(asset: .VolumeIcon), forState: .Normal)
        musicButton.imageEdgeInsets = UIEdgeInsets(top: 3, left: 10, bottom: 3, right: 10)
        musicButton.addTarget(self, action: "musicButtonTapped:", forControlEvents: .TouchUpInside)
        contentView.addSubview(musicButton)
        
        let _soundLabel = UILabel(frame: CGRect(x: contentView.bounds.width/2 + 20, y: contentView.frame.height/4 + 20, width: contentView.frame.width/2 - 80, height: 35))
        _soundLabel.text = "SOUND"
        _soundLabel.font = UIFont.svHeavyFont(30)
        _soundLabel.textColor = UIColor.whiteColor()
        contentView.addSubview(_soundLabel)
        
        soundButton.frame = CGRect(x: contentView.frame.width - 75, y: _soundLabel.frame.origin.y, width: 55, height: 35)
        soundButton.setImage(UIImage(asset: .VolumeIcon), forState: .Normal)
        soundButton.imageEdgeInsets = UIEdgeInsets(top: 3, left: 10, bottom: 3, right: 10)
        soundButton.addTarget(self, action: "soundButtonTapped:", forControlEvents: .TouchUpInside)
        contentView.addSubview(soundButton)
        
        restoreButton.frame = CGRect(x: 20, y: contentView.bounds.height/2 + 20, width: contentView.bounds.width/2 - 40, height: 45)
        restoreButton.setTitle("RESTORE PURCHASES", forState: .Normal)
        restoreButton.setFontSize(min(25, contentView.bounds.width * 0.03748))
        contentView.addSubview(restoreButton)
        
        removeButton.frame = CGRect(x: contentView.bounds.width/2 + 20, y: contentView.bounds.height/2 + 20, width: contentView.bounds.width/2 - 40, height: 45)
        removeButton.setTitle("REMOVE ADS", forState: .Normal)
        removeButton.setFontSize(min(25, contentView.bounds.width * 0.03748))
        contentView.addSubview(removeButton)
        
        helpButton.frame = CGRect(x: contentView.bounds.width/4 + 20, y: contentView.bounds.height - 75, width: contentView.bounds.width/2 - 40, height: 45)
        helpButton.setTitle("HELP", forState: .Normal)
        helpButton.setFontSize(min(25, contentView.bounds.width * 0.03748))
        helpButton.addTarget(self, action: "helpButtonPressed:", forControlEvents: .TouchUpInside)
        contentView.addSubview(helpButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func leftNavigationButtonTapped(button: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func soundButtonTapped(button : SVBorderedButton) {
        toggleButton(button)
    }
    
    func musicButtonTapped(button : SVBorderedButton) {
        toggleButton(button)
    }
    
    func helpButtonPressed(button : SVBorderedButton) {
        presentViewController(HelpViewController(), animated: true, completion: nil)
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
