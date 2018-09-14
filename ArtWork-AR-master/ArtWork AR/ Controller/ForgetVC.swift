//
//  ForgetVC.swift
//  ArtWork AR
//
//  Created by Syed ShahRukh Haider on 16/11/2017.
//  Copyright © 2017 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ForgetVC: UIViewController {

    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    
    var enterUser : String?
    var enterEmail : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

 
    @IBAction func submitButton(_ sender: Any) {
  
        self.enterUser = userName.text
        self.enterEmail = emailField.text
    
        print(self.enterUser, self.enterEmail)

        
        // IF USER ENTER EMAIL ADDRESS FOR RESET PASSWORD
        if (self.enterUser?.isEmpty)! && !(self.enterEmail?.isEmpty)!{
            
            print(self.enterEmail!)
            
            Alamofire.request("https://exhibit-irl.com/api.php/?func=reset_password&username=&email=\(self.enterEmail!)", method: .post, parameters: nil)
                .validate(contentType: ["application/json"])
                .responseJSON { (response:DataResponse<Any>) in
                    
                    //                print(response)
                    
                    print("\n\n ********** JSON  Response ***********")
                    let json = JSON(response.value)
                    
                    
                    // check output
                    print(json)
                    
                    // parse response data
                    let status = json["data"][0]["status"].string!
                    
                    let alertVC = UIAlertController(title: "Status", message: status, preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        if status == "yes"{
                            self.dismiss(animated: true, completion: nil)
                        }
                        else{
                            return
                        }                    }))
                    
                    self.present(alertVC, animated: true, completion: nil)
            }
        }
        
            // IF USER ENTER USER ID FOR RESET PASSWORD

        else if (self.enterEmail?.isEmpty)! && !(self.enterUser?.isEmpty)!{
            print(self.enterUser!)

            Alamofire.request("https://exhibit-irl.com/api.php/?func=reset_password&username=\(self.enterUser!)&email=", method: .post, parameters: nil)
                .validate(contentType: ["application/json"])
                .responseJSON { (response:DataResponse<Any>) in
                    
                    //                print(response)
                    
                    print("\n\n ********** JSON  Response ***********")
                    let json = JSON(response.value)
                    
                    
                    // check output
                    print(json)
                    
                    // parse response data
                    let status = json["data"][0]["status"].string!
                    
                    let alertVC = UIAlertController(title: "Status", message: status, preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        if status == "yes"{
                        self.dismiss(animated: true, completion: nil)
                        }
                        else{
                            return
                        }
                    }))
                    
                    self.present(alertVC, animated: true, completion: nil)
            }
        }
        
            
            // BOTH TEXT FIELD IN EMPTY
        else{
            let alertVC = UIAlertController(title: "Error", message: "Filled any one field", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            
            self.present(alertVC, animated: true, completion: nil)
        }
       
    }
}
