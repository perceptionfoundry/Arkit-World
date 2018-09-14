//
//  placeAnnotation.swift
//  corelocationAR
//
//  Created by Syed ShahRukh Haider on 13/11/2017.
//  Copyright © 2017 Syed ShahRukh Haider. All rights reserved.
//

import Foundation
import ARCL
import CoreLocation
import SceneKit

class PaneAnnotation: LocationNode{
    
    
    var AnnotationNode : SCNNode
    
    let panePlane = SCNPlane(width: CGFloat(globalSetting.globalWidth), height: CGFloat(globalSetting.globalheight))
    let addPicNode : SCNNode
    
   init(Clocation : CLLocation?){
        
        self.AnnotationNode =  SCNNode()
        self.addPicNode = SCNNode()
    super.init(location: Clocation)
        
        self.initializeUI()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func initializeUI(){
        
        // Pane
        
        panePlane.firstMaterial?.diffuse.contents = UIImage(named: "pane.png")
        panePlane.name =  "Frame"
        let paneNode = SCNNode(geometry: panePlane)
        paneNode.scale = SCNVector3(0.1,0.1,0.1)
        
   
        
        //       self.AnnotationNode.scale = SCNVector3(2,2,2)
        //        self.AnnotationNode.position = SCNVector3(0, 0,  (AnnotationNode.worldPosition.z - 1) )
        
        
        self.AnnotationNode.addChildNode(paneNode)

        
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        constraints = [billboardConstraint]
        
        
        self.addChildNode(self.AnnotationNode)
        
    }
    
    
    
//    // add image to frame
//     func addImage(image: UIImage){
//        
//        let arImage = image.cgImage
//        
//        let imagePlane = SCNPlane(width: (panePlane.width - 0.3), height: (panePlane.height - 0.3))
//        imagePlane.firstMaterial?.diffuse.contents = UIImage(cgImage: arImage!)
//        imagePlane.name = "IMAGE"
//        let imageNode = SCNNode(geometry: imagePlane)
//        
//        
//        addPicNode.addChildNode(imageNode)
//        
//        
//    }
    
    
}

