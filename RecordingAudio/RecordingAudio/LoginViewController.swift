//
//  LoginViewController.swift
//  RecordingAudio
//
//  Created by Humberto Vieira de Castro on 7/23/15.
//  Copyright (c) 2015 Humberto Vieira de Castro. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Parse
import Bolts

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func click_LoginViaFace(sender: AnyObject) {
/// "user_friends", "public_profile", "user_friends"]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["email"]) {
            (user, error) -> Void in
            if let user = user {
                if user.isNew {
                    
                    println("User signed up and logged in through Facebook!")
                } else {
                    
                    println("User logged in through Facebook!")
                }
                println("\(user)")
            } else {
                println("Uh oh. The user cancelled the Facebook login.")
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
