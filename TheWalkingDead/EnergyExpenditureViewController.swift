//
//  EnergyExpenditureViewController.swift
//  TheWalkingDead
//
//  Created by User on 07/01/16.
//  Copyright © 2016 Mario Baumgartner. All rights reserved.
//

import UIKit

class EnergyExpenditureViewController: UIViewController {

    @IBOutlet weak var caloriesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //let VO2max = 0.133 * user.age - (0.005 * user.age * user.age) + (11.403 * 1) + (1.463 * 7) + (9.17 * 1.77) - (0.254 * user.weight) + 34.143
        
        /*

        VO2max [ml / min / kg] = (0.133 age) – (0.005*age2) + (11.403 * gender) + (1.463 PA-R) + (9.17 height) – (0.254 body_mass) + 34.143
        
        EE = -59.3954 + user.sex * (-36.3781 + 0.271 * user.age + 0.394 * user.weight + 0.404)

        */
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
