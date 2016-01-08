//
//  EnergyExpenditureViewController.swift
//  TheWalkingDead
//
//  Created by User on 07/01/16.
//  Copyright © 2016 Mario Baumgartner. All rights reserved.
//

import UIKit

class EnergyExpenditureViewController: UIViewController, HeartRateDelegate {

    @IBOutlet weak var caloriesLabel: UILabel!
    
    @IBOutlet weak var totalCaloriesLabel: UILabel!
    @IBOutlet weak var currentCaloriesLabel: UILabel!
    
    @IBOutlet weak var averageCaloriesLabel: UILabel!
    @IBOutlet weak var maxCaloriesLabel: UILabel!
    
    @IBOutlet weak var panel_labels: UIView!
    var pageController: MyPageController?
    var totalCaloriesCounter = 0.0
    
    var currentHeartRate = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        calcCalories()
        
        let caloriesTimer = NSTimer.scheduledTimerWithTimeInterval(60.0, target: self, selector: Selector("calcCalories"), userInfo: nil, repeats: true)
    }
    
    func setupUI(){
        panel_labels.layer.cornerRadius = 20
    }
    
    func updateHeartReate(bpm: Int) {
        currentHeartRate = bpm
    }
    
    func calcCalories() {
        if currentHeartRate != 0 {
            
            print("calcCalories ...")
            
            var user: User?
            if pageController != nil {
                user = pageController!.user
            }
            
            let subExpression1 = 0.133 * Double(user!.age) - (0.005 * Double(user!.age) * Double(user!.age))
            let subExpression2 = (11.403 * 1) + (1.463 * Double(user!.physicalActivityRating))
            let subExpression3 = (9.17 * 1.77) - (0.254 * Double(user!.age)) + 34.143
            let VO2max = subExpression1 + subExpression2 + subExpression3
            
            
            let heartRate = currentHeartRate
            
            let subsubExp = -36.3781 + 0.271 * Double(user!.age) + 0.394 * Double(user!.weight) + 0.404 * VO2max + 0.634 * Double(heartRate)
            let exp1 = -59.3954 + Double(user!.sex) * subsubExp
            
            let subExp3 = 0.274 * Double(user!.age) + 0.103 * Double(user!.weight)
            let subExp4 = 0.380 * VO2max + 0.450 * Double(heartRate)
            
            let exp2 = (1 - Double(user!.sex)) * (subExp3 + subExp4)
            let EE = exp1 + exp2
            
            var kcal = EE * 0.821641198
            
            kcal = Double(round(10*kcal)/10)
            
            totalCaloriesCounter += kcal
            totalCaloriesLabel.text = totalCaloriesCounter.description
            
            currentCaloriesLabel.text = kcal.description
        }
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
