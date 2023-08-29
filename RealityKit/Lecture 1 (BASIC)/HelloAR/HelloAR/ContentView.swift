//
//  ContentView.swift
//  HelloAR
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
   
        // DEFINE ANCHOR
        let anchor = AnchorEntity(plane: .horizontal)
        
        
        /*
                ********************* OBJECT ******************
        // DEFINE MATERIAL
        let material1 = SimpleMaterial(color: .green, isMetallic: true)
        let material2 = SimpleMaterial(color: .blue, isMetallic: true)
        let material3 = SimpleMaterial(color: .yellow, isMetallic: true)
        
        let box = ModelEntity(mesh: .generateBox(size: 0.3), materials: [material1])
        let sphere = ModelEntity(mesh: .generateSphere(radius: 0.3),materials: [material2])
        let plane = ModelEntity(mesh: .generatePlane(width: 0.5, depth: 0.3),materials: [material3])
        
        // POSiTION
        sphere.position = simd_make_float3(0,0.4,0)
        plane.position = simd_make_float3(0, 0.7, 0)
        
        // ADD TO ANCHOR
        anchor.addChild(box)
        anchor.addChild(sphere)
        anchor.addChild(plane)
        
         */
        
        //                 ********************* TEXT ******************

        let material_text = SimpleMaterial(color: .purple, isMetallic: true)
        
        let text = ModelEntity(mesh: .generateText("Perception Tec (Pvt) Ltd", extrusionDepth: 0.03, font: .systemFont(ofSize: 0.2), containerFrame: .zero, alignment: .center, lineBreakMode: .byCharWrapping))
        
        // ADD TO ANCHOR
        anchor.addChild(text)
        
        // ATTACH TO SCREEN
        arView.scene.anchors.append(anchor)
        
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
