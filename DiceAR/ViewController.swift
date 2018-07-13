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
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints] //shows the surface points as the phone is looking for a horizontal surface
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
        configuration.planeDetection = .horizontal //enabling horizontal plane detection
        

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) { //when a new horizontal plane is detected. ARAnchor - real world position in the horizontal plane.
        if anchor is ARPlaneAnchor {
            print("Plane detected")
            let planeAnchor = anchor as! ARPlaneAnchor //change the anchor type
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z)) //dont use y here
            
            let planeNode = SCNNode()
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z) //y is 0 becaue we dont want the node to be above the detected plane
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0) //will need to rotate the plane because it's horizontal by default. float.pi/2 = 90 degrees rotation counterclockwise. add minus to make it clockwise. 1 in the x means that we are rotating it around the x axis.
            
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            
            plane.materials = [gridMaterial]
            planeNode.geometry = plane
            
            node.addChildNode(planeNode)
        } else {
            return
        }
    }
}
