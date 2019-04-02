//
//  ViewController.swift
//  ARP
//
//  Created by MHspitta on 20/03/2019.
//  Copyright © 2019 Michael Hu. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController, ARSCNViewDelegate {

    // Variables
    var myDataCardLabel: SKLabelNode!
    var spriteKitScene = SKScene(fileNamed: "DataCard")
    var spriteKitMain: SKScene!
    var dataText: String = "I love bananas"
    
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
    let uid = Auth.auth().currentUser?.uid
    var plantID: String = ""
    var check_1: Int = 0
    var check_2: Int = 0
    
    var plantX: Plant!
    var phArray: [PH] = []
    
    @IBOutlet var sceneView: ARSCNView!
    @IBAction func selectOptions(_ sender: UIButton) {
        handleMore()
        
        if check_1 == 1 {
            fetchDefault()
        }
    }
    
    // Upload dummy variables button
    @IBAction func inputData(_ sender: UIButton) {
        
        if check_1 == 0 {
            uploadData()
        } else {
            updateData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.autoenablesDefaultLighting = true
        
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)!
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.detectionImages = referenceImages
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }

    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else {
            return
        }

        let referenceImage = imageAnchor.referenceImage
        
        if referenceImage.name == "QR_Code" {
            let plane = SCNPlane(width: referenceImage.physicalSize.width, height: referenceImage.physicalSize.height * 1.2)
            
            plane.cornerRadius = plane.width / 8
            
            plane.firstMaterial?.diffuse.contents = spriteKitScene
            plane.firstMaterial?.isDoubleSided = true
            plane.firstMaterial?.diffuse.contentsTransform =
                SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.position = SCNVector3Make(Float(referenceImage.physicalSize.width) - 0.04, Float(referenceImage.physicalSize.height) + 0.035, -0.05)
            
            planeNode.eulerAngles.x = -Float.pi / 2
            
            let textNode = SKLabelNode(text: dataText)
            textNode.fontName = "AvenirNext-Bold"
            textNode.horizontalAlignmentMode = .right
            textNode.fontSize = 15
            textNode.position = CGPoint(x: 8, y: 0)
        
            spriteKitScene!.addChild(textNode)
            node.addChildNode(planeNode)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    
    }
    
    // Functions for SettingLauncher
    
    let settingsLauncher = SettingsLauncher()
    
    // Handle transparant background when option button clicked
    func handleMore() {
        settingsLauncher.showOptions()
    }
    
    
    // Firebase functions
    
    func uploadData() {
        // Variables
        let newRef = ref.child("Plants").childByAutoId()
        let autoID = newRef.key
        plantID = autoID!
        let refAdd = ref.child("Plants").child(autoID!)
        
        // Send data to firebase
        newRef.setValue(["plantName" : "Bananaplant", "location" : "vak C, rij 4, bak 34", "plantID" : autoID])
        
        refAdd.child("phDatas").childByAutoId().setValue(["PH": "10", "optimumPH": "11", "time": "17:32, 12-01-2019"])
        refAdd.child("growthDatas").childByAutoId().setValue(["growth": "13cm", "normalGrowth" : "11cm", "time": "17:33, 12-01-2019"])
        refAdd.child("yieldDatas").childByAutoId().setValue(["yield": "60%","expectedYield": "73%", "time": "17:35, 12-01-2019"])
        refAdd.child("comments").childByAutoId().setValue(["comment": "good growth, but expected a higher yield", "time": "17:37, 12-01-2019"])
        
        check_1 = 1
    }
    
    func updateData() {
        let refAdd = ref.child("Plants").child(plantID)
        refAdd.child("phDatas").childByAutoId().setValue(["PH": "8", "optimumPH": "11", "time": "12:13, 19-01-2019"])
        refAdd.child("growthDatas").childByAutoId().setValue(["growth": "17cm", "normalGrowth" : "19cm", "time": "12:14, 19-01-2019"])
        refAdd.child("yieldDatas").childByAutoId().setValue(["yield": "82%","expectedYield": "80%", "time": "12:16, 19-01-2019"])
        refAdd.child("comments").childByAutoId().setValue(["comment": "Yield increased, but growth and PH dropped which is bad.", "time": "17:37, 19-01-2019"])
    }
    
    func fetchDefault() {
        let id = plantID
        
        print("1")
        print(id)
        refHandle = ref.child("Plants").child(id).observe(.value, with: { (snapshot) in
            
            if (snapshot.value as? [String:AnyObject]) != nil {
                
                let plant = Plant(snapshot: snapshot)
                
                self.plantX = plant
            }
        })
        if check_2 == 1 {
            updateCard()
        }
        
        self.check_2 = 1
    }
    
    func updateCard() {
        dataText = plantX.name!
    }
    
    func fetchPh() {
//        let id = plantID
        print("2", plantID)
        
        check_2 = 2
        
        if check_2 == 2 {
            refHandle = ref.child("Plants").child(plantID).child("phDatas").observe(.value, with: { (snapshot) in
                
                if (snapshot.value as? [String:AnyObject]) != nil {
                    var phs: [PH] = []
                    
                    for child in snapshot.children {
                        
                        let phId = PH(snapshot: child as! DataSnapshot)
                        
                        phs.append(phId)
                        
                    }
                    self.phArray = phs
                    print(self.phArray)
                }
            })
        }
    }
}
