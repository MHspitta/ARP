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


class ViewController: UIViewController, ARSCNViewDelegate {

    var myDataCardLabel: SKLabelNode!
    var spriteKitScene = SKScene(fileNamed: "DataCard")
    var spriteKitMain: SKScene!
    
    
    @IBOutlet var sceneView: ARSCNView!
    @IBAction func selectOptions(_ sender: UIButton) {
        handleMore()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            
            let textNode = SKLabelNode(text: "I Love Bananas")
            textNode.fontName = "AvenirNext-Bold"
//            textNode.horizontalAlignmentMode = .left
            textNode.position = CGPoint(x: -30 , y: -100)
        
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
    
    
//    func testDataCard() {
//        print("1")
//        if let myDataCardLabel = SKScene(fileNamed: "DataCard")!.childNode(withName: "skDataLabel") as? SKLabelNode {
//            print("2")
//            myDataCardLabel.text = "yes yes yes"
//            print(myDataCardLabel.text!)
//
//            self.addChild(spriteKitScene)
//        }
//    }
}
