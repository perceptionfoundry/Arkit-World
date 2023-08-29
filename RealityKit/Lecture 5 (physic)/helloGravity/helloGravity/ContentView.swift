//
//  ContentView.swift
//  helloGravity
//
//  Created by Perception on 29/08/2023.
//

import SwiftUI
import RealityKit
import ARKit
import Combine

struct ContentView : View {
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        arView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap)))
        let planeAnchor = AnchorEntity(plane: .horizontal)
        
        let plane  = ModelEntity(mesh: .generatePlane(width: 1, depth: 1), materials: [SimpleMaterial(color: .blue, isMetallic: true)])
        plane.physicsBody = PhysicsBodyComponent(massProperties: .default, material: .generate(), mode: .static)
        plane.generateCollisionShapes(recursive: true)

        planeAnchor.addChild(plane)
        arView.scene.anchors.append(planeAnchor)
        
        context.coordinator.view = arView
        arView.session.delegate = context.coordinator
        
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
}


class Coordinator : NSObject, ARSessionDelegate{
    
    weak var view :  ARView?
    var collisionSubscription = [Cancellable]()
    
    @objc func handleTap(_ recognizer : UITapGestureRecognizer){
        
        guard let view = self.view else{return}
        let tapLocation = recognizer.location(in: view)
        
        
        let results = view.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
        
        if let result = results.first{
            
            let anchorEntity = AnchorEntity(raycastResult: result)
            let box = ModelEntity(mesh: .generateBox(size: 0.3), materials: [SimpleMaterial(color: .green, isMetallic: true)])
            box.physicsBody = PhysicsBodyComponent(massProperties: .default, material: .generate(), mode: .dynamic)
            box.generateCollisionShapes(recursive: true)
            box.position = simd_make_float3(0, 0.7, 0)
            
                //COLLISION
            box.collision = CollisionComponent(shapes: [.generateBox(size: [0.2,0.2,0.2])], mode: .trigger, filter: .sensor)
            self.collisionSubscription.append(  view.scene.subscribe(to: CollisionEvents.Began.self) { event in
                box.model?.materials = [SimpleMaterial(color: .red, isMetallic: true)]
            })
            
            self.collisionSubscription.append(  view.scene.subscribe(to: CollisionEvents.Ended.self) { event in
                box.model?.materials = [SimpleMaterial(color: .green, isMetallic: true)]
            })
            
            
            anchorEntity.addChild(box)
            view.scene.anchors.append(anchorEntity)
        }
    }
    
}


#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
