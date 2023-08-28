//
//  Coordinator.swift
//  HelloGesture
//
//  Created by Perception on 28/08/2023.
//

import Foundation
import ARKit
import RealityKit

class Coordinator: NSObject, ARSessionDelegate{
    
    weak var view : ARView?
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer){
        
        guard let view = self.view else{return}
        
        let tapLocation = recognizer.location(in: view)
        
//        if let entity = view.entity(at: tapLocation) as? ModelEntity{
//
//            let material = SimpleMaterial(color: UIColor.random(), isMetallic: true)
//            entity.model?.materials = [material]
//        }
        
        
        // ADD Virtual Item on Tap gesture
       let results = view.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
        
        if let result = results.first{
            let anchor = ARAnchor(name: "Place Anchor", transform: result.worldTransform)
            view.session.add(anchor: anchor)
            
            let modelEntity = ModelEntity(mesh: MeshResource.generateBox(size: 0.3))
            modelEntity.model?.materials = [SimpleMaterial(color: .cyan, isMetallic: true)]
            modelEntity.generateCollisionShapes(recursive: true)
            
            let anchorEntity = AnchorEntity(anchor: anchor)
            anchorEntity.addChild(modelEntity)
            
            view.scene.addAnchor(anchorEntity)
            view.installGestures(.all, for: modelEntity)
            
        }
    }
    
}
