//
//  ChangeCarViewController.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/23/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import UIKit

/// Allows the user to change what car they are driving
class ChangeCarViewController: SVBaseViewController {

    override var name: String {
        get { return "Change Car" } set { }
    }
    
    /// Starts at random as the first car
    var carName : String = "RANDOM" {
        didSet {
            nameLabel.text = carName.uppercaseString
        }
    }
    
    /// The name of the car being displayed
    private let nameLabel = UILabel()
    
    /// The number of the car in order
    private let carNumberLabel = UILabel()
    
    /// Allows the user to drive or to buy the car
    private let actionButton = SVBorderedButton()
    
    /// Collectionview to show all the different cars
    private var collectionView : UICollectionView!
    
    /// Spacing between the collection view cells
    private var spacing : CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationTitle = "CHANGE CAR"
        leftNavigationButton.setImage(UIImage(asset: .CloseButton), forState: .Normal)
        
        nameLabel.frame = CGRect(x: 20, y: navigationTitleLabel.frame.maxY + 10, width: view.bounds.width - 40, height: 30)
        nameLabel.textAlignment = .Center
        nameLabel.textColor = SVColor.lightColor()
        nameLabel.font = UIFont.svHeavyFont(28)
        nameLabel.text = carName
        contentView.addSubview(nameLabel)
        
        actionButton.frame = CGRect(x: view.bounds.width/4, y: view.bounds.height - 60, width: view.bounds.width/2, height: 45)
        actionButton.setTitle("DRIVE", forState: .Normal)
        actionButton.setFontSize(min(25, view.bounds.width * 0.03748))
        actionButton.addTarget(self, action: #selector(actionButtonTapped), forControlEvents: .TouchUpInside)
        contentView.addSubview(actionButton)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: nameLabel.frame.maxY + 30, width: contentView.frame.width, height: actionButton.frame.minY - nameLabel.frame.maxY - 50), collectionViewLayout: layout)
        collectionView.registerClass(ChangeCarCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.pagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        contentView.addSubview(collectionView)
        
        carNumberLabel.frame = CGRect(x: nameLabel.frame.minX, y: nameLabel.frame.maxY + 5, width: nameLabel.frame.width, height: 20)
        carNumberLabel.text = "1/25"
        carNumberLabel.font = UIFont.svHeavyFont(17)
        carNumberLabel.textAlignment = .Center
        carNumberLabel.textColor = SVColor.lightColor()
        contentView.addSubview(carNumberLabel)
    }
    
    override func leftNavigationButtonTapped(button: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func actionButtonTapped() {
        dismissViewControllerAnimated(true, completion: nil) // TODO: fix for IAP
    }
}

extension ChangeCarViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ChangeCarCollectionViewCell
        if indexPath.row == 0 {
            cell.carImage = UIImage(asset: .Random)
        } else {
            cell.carImage = UIImage(car: .SierraTurboLarge)
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - spacing, height: collectionView.frame.height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: spacing/2, height: collectionView.frame.height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: spacing/2, height: collectionView.frame.height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return spacing
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if let indexPath = collectionView.indexPathsForVisibleItems().first {
            carNumberLabel.text = "\(indexPath.row + 1)/25"
            if indexPath.row != 0 {
                nameLabel.text = "SIERRA TURBO"
            } else {
                nameLabel.text = "RANDOM"
            }
        }
    }
}
