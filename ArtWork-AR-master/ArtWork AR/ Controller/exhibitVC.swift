//
//  exhibitVC.swift
//  ArtWork AR
//
//  Created by Syed ShahRukh Haider on 17/11/2017.
//  Copyright © 2017 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CircleMenu
import ARKit

import CoreLocation
import MapKit
import ARCL

class exhibitVC: UIViewController, CLLocationManagerDelegate,CircleMenuDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    // Art Profile View (Thumb UP & Thumb Down)
    @IBOutlet weak var artView: UIView!
    
    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var InfoLabel: UILabel!
   
    // Creating ARCL variable
    @IBOutlet weak var addButton: CircleMenu!
    let ARViewLocationView = SceneLocationView()

    // Creating CoreLocation Manager
    let locationManager = CLLocationManager()
    
    // Creating ImagePicker Variable
    let imagepickerVC = UIImagePickerController()
    
    // ART PROFILE SUBVIEW
    
    var profileView : ArtProfileView!
    
    // Selected IMAGE
    var selectedImage : UIImage?
    
    
    // Selected Button
    var selectedButton = 0
    var currentPtX = 0
    
   
    // Tap Count
    var tapCount = 0

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addButton.isHidden = true
        // CircleMenu Delegate
        addButton.delegate = self

        // Corelocation configuration
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        
        // Imagepicker Delegate & Variable
        imagepickerVC.delegate = self
        
        // ArtProfileView Initialize
        if let artProfile = Bundle.main.loadNibNamed("ArtProfileView", owner: self, options: nil)?.first as? ArtProfileView  {
            
            
            
                profileView = artProfile
            profileView.isHidden = true
            
        }
        
        
        
        
        // Start AR + corelocation element
        ARViewLocationView.run()
        
        // Add components to ARViewLocationView
        ARViewLocationView.addSubview(labelView)
        ARViewLocationView.addSubview(addButton)
        view.addSubview(ARViewLocationView)
        
        
        

        // Single Tap to make ADD BUTTON to appear
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        
        ARViewLocationView.addGestureRecognizer(singleTap)
        
        
        // Pinch to Resize AR-object
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinched))
        ARViewLocationView.addGestureRecognizer(pinch)
        
        
        // Rotate to Resize AR-object
        let rotate = UIPanGestureRecognizer(target: self, action: #selector(rotateIt))
        ARViewLocationView.addGestureRecognizer(rotate)
        
        // set_settings(default_radius,default_pane_size,distance_unit,username,token)
        
        guard let location = locationManager.location else{return}
        
 
        
        Alamofire.request("https://exhibit-irl.com/api.php/?func=set_settings&default_radius=\(globalSetting.globalRadius)&default_pane_size=\(globalSetting.altitude)&distance_unit=\(globalSetting.GlobalUnit)&username=\(globalSetting.userName)&token=\(globalSetting.tokenID)", method: .post, parameters: nil)
            .validate(contentType: ["application/json"])
            .responseJSON { (response:DataResponse<Any>) in
                
                print(response)
                
                let json = JSON(response.value)
                
                
                // check output
                print(json)
                
        }
        
        
        findArt()
    
    }

    // creating LayoutSubview
    
    override func viewDidLayoutSubviews() {
        // setting AR VIEW size w.r.t scene size
        
        ARViewLocationView.frame = view.bounds
        
        ARViewLocationView.addSubview(profileView)
        let centre =  UIApplication.shared.keyWindow!.center
        self.profileView.center = CGPoint(x: centre.x, y: centre.y+100)
        
        
    }
    
    
  // TAPPED FUNCTION
    @objc func tapped(recognizer : UITapGestureRecognizer){
    
        
        print(tapCount)
        
        if tapCount == 0 {
            
            if recognizer.view == ARViewLocationView{
                
                let hitView = ARViewLocationView
                let hitLocation = recognizer.location(in: hitView)
                
                let hitTest = hitView.hitTest(hitLocation, options: [:])
                
                
                
            // ART PROFILE enable
                if !hitTest.isEmpty{
                    
                    let hitResult = hitTest.first!
                    
                    
                    // Frame is the  HITRESULT
                    if hitResult.node.geometry?.name == "IMAGE"{
                    
                        
                        DispatchQueue.main.async {
                        self.profileView.isHidden = false
                            
                            self.profileView.thumbUpButton.addTarget(self, action: #selector(self.ThumbUpAction), for: .touchUpInside)
                            
                            
                             self.profileView.thumbDownButton.addTarget(self, action: #selector(self.ThumbDownAction), for: .touchUpInside)
                            
                            
                    }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                            self.profileView.isHidden = true
                        })
                    
                  
                    }
                        }
            
            // IF NO Hit-Test (To enable to ADD BUTTON)
                else{
            
            tapCount = 1
            DispatchQueue.main.async {
                self.addButton.isHidden = false

            }
        
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.addButton.isHidden = true
            }
                }
            }
        }
            
            // *************** ADD IMAGE TO EMPTY FRAME ******************
        else if tapCount == 2{

            if recognizer.view == ARViewLocationView{

                let hitView = ARViewLocationView
                let hitLocation = recognizer.location(in: hitView)

                let hitTest = hitView.hitTest(hitLocation, options: [:])

                if !hitTest.isEmpty{

                    let hitResult = hitTest.first!


                    // Frame is the  HITRESULT
                    if hitResult.node.geometry?.name == "Frame"{
                        let node = hitResult.node


                        
                        if selectedImage == nil{
                            // Create ALERT VC
                            
                            let alertVC = UIAlertController(title: "Photo Source", message: "Choose a Source", preferredStyle: .actionSheet)
                            
                            // "PHOTO LIBRARY" OPTION
                            
                            alertVC.addAction(UIAlertAction(title: "PHOTO LIBRARY", style: .default, handler: { (action: UIAlertAction) in
                                self.imagepickerVC.sourceType = .photoLibrary
                                self.present(self.imagepickerVC, animated: true, completion: nil)
                            }))
                            
                            // "CAMERA" OPTION
                            alertVC.addAction(UIAlertAction(title: "CAMERA", style: .default, handler: { (action: UIAlertAction) in
                                if UIImagePickerController.isSourceTypeAvailable(.camera){
                                    
                                    self.imagepickerVC.sourceType = .camera
                                    self.present(self.imagepickerVC, animated: true, completion: nil)
                                }
                                else{
                                    print("Camera not available")
                                    
                                }
                            }))
                            // "CANCEL" OPTION
                            alertVC.addAction(UIAlertAction(title: "CANCEL", style: .default, handler: nil))
                            self.present(alertVC, animated: true, completion: nil)
                        }
                            
                            
                            
                        else{
                        DispatchQueue.main.async {
                            print(hitResult.node.geometry!)
                            let arImage = self.selectedImage?.cgImage!
                            
                            let imagePlane = SCNPlane(width: (2.7), height: (1.7))
                            imagePlane.firstMaterial?.diffuse.contents = UIImage(cgImage: arImage!)
                            imagePlane.name = "IMAGE"
                            let imageNode = SCNNode(geometry: imagePlane)
                            
                            
                            hitResult.node.addChildNode(imageNode)
                            
                            self.InfoLabel.text = ("CHOOSE WHERE YOU WANT TO ADD ART")
//                            self.InfoLabel.textColor = UIColor.white
                            self.selectedButton = 0
                            self.selectedImage = nil
                            self.tapCount = 0
                            }
                            
                        }
                        
                    }
                 

                }

            }


        }
            
        // To Reset Tap value
        else{
            
            if selectedButton == 2 {
                tapCount = 2
                
                myArt()
                InfoLabel.text = "TAP ON SCREEN TO ADD YOUR ART "
//                InfoLabel.textColor = UIColor.white
                selectedButton == 0
            }
            
            else{
                tapCount = 0
                
                myArt()
                InfoLabel.text = "TAP ON SCREEN TO ADD YOUR ART "
//                InfoLabel.textColor = UIColor.white
            }
           
        }
        
    }
    
    //
  @objc func ThumbUpAction(){
    
    print("************THUMBS UP********************")
    self.profileView.thumbUpValue.text = String(Int(self.profileView.thumbUpValue.text!)! + 1)
        
    }
    
    @objc func ThumbDownAction(){
        
        print("************THUMBS UP********************")
        self.profileView.thumbDownValue.text = String(Int(self.profileView.thumbDownValue.text!)! - 1)
        
    }
    
// PINCHED FUNCTION
    @objc func pinched(recognizer : UIPinchGestureRecognizer){
        
        if recognizer.view == ARViewLocationView{
            
            let touchview  = ARViewLocationView
            let touchPoint = recognizer.location(in: recognizer.view)
            
            let hitTest = touchview.hitTest(touchPoint, options: [:])
            
            if !hitTest.isEmpty{
                
                
                InfoLabel.text = "Resize "
//                InfoLabel.textColor = UIColor.white

                let hitResult = hitTest.first!
                
                
                print((hitResult.node.geometry?.name)!)
                // PANE is the  HITRESULT
                
                
                DispatchQueue.main.async {
                    if hitResult.node.geometry?.name == "Pane" || (hitResult.node.geometry?.name)! == "Frame"{
                        let node = hitResult.node
                        
                        let pinchAction = SCNAction.scale(by: recognizer.scale, duration: 0)
                        node.runAction(pinchAction)
                        recognizer.scale = 1
                }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        self.InfoLabel.text = "TAP ON SCREEN TO ADD YOUR ART "
//                        self.InfoLabel.textColor = UIColor.white
                    })
              
//

                }
            }
        }
        
    }
    
    
    // Func to Rotate AR Object
    @objc func rotateIt(recognizer : UIRotationGestureRecognizer){
        
        if recognizer.view == ARViewLocationView{
            
            let touchview  = ARViewLocationView
            let touchPoint = recognizer.location(in: recognizer.view)
            
            let hitTest = touchview.hitTest(touchPoint, options: [:])
            
            if !hitTest.isEmpty{
                
                
                InfoLabel.text = "Rotate"
//                InfoLabel.textColor = UIColor.white

                let hitResult = hitTest.first!
                
                
                
                // PANE is the  HITRESULT
                
                DispatchQueue.main.async {
                    if hitResult.node.geometry?.name == "Pane" || (hitResult.node.geometry?.name)! == "Frame"{
                        let node = hitResult.node
                        
                        var PtX1 = Int(touchPoint.x)
                        
                        print("x = \(touchPoint.x)")
                        //                    print("y = \(touchPoint.y)")
                        
                        
                        
                        if self.currentPtX > PtX1{
                            self.currentPtX = PtX1
                            
                            let rotateAction = SCNAction.rotateBy(x: 0, y: 0, z: 0.07, duration: 0)
                            node.runAction(rotateAction)
                         
                            
                        }
                        else{
                            self.currentPtX = PtX1
                            
                            let rotateAction = SCNAction.rotateBy(x: 0, y: 0, z: -0.04, duration: 0)
                            node.runAction(rotateAction)
                            
                            
                        }
                        
                        
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    self.InfoLabel.text = "TAP ON SCREEN TO ADD YOUR ART "
//                    self.InfoLabel.textColor = UIColor.white
                })
                
            
            }
        }
        
    }
    
    // CREATING PERSONAL ART
    func myArt() {
        
        self.InfoLabel.text = ("CHOOSE WHERE YOU WANT TO ADD ART")
        
        
        guard let location = self.locationManager.location else {return}
        
        
        
        if selectedButton == 2{
            
            let paneAnnotationNode = PaneAnnotation(Clocation: locationManager.location)

            DispatchQueue.main.async {
                self.ARViewLocationView.addLocationNodeForCurrentPosition(locationNode: paneAnnotationNode)
//                self.selectedButton = 0
                self.tapCount = 2
            }
            
        }
        
        else{
        if let image = selectedImage{
            
 print(image)
            let ArtAnnotationNode = ArtAnnotation(location: location, Image: image)
            
            
            DispatchQueue.main.async {
                self.ARViewLocationView.addLocationNodeForCurrentPosition(locationNode: ArtAnnotationNode)
                self.tapCount = 0
                self.selectedImage = nil

            }
        }
        
        }
    }
    
    
    // IMPORT ART FROM WEB-SERVICE
    func findArt(){
        
        guard let location = self.locationManager.location else{return}
        
        
        InfoLabel.text = "TAP ON SCREEN TO ADD YOUR ART "
//        InfoLabel.textColor = UIColor.white
        
        //TESTING Assign variable values
        print("**************")
        print("Latitude:\(location.coordinate.latitude)")
        print("Longitude:\(location.coordinate.longitude)")
        print("Radius: \(globalSetting.globalRadius)")
        print("user: \(globalSetting.userName)")
        print("token: \(globalSetting.tokenID)")
        print("**************")


        // GET RESPONSE VALUE FROM WEB-SERVICE API
        Alamofire.request("https://exhibit-irl.com/api.php/?func=get_pane&long=2\(location.coordinate.longitude)&lat=\(location.coordinate.latitude)&radius=\(globalSetting.globalRadius)&username=\(globalSetting.userName)&token=\(globalSetting.tokenID)", method: .get, parameters: nil)
            .validate(contentType: ["application/json"])
            .responseJSON { (response:DataResponse<Any>) in
                
                                print(response)
                
                let json = JSON(response.value)
                
                
                // check output
                                    print(json)
       
        }
        
        // ***********************
        
        /*
        // Search Request (From API)  "  get_panes(long,lat,radius, username, token)  "
        let  request = MKLocalSearchRequest()
        
        
        //Presize coordinate of user
        var region = MKCoordinateRegion()
        region.center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        
        
        request.region = region
        
        // Link Search Request with Region
        
        let searchResult = MKLocalSearch(request: request)
       
         */
    //****************
    
    
    
    }
    
    // Function which will help in creating CircleMenu Display
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        
     
        
            print(atIndex)
            let logo = ["camera.png","gallery.png", "frame.png"]
            let color = [UIColor.cyan, UIColor.green, UIColor.orange]
            
            
            let image = UIImage(named: logo[atIndex])
            button.backgroundColor = color[atIndex]
            button.setImage(image, for: .normal)
            button.layer.cornerRadius = CGFloat(10)
        

        
    }
    
    // Function which will assist in performing action on selected button
    
    func circleMenu(_ circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int) {
        
        
        
        print ("tap value : \(tapCount)")
        
        //  SELECTED: CAMERA
        if atIndex == 0{
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                ARViewLocationView.pause()
                imagepickerVC.sourceType = .camera
                self.present(imagepickerVC, animated: true, completion: nil)
            }
            else{
                print("Camera not available")
                
            }
        }
       
            
            // SELECTED: PHOTOLIBRARY
        else if atIndex == 1{
            imagepickerVC.sourceType = .photoLibrary
            self.present(imagepickerVC, animated: true, completion: nil)
            addButton.isHidden = true
        }
        
            // SELECTED : FRAME
        else if atIndex == 2{
            selectedButton = atIndex
            addButton.isHidden = true
        }
        
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
      
        
        let chooseimage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        self.selectedImage = chooseimage
        
        
        picker.dismiss(animated: true, completion: nil)
        ARViewLocationView.run()

        if selectedButton == 2{
            
            self.InfoLabel.text = ("TAP AGAIN TO  ADD PHOTO")
//            InfoLabel.textColor = UIColor.white
        }
        else{
        self.InfoLabel.text = ("CHOOSE WHERE YOU WANT TO ADD ART")
//        InfoLabel.textColor = UIColor.white
        }
    }
    
    // FUNCTION WILL HANDLE CANCEL OPERATION
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}


