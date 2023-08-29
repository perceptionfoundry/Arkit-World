//
//  ContentView.swift
//  Light
//
//  Created by Mohammad Azam on 5/22/22.
//

import SwiftUI
import RealityKit
import AVFoundation

struct ContentView : View {
    var body: some View {
        return ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

class Coordinator {
    
    var arView: ARView?
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        
        guard let arView = arView else {
            return
        }

        let location = recognizer.location(in: arView)
        let results = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal)
        
        if let result = results.first {
           
            let anchor = AnchorEntity(raycastResult: result)
            let lightEntity = DirectionalLight()
            lightEntity.light.color = .red
            lightEntity.light.intensity = 1000
            lightEntity.light.isRealWorldProxy = true
            lightEntity.shadow?.maximumDistance = 2
            lightEntity.shadow?.depthBias = 5
          
            anchor.addChild(lightEntity)
            arView.scene.addAnchor(anchor)
        }
    }
    
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        arView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap)))
        arView.scene.addAnchor(try! MyScene.loadLightScene())
        context.coordinator.arView = arView
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
