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
    
    // Firebase variables
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
    let uid = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        ref = Database.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fillInputGrowth()
    }
    
    // Option to unwind to input menu
    @IBAction func unwindToInputMenu(segue: UIStoryboardSegue) {
    }
    
    // UIButton functions 
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindToMain", sender: self)
    }
    
    @IBAction func uploadButtonTapped(_ sender: UIButton) {
        uploadData()
    }
    
    func timeAndDate() -> String {
        // Variables
        let date = Date()
        let calendar = Calendar.current
        var components = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: date)
        components.day = 25
        components.month = 1
        components.year = 2011
        components.hour = 2
        components.minute = 15
        let currentDate = calendar.date(from: components)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let stringDate = dateFormatter.string(from: currentDate!)
        return stringDate
}
    
    // Function to set growth to 0
    func fillInputGrowth() {
        let measure = Measurement.measure
        
        if measure != "" {
            inputGrowth.text = String(Measurement.measure)
        }
    }
    
    func uploadData() {
        // Variables
        let time = timeAndDate()
        
        let newRef = ref.child("Plants").child(GLobalId.id)
        
        if inputPh.text != "" && inputGrowth.text != "" && inputYield.text != "" && inputComment.text != "" {
            
            newRef.child("phDatas").childByAutoId().setValue(["PH" : inputPh.text!, "optimumPH" : "11", "time" : time])
            newRef.child("growthDatas").childByAutoId().setValue(["growth" : inputGrowth.text!, "normalGrowth" : "12cm", "time" : time])
            newRef.child("yieldDatas").childByAutoId().setValue(["expectedYield" : "\(inputYield.text!)%", "yield" : "65%", "time" : time])
            newRef.child("comments").childByAutoId().setValue(["comment" : inputComment.text!, "time": time])
            
            createAlert(title: "Succeeded!", message: "All data is succesfully uploaded!")
            clearAll()
        } else {
            createAlert(title: "Attention!", message: "Please complete all empty fields to upload data!")
        }
    }
    
    func clearAll() {
        inputPh.text = ""
        inputGrowth.text = ""
        inputYield.text = ""
        inputComment.text = ""
    }
    
    // Function to alert user with popup
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message
            , preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default
            , handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
