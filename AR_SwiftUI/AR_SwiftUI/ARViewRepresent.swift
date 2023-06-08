//
//  ARView.swift
//  AR_SwiftUI
//
//  Created by Perception on 31/05/2023.
//

import SwiftUI
import ARKit
import RealityKit
import FocusEntity

struct ARViewRepresent: UIViewRepresentable{
    let arView = ARView()
    
    @Binding var selectedItem : String
    
    func makeUIView(context: Context) -> ARView {
        
        let session = arView.session
        
        let config = ARWorldTrackingConfiguration()
        
        config.planeDetection = [.horizontal]
        
        session.run(config)
        
        let coachingOverlay = ARCoachingOverlayView()
        
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        coachingOverlay.session = session
        
        coachingOverlay.goal = .horizontalPlane
        
        arView.addSubview(coachingOverlay)
        
        
      
       
        
        #if DEBUG
        
//        arView.debugOptions = [.showFeaturePoints,.showAnchorOrigins, .showAnchorGeometry]
        
        #endif
        
        context.coordinator.view = arView
        
        session.delegate = context.coordinator
        

        

        
//        if selectedItem == "caffe"{
//            let caffe = try! Experience.loadCaffe()
//            arView.scene.anchors.append(caffe)
//        }else if selectedItem == "guitar"{
//            let guitar = try! Experience.loadGuitar()
//            arView.scene.anchors.removeAll()
//            arView.scene.anchors.append(guitar)
//        }else if selectedItem == "space"{
//            let space = try! Experience2.loadSpace()
//            arView.scene.anchors.removeAll()
//            arView.scene.anchors.append(space)
//
//        }
        let url = URL(string: "https://developer.apple.com/augmented-reality/quick-look/models/nike-air-force/sneaker_airforce.usdz")
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsUrl.appendingPathComponent(url!.lastPathComponent)
        let url_session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        let downloadTask = url_session.downloadTask(with: request, completionHandler: { (location:URL?, response:URLResponse?, error:Error?) -> Void in
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: destinationUrl.path) {
                try! fileManager.removeItem(atPath: destinationUrl.path)
            }
            try! fileManager.moveItem(atPath: location!.path, toPath: destinationUrl.path)
            DispatchQueue.main.async {
                do {
                    let object = try Entity.loadAnchor(contentsOf: destinationUrl) // It is work
                    let anchor = AnchorEntity(world: [0, 0, 0])
                    anchor.addChild(object)
                    self.arView.scene.addAnchor(anchor)
                }
                catch {
                    print("Fail load entity: \(error.localizedDescription)")
                }
            }
        })
        downloadTask.resume()

        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
//
//        if selectedItem == "caffe"{
//            let caffe = try! Experience.loadCaffe()
//            arView.scene.anchors.append(caffe)
//        }else if selectedItem == "guitar"{
//            let guitar = try! Experience.loadGuitar()
//            arView.scene.anchors.removeAll()
//            arView.scene.anchors.append(guitar)
//        }else if selectedItem == "space"{
//            let space = try! Experience2.loadSpace()
//            arView.scene.anchors.removeAll()
//            arView.scene.anchors.append(space)
//
//        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    
    class Coordinator: NSObject, ARSessionDelegate{
        
        weak var view : ARView?
        var focusEntity : FocusEntity?
        
        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            
            guard let view = self.view else{return}
            
            self.focusEntity = FocusEntity(on: view, style: .classic(color: .yellow))
        }
    }
    
}
/*
 func usdzNodeFrom(file: String, exten: String, internal_node: String) -> SCNNode? {
     let rootNode = SCNNode()
     let scale = 1

     guard let fileUrl = Bundle.main.url(forResource: file, withExtension: exten) else {
         fatalError()
     }
     
     let scene = try! SCNScene(url: fileUrl, options: [.checkConsistency: true])
     let node = scene.rootNode.childNode(withName: internal_node, recursively: true)!
     node.name = internal_node
     let height = node.boundingBox.max.y - node.boundingBox.min.y
     node.position = SCNVector3(0, 0, 0)
     tNode.scale = SCNVector3(scale, scale, scale)
     rootNode.addChildNode(tNode)
     return rootNode
 }
 
 
 
 
 let url = URL(string: "https://developer.apple.com/augmented-reality/quick-look/models/stratocaster/fender_stratocaster.usdz")
         let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
         let destination = documents.appendingPathComponent(url!.lastPathComponent)
         let urlSession = URLSession(configuration: .default,
                                       delegate: nil,
                                  delegateQueue: nil)

         var request = URLRequest(url: url!)
         request.httpMethod = "GET"

         let downloadTask = urlSession.downloadTask(with: request, completionHandler: { (location: URL?,
                                   response: URLResponse?,
                                      error: Error?) -> Void in

             let fileManager = FileManager.default

             if fileManager.fileExists(atPath: destination.path) {
                 try! fileManager.removeItem(atPath: destination.path)
             }
             try! fileManager.moveItem(atPath: location!.path,
                                       toPath: destination.path)

             DispatchQueue.main.async {
                 do {
                     let model = try Entity.load(contentsOf: destination)
                     let anchor = AnchorEntity(world: [0,-0.2,0])
                         anchor.addChild(model)
                     anchor.scale = [5,5,5]
                     self.arView.scene.addAnchor(anchor)

                     model.playAnimation(model.availableAnimations.first!.repeat())
                 } catch {
                     print("Fail loading entity.")
                 }
             }
         })
         downloadTask.resume()
 
 */
