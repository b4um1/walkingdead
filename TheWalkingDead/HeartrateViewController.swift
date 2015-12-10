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
    
    @IBOutlet weak var panel_labels: UIView!
    @IBOutlet weak var l_currentHeartBeat: UILabel!
    @IBOutlet weak var img_heart: UIImageView!
    
    @IBOutlet weak var l_avgbeats: UILabel!
    @IBOutlet weak var l_maxbeat: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.bleHandler!.heartRateDelegate = self
        setupUI()
    }
    
        
        // Do any additional setup after loading the view.

    
    var beats = [Int]()
    
    var currentbeat = 86
    let shrinkFactor = CGFloat(2.0 / 3)
    var expandFactor: CGFloat {
        return 1.0 / shrinkFactor
    }
    var duration: Double {
        return 60.0 / Double(currentbeat)
    }
    
    override func viewDidAppear(animated: Bool) {
        beat()
        updateAverageBeats(calcAverageBeats())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI(){
        panel_labels.layer.cornerRadius = 20
    }
    
    func calcAverageBeats() -> Int{
        beats.append(80)
        beats.append(80)
        beats.append(80)
        
        var totalsum:Int = 0
        
        for beat in beats {
            totalsum += beat
        }
        
        return totalsum/beats.count;
    }
    
    func updateAverageBeats(beat: Int){
        self.l_avgbeats.text = NSString(format: "%d BPM", beat) as String
    }
    
    func updateHeartReate(bpm: Int) {
        l_currentHeartBeat.text = bpm.description
        
        //print("bpm: \(bpm)")
    }
    
    func beat() {
        // 1
        UIView.animateWithDuration(duration / 2,
            delay: 0.0,
            options: .CurveEaseInOut,
            animations: {
                // 2
                self.img_heart.transform = CGAffineTransformScale(
                    self.img_heart.transform, self.shrinkFactor, self.shrinkFactor)
            },
            completion: { _ in
                // 3
                UIView.animateWithDuration(self.duration / 2,
                    delay: 0.0,
                    options: .CurveEaseInOut,
                    animations: {
                        // 4
                        self.img_heart.transform = CGAffineTransformScale(
                            self.img_heart.transform, self.expandFactor, self.expandFactor)
                    },
                    completion: { _ in
                        // 5
                        self.beat()
                    }
                )
            }
        )
    }
}
