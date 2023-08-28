//
//  ContentView.swift
//  HelloGesture
//
//  Created by Perception on 28/08/2023.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        arView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap)))
        
        context.coordinator.view  = arView
        arView.session.delegate = context.coordinator
        
        let anchor = AnchorEntity(plane: .horizontal)
        
        let box = ModelEntity(mesh: .generateBox(size: 0.3), materials: [SimpleMaterial(color: .purple, isMetallic: true)])
        box.generateCollisionShapes(recursive: true)
        anchor.addChild(box)
        
        arView.scene.anchors.append(anchor)
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
