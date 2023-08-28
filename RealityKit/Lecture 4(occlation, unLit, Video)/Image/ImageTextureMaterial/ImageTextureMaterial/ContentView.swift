//
//  ContentView.swift
//  ImageTextureMaterial
//
//  Created by Mohammad Azam on 5/20/22.
//

import SwiftUI
import RealityKit
import Combine

struct ContentView : View {
    var body: some View {
        return ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

class Coordinator {
    
    var arView: ARView?
    var cancellable: Cancellable?
    
    func setup() {
        
        guard let arView = arView else {
            return
        }

        let anchor = AnchorEntity(plane: .horizontal)
        let mesh = MeshResource.generateBox(size: 0.3)
        let box = ModelEntity(mesh: mesh)
        
        let texture = try? TextureResource.load(named: "purple_flower")
        
        if let texture = texture {
            var material = UnlitMaterial()
            material.color = .init(tint: .white, texture: .init(texture))
            box.model?.materials = [material]
        }
        
        anchor.addChild(box)
        arView.scene.addAnchor(anchor)
        
    }
    
}


struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        context.coordinator.arView = arView
        context.coordinator.setup()
        
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
