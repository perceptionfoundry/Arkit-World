//
//  RegisterVC.swift
//  ArtWork AR
//
//  Created by Syed ShahRukh Haider on 14/11/2017.
//  Copyright © 2017 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegisterVC: UIViewController {

    
    @IBOutlet weak var newUser: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//         ******************** CHECK *****************************
//        let params = ["func": "register_user",
//                      "username":"test3",
//                      "password" : "test34234",
//                      "email" : "nconsolo@me.com"
//        ]
//
//        Alamofire.request("https://exhibit-irl.com/api.php/?func=register_user&username=test3&password=test34234&email=nconsolo@me.com", method: .post, parameters: nil)
//            .validate(contentType: ["application/json"])
//            .responseJSON { (response:DataResponse<Any>) in
//                print(response)

//                let json = JSON(response.value)
//
//                let status = json[0][0].string
//
//
//                print (status)
//
//                print(globalSetting.tokenID)

        }
        
        

    

    @IBAction func submitButton(_ sender: Any) {
        
        
            
            let enterUser = newUser.text!
            let enterPassword = password.text!
            let emailAddress = email.text!
            let params = ["func": "register_user",
                          "username": "\(String(describing:enterUser))",
                "password" : "\(String(describing: enterPassword))",
                "email" : "\(String(describing: emailAddress))"
                        ]
        
        
        
        
        if !enterUser.isEmpty && !enterPassword.isEmpty && !emailAddress.isEmpty{
            
            print("*********")
            print(emailAddress,enterPassword, enterUser)
            print("*********")
            
            
            
            // checking for valid EMAIL format
            if emailAddress.contains("@"){
                
                Alamofire.request("https://exhibit-irl.com/api.php/?func=register_user&username=\(enterUser)&password=\(enterPassword))&email=\(emailAddress)", method: .post, parameters: nil)
                    .validate(contentType: ["application/json"])
                    .responseJSON { (response:DataResponse<Any>) in
                        
                        //                print(response)
                        
                        let json = JSON(response.value)
                        
                        
                        // check output
                        //                    print(json)
                        
                        // parse response data
                        let status = json["data"][0]["status"].string!
                        let message = json["data"][0]["message"].string
                        
                        
                        // Checking json result
                        //                    print(status)
                        //                    print(message)
                        
                        
                        
                        if status == "yes"{
                            
                            print(enterUser , enterPassword, emailAddress)
                            
                            print ("sucess")
                            
                            
                            // POP UP ALERT CONTROLLER
                            let alertVC = UIAlertController(title: "SUCCESS", message: "ACCOUNT CREATED", preferredStyle: .alert)
                            
                            // PERFORM SEGUE
                            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                self.performSegue(withIdentifier: "backtomain", sender: nil)
                            }))
                            
                            //PRESENT ALERT VIEWCONROLLER ON CURRENT VC VIEW
                            self.present(alertVC, animated: true, completion: nil)
                        }
                            
                            // Some error come from API in response HTTP "POST"
                        else{
                            
                            let alertVC = UIAlertController(title: "ERROR", message: message!, preferredStyle: .alert)
                            
                            alertVC.addAction(UIAlertAction(title: "CANCEL", style: .default, handler: nil))
                            
                            self.present(alertVC, animated: true, completion: nil)
                            
                        }
                }
                
            }
            
                
                // Alert ViewControler: Error Pop up if Email format is invalid
            else{
                
                let alertVC = UIAlertController(title: "Error", message: "Invalid Email Address", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                self.present(alertVC, animated: true, completion: nil)            }
            
            //Handling  WEB-SERVICE API with Alamofire
            
            
        }
        
            //ALERT VIEWCONTROLLER: IF ANY TEXTFIELD REMAIN UNFILLED
        else{
            
            let alertVC = UIAlertController(title: "Error", message: "Some Field left Unfilled", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
            
            }
        
        
        
    }
    

}
