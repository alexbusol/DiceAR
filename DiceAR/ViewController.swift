//
//  ViewController.swift
//  DiceAR
//
//  Created by Alex Busol on 7/13/18.
//  Copyright © 2018 Alex Busol. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        
        sceneView.autoenablesDefaultLighting = true
        // Create a new scene
        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
        
        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) { //recursively: includes all of the subtrees of the Dice
        diceNode.position = SCNVector3(x: 0, y: 0, z: -0.1)
        
        sceneView.scene.rootNode.addChildNode(diceNode)
        // Set the scene to the view
        sceneView.scene = diceScene
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}
