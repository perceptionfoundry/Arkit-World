//
//  ARView.swift
//  AR_SwiftUI
//
//  Created by Perception on 31/05/2023.
//

import SwiftUI
import ARKit
import RealityKit
import FocusEntity

struct ARViewRepresent: UIViewRepresentable{
    let arView = ARView()
    
    func makeUIView(context: Context) -> ARView {
        
        let session = arView.session
        
        let config = ARWorldTrackingConfiguration()
        
        config.planeDetection = [.horizontal]
        
        session.run(config)
        
        let coachingOverlay = ARCoachingOverlayView()
        
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        coachingOverlay.session = session
        
        coachingOverlay.goal = .horizontalPlane
        
        arView.addSubview(coachingOverlay)
        
        
        #if DEBUG
        
        arView.debugOptions = [.showFeaturePoints,.showAnchorOrigins, .showAnchorGeometry]
        
        #endif
        
        context.coordinator.view = arView
        
        session.delegate = context.coordinator
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    
    class Coordinator: NSObject, ARSessionDelegate{
        
        weak var view : ARView?
        var focusEntity : FocusEntity?
        
        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            
            guard let view = self.view else{return}
            
            self.focusEntity = FocusEntity(on: view, style: .classic(color: .yellow))
        }
    }
    
}
