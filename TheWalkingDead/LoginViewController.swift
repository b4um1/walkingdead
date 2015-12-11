
//
//  File.swift
//  TheWalkingDead
//
//  Created by Mario Baumgartner on 07.12.15.
//  Copyright © 2015 Mario Baumgartner. All rights reserved.
//

import UIKit
import SwiftSpinner

class LoginViewController: UIViewController {
    
    @IBOutlet weak var panel_buttons: UIView!
    @IBOutlet weak var b_login: UIButton!

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
            SwiftSpinner.show("Login successfull 💪🏻", animated: true)
            delay = 1.5 * Double(NSEC_PER_SEC)
            time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) {
                SwiftSpinner.hide()
                self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("MyPageController") as UIViewController, animated: true)
                //self.performSegueWithIdentifier("MyPageController", sender: self)
            }
        }
    }
}