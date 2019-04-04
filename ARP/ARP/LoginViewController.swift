//
//  LoginViewController.swift
//  ARP
//
//  Created by MHspitta on 28/03/2019.
//  Copyright © 2019 Michael Hu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {

    // Function to login
    @IBOutlet var emailText: UITextField!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var errorLabel: UILabel!

    @IBAction func login(_ sender: UIButton) {

        // Check input
        if emailText.text != "" && passwordText.text != "" {
            
            // Login
            Auth.auth().signIn(withEmail: emailText.text! , password: passwordText.text!) { (user, error) in
                
                // Check if input is correct else error message
                if user != nil {
                    self.performSegue(withIdentifier: "loginSuccesSegue", sender: self)
                } else {
                    if let myError = error?.localizedDescription {
                        self.errorLabel.text = myError
                    } else {
                        self.errorLabel.text = "ERROR, login failed!"
                    }
                }
                
            }
        }
    }
    
    //MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        errorLabel.text = ""
    }
}

// Extension to hide keyboard
extension UIViewController {
    
    // Function to hide keyboard
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self
            , action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
