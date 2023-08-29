//
//  ContentView.swift
//  AR_Coaching_Template_App
//
//  Created by Perception on 29/08/2023.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

extension ARView: ARCoachingOverlayViewDelegate {
    func addCoaching(){
        
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.session = self.session
        
        self.addSubview(coachingOverlay)
    }
    
    private func addVirtualObj(){
        let box = ModelEntity(mesh: .generateBox(size: 0.3),materials: [SimpleMaterial(color: .green, isMetallic: true)])
        
        guard let anchor = self.scene.anchors.first(where: {$0.name == "Plane Anchor"}) else{
            return
        }
        anchor.addChild(box)
    }
    
    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        addVirtualObj()
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        let anchor = AnchorEntity(plane: .horizontal)
        anchor.name = "Plane Anchor"
        arView.scene.addAnchor(anchor)
        
        //ADD AR COACHING
        arView.addCoaching()
        
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
