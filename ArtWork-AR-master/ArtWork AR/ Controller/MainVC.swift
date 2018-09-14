//
//  MainVC.swift
//  ArtWork AR
//
//  Created by Syed ShahRukh Haider on 15/11/2017.
//  Copyright © 2017 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MainVC: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let  params = ["func": "login",
//                       "username":"fdfghfhjfghgxgffjh",
//                       "password" : "ghghgghjghj",
//                       "email" : "chgvhjg@abc.com"]
//
//        Alamofire.request("https://exhibit-irl.com/api.php/", method: .post, parameters: params)
//            .validate(contentType: ["application/json"])
//            .responseJSON { (response:DataResponse<Any>) in
//                //                print(response)
//
//
//                // swiftyJSON
//
//                let parseData = JSON(response.value)
//
//                let status = parseData[0].string
//                let tokenNumber = parseData[1].string!
//
//
//                globalSetting.tokenID = tokenNumber
//
//                print(tokenNumber)
//
//
//                //                print("Status: \(status!) & TokenNumber : \(check)")
//        }
    
    }
    @IBAction func loginButton(_ sender: Any) {
        
        
        let enterUser = userName.text!
        let enterPassword = password.text!
        let params = ["func": "login",
                      "username": "\(String(describing:enterUser))",
                      "password" : "\(String(describing: enterPassword))"
            
                        ]
     
        // Check both text field is filled by user
        
        if !enterUser.isEmpty && !enterPassword.isEmpty{
            
            print("***********")
            print(enterPassword, enterUser)
            print("***********")
            
            Alamofire.request("https://exhibit-irl.com/api.php/?func=login&username=\(enterUser)&password=\(enterPassword)", method: .post, parameters: nil)
                .validate(contentType: ["application/json"])
                .responseJSON { (response:DataResponse<Any>) in
                    //                print(response)
                    
                    
                    // swiftyJSON
                    
                    let parseData = JSON(response.value)
                    
                    let status = parseData["data"][0]["status"].string!
                    
                    if status == "yes"{
                        let tokenNumber = parseData["data"][0]["token"].string!
                        print(tokenNumber)
                        if !tokenNumber.isEmpty{
                            
                            // save tokenID value Globally for entire App
                            globalSetting.tokenID = tokenNumber
                            globalSetting.userName = enterUser
                            
                            self.performSegue(withIdentifier: "MainSegue", sender: nil)
                            //                        print("****************")
                            //                        print(globalSetting.tokenID)
                            //                        print(globalSetting.userName)
                            //                        print("****************")
                            
                            
                        }
                        
                    }
                    
                    
                    
                    else{
                        let message = parseData["data"][0]["message"].string!
                        print(message)

                        let alertVC = UIAlertController(title: "Error", message: "User or Password is incorrect", preferredStyle: .alert)
                        alertVC.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                        self.present(alertVC, animated: true, completion: nil)
                    }
                    
            }
            
            
        }
        
            
            // Alert ViewController: If any field left empty
        else{
            
            let alertVC = UIAlertController(title: "Error", message: "Some Field left unfilled", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
        
        
     
    }
}
