//
//  ChangeCarCollectionViewCell.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 4/13/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import UIKit

class ChangeCarCollectionViewCell: UICollectionViewCell {
    
    var carImage : UIImage? {
        didSet {
            carImageView.image = carImage
        }
    }
    
    private let carImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let yOff = 0.1764 * frame.height
        carImageView.frame = CGRect(x: 30, y: yOff, width: frame.width - 60, height: frame.height - 2 * yOff)
        carImageView.contentMode = .ScaleAspectFit
        addSubview(carImageView)
    }
}
