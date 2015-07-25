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
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["email","user_friends", "public_profile", "user_friends", "user_birthday"]) {
            (user, error) -> Void in
            if let user = user {
                if user.isNew {
                    println("User signed up and logged in through Facebook!")
                } else {
                    
                    println("User logged in through Facebook!")
                }
                //println("\(user)")
                self.getUserInfo()
                
            } else {
                println("Uh oh. The user cancelled the Facebook login.")
            }
        }
    }
    
    func getUserInfo() -> Void
    {
        
        var fbRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"birthday, email, name, picture"])
        fbRequest.startWithCompletionHandler({ (FBSDKGraphRequestConnection, result, error) -> Void in
            
            if (error == nil && result != nil) {
                let facebookData = result as! NSDictionary //FACEBOOK DATA IN DICTIONARY
                let userEmail = (facebookData.objectForKey("email") as! String)
                let name = (facebookData.objectForKey("name") as! String)
                let foto = (facebookData.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as! String)
                let birthday = (facebookData.objectForKey("birthday") as! String)
                
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                let date = dateFormatter.dateFromString(birthday)
                
                         
                
                let dataFoto = NSData(contentsOfURL: NSURL(string: foto)!)!
                
                // Colocando no parse
                PFUser.currentUser()!.setValue(userEmail, forKey: "email")
                PFUser.currentUser()!.setValue(PFFile(name: "fotoFace", data: dataFoto), forKey: "foto")
                PFUser.currentUser()!.setValue(name, forKey: "nome")
                PFUser.currentUser()!.setValue(date, forKey: "dataNascimento")
                
                PFUser.currentUser()?.save()
                
                
                println(userEmail)
            }
        })
        
        
        //-------------------CERTO-----
        /*
        let request = FBSDKGraphRequest(graphPath:"me", parameters:nil)
        
        // Send request to Facebook
        request.startWithCompletionHandler {
            
            (connection, result, error) in
            
            if error != nil {
                // Some error checking here
            }
            else if let userData = result as? [String:AnyObject] {
                
                // Access user data
                let username = userData["name"] as! String
                //let email = userData["email"] as! String
                
                println("NAME NESSA CAALHA: \(userData)")
                PFUser.currentUser()!.setValue(username, forKey: "nome")
                PFUser.currentUser()?.save()
                
                // ....
            }
        } */
        
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
