//
//  ARViewVC.swift
//  ArtWork AR
//
//  Created by Syed ShahRukh Haider on 06/11/2017.
//  Copyright © 2017 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import ARKit

// FOR GPS
import  CoreLocation


class ARViewVC: UIViewController,ARSCNViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var ARsceneview: ARSCNView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var PlaneStatus: UILabel!
    
    // ART Profile View (thumb up & thumb down)
    
    let artProfile = Bundle.main.loadNibNamed("ArtProfileView", owner: self, options: nil)?.first 
    
    // creating location Manager variable
    let locationManager = CLLocationManager()
    
  
    
    // variable which will store imagepicker selected image
    var selectedImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ARsceneview.delegate = self
        
        ARsceneview.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        
        // disable label & button
        actionButton.isHidden =  true
        PlaneStatus.isHidden = true
    
        
        let scene = SCNScene()
        
        self.ARsceneview.scene = scene
        
        
        // INTRODUCING TAP GESTURE
        let tapping = UITapGestureRecognizer(target: self, action: #selector(addArt))
        ARsceneview.addGestureRecognizer(tapping)
        
        
        // initialize location manager essential configuration
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
        
        // test current location coordinate
        print(locationManager.location?.coordinate.latitude, locationManager.location?.coordinate.longitude)

    }
    
    
    

    override func viewWillAppear(_ animated: Bool) {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        ARsceneview.session.run(configuration)
        
    }
  
    // PLANE RENDERING
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
        
            
          
            
            
            DispatchQueue.main.async {
            guard  anchor is ARPlaneAnchor else{
                return
            }
            self.actionButton.isHidden = false
            self.PlaneStatus.isHidden = false
            
                let plane = anchor as! ARPlaneAnchor
                
                let floor = SCNPlane(width: CGFloat(plane.extent.x), height: CGFloat(plane.extent.x))
                
                let floorNode = SCNNode(geometry: floor)
                
                floorNode.simdPosition = simd_float3(plane.center.x, 0, plane.center.z)
                
                floorNode.eulerAngles.x = -Float.pi/2
                
                floorNode.opacity = 0.25
                
                node.addChildNode(floorNode)
            
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            self.PlaneStatus.isHidden = true
        }
        
        }
        
    }
    

    
    
    @IBAction func addbutton(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        
        // Create ALERT VC

        let alertVC = UIAlertController(title: "Photo Source", message: "Choose a Source", preferredStyle: .actionSheet)
        
        // "PHOTO LIBRARY" OPTION

        alertVC.addAction(UIAlertAction(title: "PHOTO LIBRARY", style: .default, handler: { (action: UIAlertAction) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }))
        
        // "CAMERA" OPTION
        alertVC.addAction(UIAlertAction(title: "CAMERA", style: .default, handler: { (action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
            else{
                print("Camera not available")
                
            }
        }))
        // "CANCEL" OPTION
        alertVC.addAction(UIAlertAction(title: "CANCEL", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)

        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // storing IMAGE
        
        let chooseimage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        self.selectedImage = chooseimage
        
        
        
        // dismiss picker
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    // FUNCTION WILL HANDLE CANCEL OPERATION
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    // Rendering ArtWork
    @objc func addArt(recognizer: UITapGestureRecognizer){
        
        let choosenView = recognizer.view as! ARSCNView
        let location = recognizer.location(in: choosenView)
        
        print(locationManager.location?.coordinate)

            
            let HitResult = choosenView.hitTest(location, types: .existingPlane)
        
        if !HitResult.isEmpty && selectedImage != nil{
            
            let hitPt = HitResult.first
            let image = self.selectedImage!.cgImage
            let FramePlane = SCNPlane(width: 0.2, height: 0.2)
            
            FramePlane.firstMaterial?.diffuse.contents = UIImage(cgImage: image!)
            
            
            
            let frameNode = SCNNode(geometry: FramePlane)
            frameNode.position = SCNVector3(CGFloat((hitPt?.worldTransform.columns.3.x)!), CGFloat((hitPt?.worldTransform.columns.3.y)!), CGFloat((hitPt?.worldTransform.columns.3.z)!))
//            frameNode.eulerAngles.z = -Float.pi/2
            
        
            
            self.ARsceneview.scene.rootNode.addChildNode(frameNode)
            
        
            
            
        }
       

            
        }
        
        
    }

