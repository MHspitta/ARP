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

class InputViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,
UIImagePickerControllerDelegate {

    // IB outlets
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var inputGrowth: UITextField!
    @IBOutlet var inputYield: UITextField!
    @IBOutlet var inputComment: UITextField!
    
    // Firebase variables
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
    let uid = Auth.auth().currentUser?.uid
    
    // Variables
    let phValues = ["1", "2", "3", "4", "5", "6", "7"
        , "8", "9", "10", "11", "12", "13", "14"]
    
    var phValue: String!
    
    // Function to override view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        ref = Database.database().reference()
        pickerView.dataSource = self
        pickerView.delegate = self
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
    
    // Functions for pickerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int
        , forComponent component: Int) -> String? {
        return phValues[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return phValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int
        , inComponent component: Int) {
        phValue = phValues[row]
    }

    // Other functions
    
    // Function for time and date
    func timeAndDate() -> String {
        // Variables
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy, HH:mm"
        let stringDate = dateFormatter.string(from: Date())
        
        return stringDate
}
    
    // Function to set growth to 0
    func fillInputGrowth() {
        let measure = Measurement.measure
        
        if measure != "" {
            inputGrowth.text = String(Measurement.measure)
        }
    }
    
    // Function to upload all data to Firebase
    func uploadData() {
        // Variables
        let time = timeAndDate()
        
        let newRef = ref.child("Plants").child(GLobalId.id)
        
        if inputGrowth.text != "" && inputYield.text != "" && inputComment.text != "" {
            
            newRef.child("phDatas").childByAutoId().setValue(["PH" : phValue, "optimumPH" : "9", "time" : time])
            newRef.child("growthDatas").childByAutoId().setValue(["growth" : inputGrowth.text!, "normalGrowth" : "25cm", "time" : time])
            newRef.child("yieldDatas").childByAutoId().setValue(["expectedYield" : "\(inputYield.text!)%", "yield" : "80%", "time" : time])
            newRef.child("comments").childByAutoId().setValue(["comment" : inputComment.text!, "time": time])
            
            createAlert(title: "Succeeded!", message: "All data is succesfully uploaded!")
            clearAll()
        } else {
            createAlert(title: "Attention!", message: "Please complete all empty fields to upload data!")
        }
    }
    
    // Function to clear all input fields
    func clearAll() {
        inputGrowth.text = ""
        inputYield.text = ""
        inputComment.text = ""
    }
    
    // Function to alert user with popup when fields are empty
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
