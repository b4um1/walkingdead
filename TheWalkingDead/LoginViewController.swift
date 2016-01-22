
//
//  File.swift
//  TheWalkingDead
//
//  Created by Mario Baumgartner on 07.12.15.
//  Copyright © 2015 Mario Baumgartner. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner
import SwiftyJSON

class LoginViewController: UIViewController {
    
    @IBOutlet weak var panel_buttons: UIView!
    @IBOutlet weak var b_login: UIButton!
    @IBOutlet weak var tf_username: UITextField!
    @IBOutlet weak var tf_password: UITextField!

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let defaults = NSUserDefaults.standardUserDefaults()
    var user:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    override func viewWillAppear(animated: Bool) {
        if let name = defaults.valueForKey("name"){
            let parameters = [
                "user":name as! String,
                "session":defaults.valueForKey("session") as! String
            ]
            login(parameters)
        }
       
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func loginClicked(sender: AnyObject) {
        let parameters = [
            "user":tf_username.text!,
            "pass":tf_password.text!
        ]
        login(parameters)
    }
    
    func login(parameter: [String:String]){
        SwiftSpinner.show("Try to login ...")
        var delay = 0.5 * Double(NSEC_PER_SEC)
        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            
            let parameters = parameter
            var login = false
            //http post
            Alamofire.request(.POST, "http://\(self.appDelegate.ipAdress):8080/at.fhooe.mc.walkingdead/auth/login", parameters: parameters)
                .responseJSON { response in
                    if response.result.isSuccess {
                        let json = JSON(response.result.value!)
                        print(json)
                        if json.isEmpty == false && json["name"].stringValue != ""{
                            SwiftSpinner.show("Login successfull 💪🏻", animated: true)
                            login = true
                            self.user = User(id: json["id"].int!, physicalActivityRating: json["physicalActivityRating"].int!, stepLength: json["stepLength"].int!, age: json["age"].int!, name: json["name"].stringValue, weight: json["weight"].int!, height: json["height"].int!, sex: json["sex"].int!, session: json["session"].stringValue)
                            //save to userdefaults
                            self.defaults.setObject(json["name"].stringValue, forKey: "name")
                            self.defaults.setObject(json["session"].stringValue, forKey: "session")
                        }else{
                            self.defaults.removeObjectForKey("name")
                            self.defaults.removeObjectForKey("session")
                            SwiftSpinner.show("Invalid login 👎🏻", animated: true)
                        }
                    }
            }
            
            delay = 0.5 * Double(NSEC_PER_SEC)
            time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) {
                print("hide spinner")
                SwiftSpinner.hide()
                if login {
                    //perform segue to overview
                    self.performSegueWithIdentifier("showOverview", sender: self)
                }
                
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showOverview" {
            let mainViewCont: MyPageController = segue.destinationViewController as! MyPageController
            mainViewCont.user = self.user
        }
        
    }
}