//
//  ViewController.swift
//  TheWalkingDead
//
//  Created by Mario Baumgartner on 04.12.15.
//  Copyright © 2015 Mario Baumgartner. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner
import SwiftyJSON

class MainViewController: UIViewController, StepDelegate {

    @IBOutlet weak var view_values: UIView!
    @IBOutlet weak var label_stepsHighscore: UILabel!
    @IBOutlet weak var label_stepsAverage: UILabel!
    @IBOutlet weak var label_username: UILabel!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var label_currentSteps: UILabel?
    var counter_steps = 0
    var stepCounter: StepCounter?
    var circleView: CircleView?
    var pageController: MyPageController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stepCounter = StepCounter()
        stepCounter!.stepDelegate = self
        setUpLayout()
        
        //load current steps of user (with id)(maximum/average)
        getCurrentSteps()
        getMaxSteps()
        getAvgSteps()
        //save current steps after stepping 50 steps.
        
    }
    func getCurrentSteps(){
        //current
        SwiftSpinner.show("Load current Steps.", animated: true)
        let parameters = [
            "user":pageController!.user!.name,
            "session":pageController!.user!.session
        ]
        Alamofire.request(.POST, "http://\(self.appDelegate.ipAdress):8080/at.fhooe.mc.walkingdead/step/today", parameters: parameters)
            .responseJSON { response in
                if response.result.isSuccess {
                    let json = JSON(response.result.value!)
                    print(json)
                    if json.isEmpty == false{
                        self.counter_steps = json["steps"].int!
                        self.label_currentSteps?.text = String(format: "%@ steps", json["steps"].stringValue)
                        self.circleView?.updateCircle(self.counter_steps)
                        self.circleView?.animateCircle(1)
                    }else{
                        self.counter_steps = 0
                        self.label_currentSteps!.text = "0 steps"
                        SwiftSpinner.show("Loading error 👎🏻", animated: true)
                    }
                    SwiftSpinner.hide()
                }
        }
    }
    func getMaxSteps(){
        //max
        SwiftSpinner.show("Load max Steps.", animated: true)
        let parameters = [
            "user":pageController!.user!.name,
            "session":pageController!.user!.session
        ]
        Alamofire.request(.POST, "http://\(self.appDelegate.ipAdress):8080/at.fhooe.mc.walkingdead/step/max", parameters: parameters)
            .responseJSON { response in
                if response.result.isSuccess {
                    let json = JSON(response.result.value!)
                    print(json)
                    print(json.isEmpty)
                    if json.isEmpty == false{
                        self.label_stepsHighscore.text = String(format: "%d Steps", json["steps"].int!)
                    }else{
                        self.label_stepsHighscore.text = String(format: "%d Steps", 0)
                        SwiftSpinner.show("Loading error 👎🏻", animated: true)
                    }
                }
                SwiftSpinner.hide()
        }
    }
    func getAvgSteps(){
        //avg
        SwiftSpinner.show("Load max Steps.", animated: true)
        let parameters = [
            "user":pageController!.user!.name,
            "session":pageController!.user!.session
        ]
        Alamofire.request(.POST, "http://\(self.appDelegate.ipAdress):8080/at.fhooe.mc.walkingdead/step/avg", parameters: parameters)
            .responseJSON { response in
                if response.result.isSuccess {
                    let json = JSON(response.result.value!)
                    print(json)
                    if json.isEmpty == false{
                        self.label_stepsAverage.text = String(format: "%d Steps", json["steps"].int!)
                    }else{
                        self.label_stepsAverage.text = String(format: "%d Steps", 0)
                        SwiftSpinner.show("Loading error 👎🏻", animated: true)
                    }
                }
                SwiftSpinner.hide()
        }

    }
    func saveSteps(){
        //save
        SwiftSpinner.show("Save Steps.", animated: true)
        let parameters = [
            "user":pageController!.user!.name,
            "session":pageController!.user!.session,
            "steps":"\(self.counter_steps)"
        ]
        Alamofire.request(.POST, "http://\(self.appDelegate.ipAdress):8080/at.fhooe.mc.walkingdead/step/create", parameters: parameters)
            .responseJSON { response in
                if response.result.isSuccess {
                    let json = JSON(response.result.value!)
                    print(json)
                    print("savedsteps")
                }
                SwiftSpinner.hide()
        }

    }
    
    func setupStepsLabel() {
        label_currentSteps = UILabel(frame: CGRectMake(0, 0, 200, 25))
        label_currentSteps!.center = CGPointMake((circleView?.center.x)!, (circleView?.center.y)!)
        label_currentSteps!.textAlignment = NSTextAlignment.Center
        label_currentSteps!.textColor = UIColor.whiteColor()
        label_currentSteps!.font = UIFont(name: label_currentSteps!.font!.fontName, size: 23)
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

    func onStepMade() {
        self.counter_steps++
        label_currentSteps!.text = "\(counter_steps) steps"
        circleView?.updateCircle(self.counter_steps)
        if self.counter_steps%10 == 0 {
            saveSteps()
        }
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

