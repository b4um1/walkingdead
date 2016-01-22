//
//  HeartrateViewController.swift
//  TheWalkingDead
//
//  Created by User on 10/12/15.
//  Copyright © 2015 Mario Baumgartner. All rights reserved.
//

import UIKit
import SwiftLoader
import MRProgress

class HeartrateViewController: UIViewController, HeartRateDelegate {

    var pageController: MyPageController?

    @IBOutlet weak var panel_labels: UIView!
    @IBOutlet weak var l_currentHeartBeat: UILabel!
    @IBOutlet weak var img_heart: UIImageView!
    
    @IBOutlet weak var l_avgbeats: UILabel!
    @IBOutlet weak var l_maxbeat: UILabel!
    @IBOutlet weak var l_minbeat: UILabel!
    
    
    var heartRateDelegate: HeartRateDelegate?
    var bleHandler = BLEHandler()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
   // let mrprogess = Mr
    
    var beats = [Int]()
    var currentbeat = 60
    var maxBeat = 0
    var minBeat = 200
    let shrinkFactor = CGFloat(2.0 / 3)
    var beatstartet = false
    var activityIndicatorShown = true
    
    var expandFactor: CGFloat {
        return 1.0 / shrinkFactor
    }
    
    var duration: Double {
        return 60.0 / Double(currentbeat)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.bleHandler!.heartRateDelegate = self
        setupUI()
        
        
        MRProgressOverlayView.showOverlayAddedTo(self.view, title: "Connecting to device", mode: MRProgressOverlayViewMode.Indeterminate, animated: true)
    }
    
    // Do any additional setup after loading the view.
    
    override func viewDidAppear(animated: Bool) {
        beat()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI(){
        panel_labels.layer.cornerRadius = 20
    }
    
    func calcAverageBeats(beat: Int) -> Int{
        beats.append(beat)
        
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
        if activityIndicatorShown {
            activityIndicatorShown = false
            MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
        }
        
        currentbeat = bpm
        l_currentHeartBeat.text = bpm.description
        
        //updateAverage
        updateAverageBeats(calcAverageBeats(bpm))
        
        //check max/min
        updateMaxMinBeat(bpm)
    }
    
    func updateMaxMinBeat(beat: Int){
        if beat > maxBeat {
            maxBeat = beat
            l_maxbeat.text = NSString(format: "%d BPM", beat) as String
        }
        if beat < minBeat {
            minBeat = beat
            l_minbeat.text = NSString(format: "%d BPM", beat) as String
        }
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
