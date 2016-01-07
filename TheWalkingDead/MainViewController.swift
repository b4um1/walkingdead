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
    @IBOutlet weak var label_stepsHighscore: UILabel!
    @IBOutlet weak var label_stepsAverage: UILabel!
    @IBOutlet weak var label_username: UILabel!
    var label_currentSteps: UILabel?
    
    var stepCounter: StepCounter?
    var circleView: CircleView?
    var pageController: MyPageController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stepCounter = StepCounter()
        stepCounter!.stepDelegate = self
        
        //load current steps of user (with id)(maximum/average)
        //save current steps after stepping 50 steps.
        setUpLayout()
    }
    
    func setupStepsLabel() {
        label_currentSteps = UILabel(frame: CGRectMake(0, 0, 200, 25))
        label_currentSteps!.center = CGPointMake((circleView?.center.x)!, (circleView?.center.y)!)
        label_currentSteps!.textAlignment = NSTextAlignment.Center
        label_currentSteps!.textColor = UIColor.whiteColor()
        label_currentSteps!.font = UIFont(name: label_currentSteps!.font!.fontName, size: 23)
        label_currentSteps!.text = "0 steps"
        self.view.addSubview(label_currentSteps!)
    }
    
    func setUpLayout() {
        navigationController?.navigationBarHidden = true
        view_values.layer.cornerRadius = 20
        
        label_username.text = String(format: "Hello, %@!", (self.pageController?.user?.name)!)
        
        addCircleView()
        setupStepsLabel()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func onStepMade(counter: Int) {
        label_currentSteps!.text = "\(counter) steps"
        circleView?.updateCircle(counter)
    }
    
    func addCircleView() {

        let circleWidth = UIScreen.mainScreen().bounds.width - 120
        let circleHeight = circleWidth
        
        // Create a new CircleView
        circleView = CircleView(frame: CGRectMake(60, 100, circleWidth, circleHeight))
        
        view.addSubview(circleView!)
        
        // Animate the drawing of the circle over the course of 1 second
        //circleView!.animateCircle(1.0)
    }

}

