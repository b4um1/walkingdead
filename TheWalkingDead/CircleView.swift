//
//  CircleView.swift
//  TheWalkingDead
//
//  Created by User on 04/12/15.
//  Copyright © 2015 Mario Baumgartner. All rights reserved.
//

import UIKit

class CircleView: UIView {

    var circleLayer: CAShapeLayer!
    let maxSteps = 7000.0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        setupCircle(0)
    }
    
    func setupCircle(value: Int) {
        let startAngle = CGFloat(-M_PI / 2)
        var endAngle = CGFloat(CGFloat(Double(value) / maxSteps) * CGFloat(2 * M_PI))
        endAngle -= CGFloat(M_PI / 2)
        
        //let endAngle = CGFloat(M_PI * 3 / 2)            // CGFloat(M_PI * 2.0)
        
        // Use UIBezierPath as an easy way to create the CGPath for the layer.
        // The path should be the entire circle.
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 10)/2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        // Setup the CAShapeLayer with the path, colors, and line width
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.CGPath
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.strokeColor = UIColor(red: 41.0/255.0, green: 171.0/255.0, blue: 226.0/255.0, alpha: 1.0).CGColor
        circleLayer.lineWidth = 30.0
        
        // Don't draw the circle initially
        circleLayer.strokeEnd = 1.0
        

        layer.addSublayer(circleLayer)
    }
    
    func updateCircle(value: Int) {
        circleLayer.removeFromSuperlayer()
        setupCircle(value)
        self.setNeedsDisplay()
    }
    
    func animateCircle(duration: NSTimeInterval) {
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        // Set the animation duration appropriately
        animation.duration = duration
        
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = 1
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        circleLayer.strokeEnd = 1.0
        
        // Do the actual animation
        circleLayer.addAnimation(animation, forKey: "animateCircle")
    }

}
