//
//  makepaneAPI.swift
//  ArtWork AR
//
//  Created by Syed ShahRukh Haider on 24/11/2017.
//  Copyright © 2017 Syed ShahRukh Haider. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation


class makepaneAPI{
    
    let locationManager = CLLocationManager()
    
    
    func makePane(){
    
        guard let location = self.locationManager.location else{return}

        
        // CHECK URL
        
        print("*******************")
        print("https://exhibit-irl.com/api.php/?func=make_pane&long=\(location.coordinate.latitude)&lat=\(location.coordinate.longitude)&altitude=\(globalSetting.altitude)&height=\(globalSetting.globalheight)&width=\(globalSetting.globalWidth)&direction=\(globalSetting.direction)&username=\(globalSetting.userName)&token=\(globalSetting.tokenID)")
        print("*******************")

        // long,lat,altitude,height,width,direction,username, token)
        Alamofire.request("https://exhibit-irl.com/api.php/?func=make_pane&long=\(location.coordinate.latitude)&lat=\(location.coordinate.longitude)&altitude=\(globalSetting.altitude)&height=\(globalSetting.globalheight)&width=\(globalSetting.globalWidth)&direction=\(globalSetting.direction)&username=\(globalSetting.userName)&token=\(globalSetting.tokenID)", method: .post, parameters: nil)
    .validate(contentType: ["application/json"])
    .responseJSON { (response:DataResponse<Any>) in
    
    print(response)
    
    let json = JSON(response.value)
    
    
    // check output
    print(json)
    
    }
}
    
}
