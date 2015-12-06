//
//  UserRegisterController.swift
//  TheWalkingDead
//
//  Created by Mario Baumgartner on 04.12.15.
//  Copyright © 2015 Mario Baumgartner. All rights reserved.
//

import UIKit

class UserRegisterController: UIViewController {

    @IBOutlet weak var button_createUser: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    func setUpUI(){
        //hide navigation bar
        navigationController?.navigationBarHidden = true
        
        //add border 
        button_createUser.layer.cornerRadius = button_createUser.frame.size.width/2-1
        button_createUser.layer.borderWidth = 2
        button_createUser.layer.borderColor = UIColor(red:255.0/255.0, green:255.0/255.0, blue:255.0/255.0, alpha: 1.0).CGColor
        
        //datepicker color
        datePicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        
    }
}

