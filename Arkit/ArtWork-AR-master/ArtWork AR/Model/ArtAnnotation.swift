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

class ArtAnnotation: LocationNode{
    
    
    var image : UIImage?
    var AnnotationNode : SCNNode
    
    init(location : CLLocation?, Image: UIImage){
        
        self.AnnotationNode =  SCNNode()
        self.image = Image

        super.init(location: location)

        self.initializeUI()
    }
    
 
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    private func initializeUI(){

        // Pane

        
        print(globalSetting.globalWidth)
        print(globalSetting.globalheight)
        let panePlane = SCNPlane(width: CGFloat(globalSetting.globalWidth), height: CGFloat(globalSetting.globalheight))
        panePlane.firstMaterial?.diffuse.contents = UIImage(named: "pane.png")
        panePlane.name =  "Pane"
        let paneNode = SCNNode(geometry: panePlane)
//        paneNode.scale = SCNVector3(0.1,0.1,0.1)
        
        // IMAGE
        
        let arImage = image?.cgImage

        let imagePlane = SCNPlane(width: (panePlane.width - 0.3), height: (panePlane.height - 0.3))
        imagePlane.firstMaterial?.diffuse.contents = UIImage(cgImage: arImage!)
        imagePlane.name = "IMAGE"
        let imageNode = SCNNode(geometry: imagePlane)
        
    paneNode.addChildNode(imageNode)
       
        
       self.AnnotationNode.scale = SCNVector3(2,2,2)
//        self.AnnotationNode.position = SCNVector3(0, 0,  (AnnotationNode.worldPosition.z - 1) )
        
    
        self.AnnotationNode.addChildNode(paneNode)
        

   // BILLBOARD VIEW for all 
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        constraints = [billboardConstraint]
        
        makepaneAPI().makePane()

        self.addChildNode(self.AnnotationNode)
    }
    
    
    
}
