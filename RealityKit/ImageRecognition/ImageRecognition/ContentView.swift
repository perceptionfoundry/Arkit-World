//
//  ContentView.swift
//  ImageRecognition
//
//  Created by Mohammad Azam on 5/17/22.
//

import SwiftUI
import RealityKit
import Combine
import AVFoundation

struct ContentView : View {
    var body: some View {
        return ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

class Coordinator {
    
    var arView: ARView?
    var cancellable: AnyCancellable?
    
    func setupUI() {
       
        // load the video
        guard let videoURL = Bundle.main.url(forResource: "power-puff-girls", withExtension: "mp4") else {
            fatalError("Unable to load the video!")
        }
        
        let player = AVPlayer(url: videoURL)
        let videoMaterial = VideoMaterial(avPlayer: player)
        
        let anchor = AnchorEntity(.image(group: "AR Resources", name: "power-puff"))
        let plane = ModelEntity(mesh: MeshResource.generatePlane(width: 0.5, depth: 0.5), materials: [videoMaterial])
        
        plane.orientation = simd_quatf(angle: .pi/2, axis: [1,0,0])
        anchor.addChild(plane)
        arView?.scene.addAnchor(anchor)
        player.play()
        
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
    
        context.coordinator.arView = arView
        context.coordinator.setupUI()
        
        return arView
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
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
