//
//  SettingsLauncher.swift
//  ARP
//
//  Created by MHspitta on 28/03/2019.
//  Copyright © 2019 Michael Hu. All rights reserved.
//

import Foundation
import UIKit

// Extra class to input all settings 
class Setting: NSObject {
    let name: String
    let imageName: String
    
    init(name: String, imageName:String) {
        self.name = name
        self.imageName = imageName
    }
}

class SettingsLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // Variables for settings
    let blackView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    let cellId = "cellId"
    let cellHeight: CGFloat = 50
    
    let settings: [Setting] = {
        return [Setting(name: "PH", imageName: "meter"), Setting(name: "Growth & Expected growth", imageName: "ruler"),
                Setting(name: "Yield & Expected yield", imageName: "percentage"), Setting(name: "Comments", imageName: "comment")]
    }()
    
    
    // Show options view function
    func showOptions() {
        
        // If window shared window opened
        if let window = UIApplication.shared.keyWindow {
            
            
            // Change the background color of the UIView
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            collectionView.backgroundColor = UIColor.white
            collectionView.roundCorners([.topLeft,.topRight], radius: 5)

            
            // Add extra views
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
            // Adjust height and size of added views
            let height: CGFloat = CGFloat(settings.count) * cellHeight + 50
            let y = window.frame.height - height
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            // Animation effect when views pop up
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                
                self.collectionView.frame = CGRect(x: 0, y: y,
                                                   width: self.collectionView.frame.width,
                                                   height: self.collectionView.frame.height)
            }, completion: nil)
        }
    }
    
    // Dismiss options view
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect (x: 0, y: window.frame.height,
                                                    width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        })
    }
    
    // Number of items in section of collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    // Path for all options
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingCell
        
        let setting = settings[indexPath.item]
        cell.setting = setting
        
        return cell
    }
    
    // Adjust size of collectionview
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    // Adjust size between cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // Select option in collectionview 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let setting = settings[indexPath.item]
        print(setting.name)
        handleDismiss()
        
        if setting.name == "PH" {
            ViewController().fetchPh()
            print("Yes yes yes")
        }
    }
    
    override init() {
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: cellId)
        
    }
}
