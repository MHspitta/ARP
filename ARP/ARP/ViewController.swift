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

class ViewController: UIViewController, ARSCNViewDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // Variables
    var myDataCardLabel: SKLabelNode!
    var spriteKitScene = SKScene(fileNamed: "DataCard")
    var spriteKitMain: SKScene!
    var dataText: String = "lol"
    
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
    let uid = Auth.auth().currentUser?.uid
    var id: Int = 0

    var check_1: Int = 0
    var check_2: Int = 0
    
    var plantX: Plant!
    var phArray: [PH] = []
    var growthArray: [Growth] = []
    var yieldArray: [Yield] = []
    var commentsArray: [Comment] = []
    
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
        
        // Variables
        let newRef = ref.child("Plants").childByAutoId()
        let autoID = newRef.key
        GLobalId.id = autoID!
        
        // Send data to firebase
        newRef.setValue(["plantName" : "Bananaplant", "location" : "vak C, rij 4, bak 34", "plantID" : autoID])
        
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
    

    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        guard let imageAnchor = anchor as? ARImageAnchor else {
            return node
        }
        
        let referenceImage = imageAnchor.referenceImage
        
        if referenceImage.name == "QR_Code" {
            
            let planeNode = createDataCard(referenceImage: referenceImage)
            node.addChildNode(planeNode)
        }
        
        return node
    }
    
    func createDataCard(referenceImage: ARReferenceImage) -> SCNNode {
        
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
        
        return planeNode
    }
    
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

    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    
    }
    
    // Functions for SettingLauncher
    let settingsLauncher = SettingsLauncher()
    
    // Handle transparant background when option button clicked
    func handleMore() {
        resetDatacard()
        settingsLauncher.selectionDelegate = self
        settingsLauncher.showOptions()
        print("check1")
    }
    
    func resetDatacard() {
        self.sceneView.scene.rootNode.enumerateChildNodes { (existingNode, _) in
            existingNode.removeFromParentNode()
        }
    }
    
    // Firebase functions
    
    func uploadData() {

        let refAdd = ref.child("Plants").child(GLobalId.id)
        
        refAdd.child("phDatas").childByAutoId().setValue(["PH": "10", "optimumPH": "11", "time": "17:32, 12-01-2019"])
        refAdd.child("growthDatas").childByAutoId().setValue(["growth": "13cm", "normalGrowth" : "11cm", "time": "17:33, 12-01-2019"])
        refAdd.child("yieldDatas").childByAutoId().setValue(["yield": "60%","expectedYield": "73%", "time": "17:35, 12-01-2019"])
        refAdd.child("comments").childByAutoId().setValue(["comment": "good growth, but expected a higher yield", "time": "17:37, 12-01-2019"])
        
        check_1 = 1
    }
    
    func updateData() {
        let refAdd = ref.child("Plants").child(GLobalId.id)
        refAdd.child("phDatas").childByAutoId().setValue(["PH": "8", "optimumPH": "11", "time": "12:13, 19-01-2019"])
        refAdd.child("growthDatas").childByAutoId().setValue(["growth": "17cm", "normalGrowth" : "19cm", "time": "12:14, 19-01-2019"])
        refAdd.child("yieldDatas").childByAutoId().setValue(["yield": "82%","expectedYield": "80%", "time": "12:16, 19-01-2019"])
        refAdd.child("comments").childByAutoId().setValue(["comment": "Yield increased, but growth and PH dropped which is bad.", "time": "17:37, 19-01-2019"])
    }
    
    func fetchDefault() {
        let id = GLobalId.id

        refHandle = ref.child("Plants").child(id).observe(.value, with: { (snapshot) in
            
            if (snapshot.value as? [String:AnyObject]) != nil {
                
                let plant = Plant(snapshot: snapshot)
                
                self.plantX = plant
            }
        })
    }
    
    func updateCard() {
        for ph in phArray {
            self.dataText.append(ph.ph)
            self.dataText.append(ph.optimumPh)
            self.dataText.append(ph.time)
        }
    }
}

extension ViewController: OptionSelectionDelegate {
    func fetchPh() {
        refHandle = ref.child("Plants").child(GLobalId.id).child("phDatas").observe(.value, with: { (snapshot) in
            
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
        updateCard()
    }
    
    func fetchGrowth() {
        refHandle = ref.child("Plants").child(GLobalId.id).child("growthDatas").observe(.value, with: { (snapshot) in
            
            if (snapshot.value as? [String:AnyObject]) != nil {
                var growths: [Growth] = []
                
                for child in snapshot.children {
                    let growthId = Growth(snapshot: child as! DataSnapshot)
                    
                    growths.append(growthId)
                    
                }
                self.growthArray = growths
                print(self.growthArray)
            }
        })
    }
    
    func fetchYield() {
        refHandle = ref.child("Plants").child(GLobalId.id).child("yieldDatas").observe(.value, with: { (snapshot) in
            
            if (snapshot.value as? [String:AnyObject]) != nil {
                var yields: [Yield] = []
                
                for child in snapshot.children {
                    let yieldId = Yield(snapshot: child as! DataSnapshot)
                    
                    yields.append(yieldId)
                    
                }
                self.yieldArray = yields
                print(self.yieldArray)
            }
        })
    }
    
    func fetchComments(){
        refHandle = ref.child("Plants").child(GLobalId.id).child("comments").observe(.value, with: { (snapshot) in
            
            if (snapshot.value as? [String:AnyObject]) != nil {
                var comments: [Comment] = []
                
                for child in snapshot.children {
                    let commentId = Comment(snapshot: child as! DataSnapshot)
                    
                    comments.append(commentId)
                    
                }
                self.commentsArray = comments
                print(self.commentsArray)
            }
        })
    }
    
}
