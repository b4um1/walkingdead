
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

class LoginViewController: UIViewController {
    
    @IBOutlet weak var panel_buttons: UIView!
    @IBOutlet weak var b_login: UIButton!
    @IBOutlet weak var tf_username: UITextField!
    @IBOutlet weak var tf_password: UITextField!

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
        var delay = 3 * Double(NSEC_PER_SEC)
        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            let parameters = [
                "user":self.tf_username.text!,
                "pass":self.tf_password.text!
            ]
            
            var login = false
            
            Alamofire.request(.POST, "http://10.29.17.241:8080/at.fhooe.mc.walkingdead/auth/login", parameters: parameters)
                .responseString { response in
                    if response.result.isSuccess {
                        //let json = JSON(response.result.value)
                        SwiftSpinner.show("Login successfull 💪🏻", animated: true)
                        login = true
                    }else{
                        SwiftSpinner.show("Invalid login 👎🏻", animated: true)
                    }
            }
            
            delay = 0.5 * Double(NSEC_PER_SEC)
            time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) {
                SwiftSpinner.hide()
                if login {
                    self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("MyPageController") as UIViewController, animated: true)
                }
                //self.performSegueWithIdentifier("MyPageController", sender: self)
            }
        }
    }
}