//
//  ContentView.swift
//  HelloVideoAR
//
//  Created by Perception on 28/08/2023.
//

import SwiftUI
import RealityKit
import AVFoundation
struct ContentView : View {
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
       
        // ATTACH REAL DEVICE OTHERWISE ERROR POPS UP
        let anchor = AnchorEntity(plane: .horizontal)
        
        guard let url  = Bundle.main.url(forResource: "sample", withExtension: "mp4") else{
            fatalError("UNABLE TO LOAD VIDEO")
        }
        let player  = AVPlayer(url: url)
        let vdoMaterial = VideoMaterial(avPlayer: player)

        vdoMaterial.controller.audioInputMode = .spatial

        let modelEntity = ModelEntity(mesh:.generatePlane(width: 0.5, depth: 0.5),materials: [vdoMaterial])
        player.play()
        anchor.addChild(modelEntity)

//        arView.scene.addAnchor(anchor)
        
      
        
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
