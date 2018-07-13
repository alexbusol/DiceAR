//
//  ViewController.swift
//  DiceAR
//
//  Created by Alex Busol on 7/13/18.
//  Copyright © 2018 Alex Busol. All rights reserved.
//  Learning AR Kit. 1st project

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
        //sceneView.showsStatistics = true
        /*
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        */
        
        
        //let ARCube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01) //chamfer radius - round the corners. THE UNITS ARE IN METERS.
        
        let ARSphere = SCNSphere(radius: 0.2)
        //giving the cube some color
//        let cubeMaterial = SCNMaterial()
//        cubeMaterial.diffuse.contents = UIColor.red
       
        
        let sphereMaterial = SCNMaterial()
        sphereMaterial.diffuse.contents = UIImage(named: "art.scnassets/2k_moon.jpg") //will add a free moon texture downloaded from.
        
        ARSphere.materials = [sphereMaterial] //you can assign many different materials to the same objects.
        
        let node = SCNNode() //Scene nodes: points in 3d space. You can give it a position and an object that it should display at that space.
        node.position = SCNVector3(x: 0, y: 0.1, z: -0.5)
        node.geometry = ARSphere  //placing the cube at the node's position.
        
        //now add the node into the scieneView
        sceneView.scene.rootNode.addChildNode(node)
        sceneView.autoenablesDefaultLighting = true //adds basic light to the scene to make it look more 3D and realistic.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        if ARWorldTrackingConfiguration.isSupported {
            
        
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration() //enables world tracking functionality on the device.
        //ARSessionConfiguration (depreciated in IOS11. use the one below). can be used instead on devices before A9 chip. The image will move with the device, which is quite sub-optimal and breakes the immersion.

        // Run the view's session
        sceneView.session.run(configuration)
        } else {
            let configuration = AROrientationTrackingConfiguration() //ARSessionConfiguration depreciated in IOS11 !!
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
}
