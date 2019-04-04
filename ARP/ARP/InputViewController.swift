//
//  InputViewController.swift
//  ARP
//
//  Created by MHspitta on 04/04/2019.
//  Copyright © 2019 Michael Hu. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Firebase
import FirebaseDatabase

class InputViewController: UIViewController {

    @IBOutlet var inputPh: UITextField!
    @IBOutlet var inputGrowth: UITextField!
    @IBOutlet var inputYield: UITextField!
    
    @IBOutlet var inputComment: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwindToInputMenu(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindToInputMenu", sender: self)
    }
    
    @IBAction func uploadButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindToInputMenu", sender: self)
    }
    
}
