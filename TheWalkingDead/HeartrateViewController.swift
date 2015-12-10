//
//  HeartrateViewController.swift
//  TheWalkingDead
//
//  Created by User on 10/12/15.
//  Copyright © 2015 Mario Baumgartner. All rights reserved.
//

import UIKit

class HeartrateViewController: UIViewController, HeartRateDelegate {

    var heartRateDelegate: HeartRateDelegate?
    var bleHandler = BLEHandler()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        appDelegate.bleHandler!.heartRateDelegate = self
        
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

    func updateHeartReate(bpm: Int) {
        print("bpm: \(bpm)")
    }
}
