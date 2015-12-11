//
//  UserRegisterController.swift
//  TheWalkingDead
//
//  Created by Mario Baumgartner on 04.12.15.
//  Copyright © 2015 Mario Baumgartner. All rights reserved.
//

import UIKit
import SwiftSpinner

class UserRegisterController: UIViewController {

    @IBOutlet weak var button_createUser: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func createClicked(sender: AnyObject) {
        //check entries
        
        SwiftSpinner.show("User will be created. ⏳")
        var delay = 2 * Double(NSEC_PER_SEC)
        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            SwiftSpinner.show("Successful - logging in 💪🏻🤘🏻", animated: true)
            delay = 3 * Double(NSEC_PER_SEC)
            time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) {
                SwiftSpinner.hide()
                self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("MyPageController") as UIViewController, animated: true)
                //self.performSegueWithIdentifier("login", sender: self)
            }
            
        }

    }
    
    func setUpUI(){
        //hide navigation bar
        //navigationController?.navigationBarHidden = true
        
        //add border 
        button_createUser.layer.cornerRadius = button_createUser.frame.size.width/2-1
        button_createUser.layer.borderWidth = 2
        button_createUser.layer.borderColor = UIColor(red:255.0/255.0, green:255.0/255.0, blue:255.0/255.0, alpha: 1.0).CGColor
        
        //datepicker color
        datePicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        
    }
}

