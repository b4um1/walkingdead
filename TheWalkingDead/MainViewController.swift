//
//  ViewController.swift
//  TheWalkingDead
//
//  Created by Mario Baumgartner on 04.12.15.
//  Copyright © 2015 Mario Baumgartner. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var view_values: UIView!
    @IBOutlet weak var label_currentSteps: UILabel!
    @IBOutlet weak var label_stepsHighscore: UILabel!
    @IBOutlet weak var label_stepsAverage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        
    }
    
    func setUpLayout() {
        view_values.layer.cornerRadius = 20
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

