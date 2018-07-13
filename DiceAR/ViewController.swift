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
    
    
    //recognize touches on the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView) //2d coordinate due to the screen being 2d.
            
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent) //searches for real world images corresponding to the place pressed on the screen
            
            if let hitResult = results.first {
                print(hitResult) //printing the coordinate data from the touch, as well as the real world position detected after the touch
                
                let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")
                
                if let diceNode = diceScene?.rootNode.childNode(withName: "Dice", recursively: true) {
                
                diceNode.position = SCNVector3(hitResult.worldTransform.columns.3.x,
                                               hitResult.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
                                               hitResult.worldTransform.columns.3.z) //need to change the y position a bit because it places the center of the object at the plane, making half of it below the plane.
                    
                sceneView.scene.rootNode.addChildNode(diceNode)
                    
                    let randomXNum = Float(arc4random_uniform(4) + 1) * (Float.pi/2) //creating rotation angles for x and z. rotation in Y axis is not necessary.
                    let randomZNum = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
                    
                    diceNode.runAction(SCNAction.rotateBy(x: CGFloat(randomXNum * 4), //increasing the number of rotations.
                                                          y: 0,
                                                          z: CGFloat(randomZNum * 4),
                                                          duration: 0.5))
                }
            }
            /*
            if !results.isEmpty {
                print("the plane was touched")
            } else {
                print("The touch did not connect ot the plane")
            }*/
            
            
        }
    }
    
    
    //Responsible for placing a transparent grid visualization onto a horizontal plane when it gets detected. it is important to rotate the plane 90 degrees counterclockwise because it is vertical by default. a call to SCNMAtrix4makeRotation accomplishes just that.
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
