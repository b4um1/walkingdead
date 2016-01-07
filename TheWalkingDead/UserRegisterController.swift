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

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var register_successfully = false
    
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
        let sex = self.switch_sex.selectedSegmentIndex.description
        //height
        var height:String
        if tf_heigth.text!.isEmpty {
            height = "0"
        }else{
            height = self.tf_heigth.text!
        }
        //weight
        var weight:String
        if tf_weight.text!.isEmpty {
            weight = "0"
        }else{
            weight = self.tf_weight.text!
        }
        //age
        let birthdate = datePicker.date
        print(birthdate)
        let today = NSDate()
        let differenceComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.Year, fromDate: birthdate, toDate: today, options: NSCalendarOptions(rawValue: 0) )
        let age = differenceComponents.year.description

        
        //physical
        let physical = (self.switch_fitnesslevel.selectedSegmentIndex+1).description
        
        //steplength
        var steplength:String
        if tf_steplength.text!.isEmpty {
            steplength = "0"
        }else{
            steplength = self.tf_steplength.text!
        }
        
        let parameters = [
            "user":self.tf_username.text!,
            "pass":self.tf_pw1.text!,
            "sex":sex,
            "height":height,
            "weight":weight,
            "age":age,
            "physical":physical,
            "steplength":steplength
        ]
        
        Alamofire.request(.POST, "http://\(self.appDelegate.ipAdress):8080/at.fhooe.mc.walkingdead/auth/createuser", parameters: parameters)
            .responseJSON { response in
                if response.result.isSuccess {
                    let json = JSON(response.result.value!)
                    print("Result of register: %a",json.description)
                    if json.description == "true" {
                        SwiftSpinner.show("Registered successfully 💪🏻", animated: true)
                        self.register_successfully = true
                    }else{
                        SwiftSpinner.show("User already exits 👎🏻", animated: true)
                    }
                }
        }
        
        //if registration was successful, then pop back to login view
       
        let delay = 2 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            SwiftSpinner.hide()
            if self.register_successfully == true{
                self.navigationController?.popViewControllerAnimated(true)
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


