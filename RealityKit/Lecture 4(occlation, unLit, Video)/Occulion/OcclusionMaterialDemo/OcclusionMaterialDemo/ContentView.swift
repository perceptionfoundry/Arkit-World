//
//  ContentView.swift
//  OcclusionMaterialDemo
//
//  Created by Mohammad Azam on 5/19/22.
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
    var cancellable: AnyCancellable?
    
    func setup() {
        
        guard let arView = arView else {
            return
        }
        
        let anchor = AnchorEntity(plane: .horizontal)
        
        let box = ModelEntity(mesh: MeshResource.generateBox(size: 0.3), materials: [OcclusionMaterial()])
        box.generateCollisionShapes(recursive: true)
        arView.installGestures(.all, for: box)
        
        cancellable = ModelEntity.loadAsync(named: "toy_robot_vintage").sink { [weak self] completion in
            
            if case let .failure(error) = completion {
                fatalError("Unable to load model \(error)")
            }
            
            self?.cancellable?.cancel()
            
        } receiveValue: { entity in
            anchor.addChild(entity)
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
