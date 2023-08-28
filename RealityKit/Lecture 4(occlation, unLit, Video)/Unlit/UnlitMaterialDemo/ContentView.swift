//
//  ContentView.swift
//  UnlitMaterialDemo
//
//  Created by Mohammad Azam on 5/19/22.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    var body: some View {
        return ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        let anchor = AnchorEntity(plane: .horizontal)
        
        let box = ModelEntity(mesh: MeshResource.generateBox(size: 0.3), materials: [UnlitMaterial(color: .red)])
        
        anchor.addChild(box)
        
        arView.scene.addAnchor(anchor)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
