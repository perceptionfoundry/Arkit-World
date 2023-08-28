//
//  Coordinator.swift
//  helloImportModel
//
//  Created by Perception on 28/08/2023.
//

import Foundation
import RealityKit
import ARKit
import Combine

class Coordinator: NSObject,ARSessionDelegate{
    
    weak var view : ARView?
    var cancellable : AnyCancellable?
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer){
        
        guard let view = self.view else{return}
        
        let tapLocation = recognizer.location(in: view)
        
        let results = view.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
        
        if let result = results.first{
            
            let anchor  = AnchorEntity(raycastResult: result)
            // SYNC FUNCTION
//            guard let entity = try? ModelEntity.load(named: "CosmonautSuit_en")  else{
//                fatalError("MOdel not found")
//
//            }
//            anchor.addChild(entity)
            
          cancellable =  ModelEntity.loadAsync(named: "CosmonautSuit_en")
                .sink { loadCompletion in
                    if case let .failure(err) = loadCompletion{
                        print("\(err)")
                    }
                    self.cancellable?.cancel()
                } receiveValue: { entity in
                    anchor.addChild(entity)
                }

            
            view.scene.addAnchor(anchor)
        }
        
    }
}
