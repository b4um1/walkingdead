//
//  ViewController.swift
//  TheWalkingDead
//
//  Created by Mario Baumgartner on 04.12.15.
//  Copyright © 2015 Mario Baumgartner. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, StepDelegate {

    @IBOutlet weak var view_values: UIView!
    @IBOutlet weak var label_currentSteps: UILabel!
    @IBOutlet weak var label_stepsHighscore: UILabel!
    @IBOutlet weak var label_stepsAverage: UILabel!
    
    var stepCounter: StepCounter?
    var circleView: CircleView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        setUpLayout()
        stepCounter = StepCounter()
        stepCounter!.stepDelegate = self
        
        addCircleView()
    }
    
    func setUpLayout() {
        view_values.layer.cornerRadius = 20
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func onStepMade(counter: Int) {
        label_currentSteps.text = "\(counter) steps"
    }
    
    func addCircleView() {
        //let diceRoll = CGFloat(Int(arc4random_uniform(7))*50)
        
        let circleWidth = UIScreen.mainScreen().bounds.width - 100
        let circleHeight = circleWidth
        
        // Create a new CircleView
        let circleView = CircleView(frame: CGRectMake(50, 80, circleWidth, circleHeight))
        
        view.addSubview(circleView)
        
        // Animate the drawing of the circle over the course of 1 second
        circleView.animateCircle(1.0)
    }

}

