//
//  UserRegisterController.swift
//  TheWalkingDead
//
//  Created by Mario Baumgartner on 04.12.15.
//  Copyright © 2015 Mario Baumgartner. All rights reserved.
//

import UIKit
import SwiftSpinner
import Alamofire
import SwiftyJSON

class UserRegisterController: UIViewController {

    @IBOutlet weak var button_createUser: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tf_username: UITextField!
    @IBOutlet weak var tf_pw1: UITextField!
    @IBOutlet weak var tf_pwconfirm: UITextField!
    @IBOutlet weak var switch_sex: UISegmentedControl!
    @IBOutlet weak var tf_weight: UITextField!
    @IBOutlet weak var tf_steplength: UITextField!
    @IBOutlet weak var tf_heigth: UITextField!
    @IBOutlet weak var switch_fitnesslevel: UISegmentedControl!

    
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
        
        // get all values from input fields, not a fine way, but it works --> time is running
        //sex
        let sex = String(format: "%d",self.switch_sex.selectedSegmentIndex)
        //height
        var height:String
        if tf_heigth.text!.isEmpty {
            height = String(format: "%d",0)
        }else{
            height = String(format: "%a",self.tf_heigth.text!)
        }
        //weight
        var weight:String
        if tf_weight.text!.isEmpty {
            weight = String(format: "%d",0)
        }else{
            weight = String(format: "%a",self.tf_weight.text!)
        }
        //age
        let birthdate = datePicker.date
        print(birthdate)
        let today = NSDate()
        let differenceComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.Year, fromDate: birthdate, toDate: today, options: NSCalendarOptions(rawValue: 0) )
        let age = String(format: "%d",differenceComponents.year)

        
        //physical
        let physical = String(format: "%d",(self.switch_fitnesslevel.selectedSegmentIndex+1))
        
        //steplength
        var steplength:String
        if tf_steplength.text!.isEmpty {
            steplength = String(format: "%d",0)
        }else{
            steplength = String(format: "%a",self.tf_steplength.text!)
        }
        
        let parameters = [
            "user":self.tf_username.text!,
            "pass":self.tf_pw1.text!,
            "sex":sex,
            "heigth":height,
            "weight":weight,
            "age":age,
            "physical":physical,
            "steplength":steplength
        ]
        
        Alamofire.request(.POST, "http://10.29.17.241:8080/at.fhooe.mc.walkingdead/auth/createuser", parameters: parameters)
            .responseJSON { response in
                if response.result.isSuccess {
                    let json = JSON(response.result.value!)
                    print(json)
                    if json.isEmpty == false {
                        SwiftSpinner.show("Login successfull 💪🏻", animated: true)
                    }else{
                        SwiftSpinner.show("Invalid login 👎🏻", animated: true)
                    }
                }
        }

        
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


