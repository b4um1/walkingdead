//
//  StepCounter.swift
//  TheWalkingDead
//
//  Created by User on 04/12/15.
//  Copyright © 2015 Mario Baumgartner. All rights reserved.
//

import Foundation
import CoreMotion

class StepCounter {
    
    let manager = CMMotionManager()
    var counter = 0
    
    init() {
        startRecording()
    }
    
    func startRecording() {
        manager.accelerometerUpdateInterval = 0.1
        
        if manager.accelerometerAvailable {
            self.manager.startAccelerometerUpdatesToQueue(NSOperationQueue()) {
                (data, error) in
                dispatch_async(dispatch_get_main_queue()) {
                    
                    let x = data!.acceleration.x
                    let y = data!.acceleration.y
                    let z = data!.acceleration.z
                    
                    // start magic
                    let sum = sqrt((x * x) + (y * y) + (z * z))
                    
                    if sum > 1.2 {
                        self.counter++
                        print("step \(self.counter)")
                    }
                    // end magic
                }
            }
        }
    }
    
}