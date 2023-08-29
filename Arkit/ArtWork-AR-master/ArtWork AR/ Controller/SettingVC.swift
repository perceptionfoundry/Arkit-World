//
//  SettingVC.swift
//  ArtWork AR
//
//  Created by Syed ShahRukh Haider on 06/11/2017.
//  Copyright © 2017 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SettingVC: UIViewController {

    @IBOutlet weak var unitButton: UISwitch!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var paneSlider: UISlider!
    
    
    let username = globalSetting.userName
    let tokenID = globalSetting.tokenID
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print("********")
//        print("userid:\(username)")
//        print("\n tokenid: \(tokenID)")
//        print("********")
        // Do any additional setup after loading the view.
        
    }


    
    
    // Setting Radius for GPS
    @IBAction func radiusSetting(_ sender: Any) {
    
        
        let radius:Float = 1609.0                //1 miles = 1.609 km

        var currentRadius = radius * radiusSlider.value
        
        globalSetting.globalRadius = currentRadius
        
        
        if unitButton.isOn{
            
            print("\(globalSetting.globalRadius) KM ")
        }
        
        else {
            
           
            
            var mile = (globalSetting.globalRadius/1000) / 1.609
            
            print("\(mile) Miles")
        }
    }
    
    // Setting Pane Size
    @IBAction func paneSetting(_ sender: Any) {
        
        var panesize : Float = 1.0
        
        // Formula to maintain ratio b/w width & height
        panesize = (2.3 * paneSlider.value)
        globalSetting.altitude = panesize
       
        // Default Width & Height
        let width : Float = 3.0
        let height : Float = 2.0
        
        // Setting Width & Height value global to the app
        
        globalSetting.globalWidth = (width * panesize) + width
        globalSetting.globalheight = (height * panesize) + height
      
        // TESTING RESULT
        print ("width:\(globalSetting.globalWidth) & height: \(globalSetting.globalheight)")
        
    }
    
    
    
    // Action
    @IBAction func unitConversion(_ sender: Any) {
        
        
        // VALUE WILL BE IN KILOMETER
        if unitButton.isOn == true{
            print("CONVERTED UNIT FROM  MILES TO KM")

            globalSetting.GlobalUnit = "KM"
        }
        
        else{
            print("CONVERTED UNIT FROM KM TO MILES")

             globalSetting.GlobalUnit = "MILES"
        }
    }
    
    
    
    
    
    
    
    // Function which will handle Logout Operation
    @IBAction func logoutButton(_ sender: Any) {
        
        Alamofire.request("https://exhibit-irl.com/api.php/?func=logout&username\(username)=&token=\(tokenID)", method: .post, parameters: nil)
            .validate(contentType: ["application/json"])
            .responseJSON { (response:DataResponse<Any>) in
                
                //                print(response)
                
                print("\n\n ********** JSON  Response ***********")
                let json = JSON(response.value)
                
                
                // check output
                                    print(json)
                
                // parse response data
                let status = json["data"][0]["status"].string!
                let message = json["data"][0]["message"].string
    }
    

}
}
