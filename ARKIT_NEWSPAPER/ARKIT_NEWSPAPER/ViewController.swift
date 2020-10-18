//
//  ViewController.swift
//  ARKIT_NEWSPAPER
//
//  Created by Syed ShahRukh Haider on 18/10/2020.
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
        
        
//                // Create a new scene
//                let scene = SCNScene(named: "art.scnassets/ship.scn")!
//        
//                // Set the scene to the view
//                sceneView.scene = scene
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        guard let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "NewsPaperImages", bundle: nil) else {
               // failed to read them – crash immediately!
               fatalError("Couldn't load tracking images.")
           }
            print("FOUND")
           configuration.trackingImages = trackingImages
           sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        // make sure this is an image anchor, otherwise bail out
        
        
        
    
        
        

        guard let imageAnchor = anchor as? ARImageAnchor else { return nil }

        // create a plane at the exact physical width and height of our reference image
        
        

        sceneView.scene.rootNode.enumerateChildNodes { (childNode, _) in
                   childNode.removeFromParentNode()
               }
        
        let imageTitle = (imageAnchor.referenceImage.name)!
        
        
        
        
        var videoNode = SKVideoNode()
        
        videoNode.removeFromParent()
        
        
        if imageTitle == "ik"{
            videoNode = SKVideoNode(fileNamed: "ik.mp4")
        }else if imageTitle == "fire"{
            videoNode = SKVideoNode(fileNamed: "fire.mp4")
        }else if imageTitle == "hawk"{
            videoNode = SKVideoNode(fileNamed: "hawk.mp4")
        }else if imageTitle == "nz"{
            videoNode = SKVideoNode(fileNamed: "nz.mp4")
        }else if imageTitle == "market"{
            videoNode = SKVideoNode(fileNamed: "market.mp4")
        }else if imageTitle == "mobile"{
            videoNode = SKVideoNode(fileNamed: "mobile.mp4")
        }else if imageTitle == "harrypotter"{
            videoNode = SKVideoNode(fileNamed: "harrypotter.mp4")

        }
        
        videoNode.play()
        
        let videoScene = SKScene(size: CGSize(width: 480, height: 360))
        
        videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
        
        videoNode.yScale = -1.0
        
        
        videoScene.addChild(videoNode)
        
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)

        // make the plane have a transparent blue color
        plane.firstMaterial?.diffuse.contents = videoScene

        // wrap the plane in a node and rotate it so it's facing us
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi / 2

        // now wrap that in another node and send it back
        let node = SCNNode()
        node.addChildNode(planeNode)
        return node
    }
}
