//
//  ViewController.swift
//  ARKit-texture-tutorial
//
//  Created by Jaf Crisologo on 2019-12-19.
//  Copyright © 2019 Modium Design. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    /*
     Textures from:
     https://upload.wikimedia.org/wikipedia/commons/9/99/Map_of_the_full_sun.jpg
     http://paul-reed.co.uk/images/atlas1.jpg
     https://i.pinimg.com/originals/51/cc/08/51cc08225017dbbd0f3327df7bc49f48.png
    */
    
    @IBOutlet var sceneView: ARSCNView!
    
    // Make sure textures have the same name as the ones in the Assets folder!
    let textures = ["earth", "moon", "sun"]
    var currentIndex = 0
    var currentTexture = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // 1. Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // Initialize currentTexture to first item in textures
        currentTexture = textures[currentIndex]
        
        // Add sphere to scene
        sceneView.scene.rootNode.addChildNode(createSphere())
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

    // 2. Delete everything after MARK: - ARSCNViewDelegate

    // 3. Create a function that creates a sphere
    func createSphere() -> SCNNode {
        let sphere = SCNSphere(radius: 1)
        sphere.firstMaterial?.diffuse.contents = UIImage(named: currentTexture)
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.name = "sphere"
        sphereNode.position = SCNVector3(0, 0, -3)
        return sphereNode
    }
    
    // 4. Implement touchesBegan function
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        if touch.view == self.sceneView {
            let viewTouchLocation:CGPoint = touch.location(in: sceneView)
            
            guard let result = sceneView.hitTest(viewTouchLocation, options: nil).first else {
                return
            }
            
            if result.node.name == "sphere" {
                let node = result.node
                currentIndex = currentIndex == 0 ? 1 : currentIndex == 1 ? 2 : 0
                currentTexture = textures[currentIndex]
                node.geometry?.firstMaterial?.diffuse.contents = currentTexture
            }
        }
    }
}
