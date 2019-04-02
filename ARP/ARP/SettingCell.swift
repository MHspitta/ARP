//
//  SettingCell.swift
//  ARP
//
//  Created by MHspitta on 29/03/2019.
//  Copyright © 2019 Michael Hu. All rights reserved.
//

import Foundation
import UIKit

// Class to set the settings of content of collection cell
class SettingCell: BaseCell {
    
    // Change color when click
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.darkGray : UIColor.white
            nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            iconImageView.tintColor = isHighlighted ? UIColor.white : UIColor.darkGray
            
        }
    }
    
    // Set the icon and label of options
    var setting: Setting? {
        didSet {
            nameLabel.text = setting?.name
            
            if let imageName = setting?.imageName {
                iconImageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
                iconImageView.tintColor = UIColor.darkGray
            }
        }
    }
    
    // Variables
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "PH"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let iconImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named:"meter")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // Adjust setupviews
    override func setupViews() {
        super.setupViews()
        
        addSubview(nameLabel)
        addSubview(iconImageView)
        
        // Constraints for labels and images
        addConstraintsWithFormat("H:|-8-[v0(30)]-8-[v1]|", views: iconImageView, nameLabel)
        addConstraintsWithFormat("V:|[v0]|", views: nameLabel)
        addConstraintsWithFormat("V:[v0(30)]", views: iconImageView)
        
        addConstraints([NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)])
    }
}
