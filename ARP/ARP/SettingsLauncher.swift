//
//  SettingsLauncher.swift
//  ARP
//
//  Created by MHspitta on 28/03/2019.
//  Copyright © 2019 Michael Hu. All rights reserved.
//

import Foundation
import UIKit

class SettingsLauncher: NSObject {
    
    let blackView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    // Show options view
    func showOptions() {
        
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
            let height: CGFloat = 400
            let y = window.frame.height - height
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
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
    
    override init() {
        super.init()
    }
}
