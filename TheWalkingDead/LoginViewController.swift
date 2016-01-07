
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent

        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func loginClicked(sender: AnyObject) {
        SwiftSpinner.show("Try to login ...")
        var delay = 1 * Double(NSEC_PER_SEC)
        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            
            let parameters = [
                "user":self.tf_username.text!,
                "pass":self.tf_password.text!
            ]
            var login = false
            //http post
            Alamofire.request(.POST, "http://\(self.appDelegate.ipAdress):8080/at.fhooe.mc.walkingdead/auth/login", parameters: parameters)
                .responseJSON { response in
                    if response.result.isSuccess {
                        let json = JSON(response.result.value!)
                        print(json)
                        if json.isEmpty == false {
                            SwiftSpinner.show("Login successfull 💪🏻", animated: true)
                            login = true
                        }else{
                             SwiftSpinner.show("Invalid login 👎🏻", animated: true)
                        }
                    }
            }
            
            delay = 0.5 * Double(NSEC_PER_SEC)
            time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) {
                SwiftSpinner.hide()
                if login {
                    //self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("MyPageController") as UIViewController, animated: true)
                    self.performSegueWithIdentifier("showOverview", sender: self)
                }
                
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("prepare")
    }
}