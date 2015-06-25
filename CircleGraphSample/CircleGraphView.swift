//
//  CircleGraphView.swift
//  CircleGraphSample
//
//  Created by 中塩成海 on 2015/06/25.
//  Copyright (c) 2015年 Derushio. All rights reserved.
//

import UIKit

let TIMER_DELAY: Double = 0.016
let RADIAN_RAITO: Double = M_PI / 180.0
let ROTATION_SPEED: CGFloat = CGFloat(360 * RADIAN_RAITO * TIMER_DELAY)

class CircleGraphView: UIImageView {
    enum DrawContext {
        case bg
        case male
        case female
    }
    
    private var isSetUped: Bool = false
    private var timer: NSTimer?
    
    private var numMale: Int = 0
    private var numFemale: Int = 0
    
    private var oldTheta: CGFloat = 0
    
    override func layoutSubviews() {
        if (isSetUped == false) {
            UIGraphicsBeginImageContext(CGSizeMake(frame.size.width, frame.size.height))
            drawBackGround()
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
    }
    
    func drawBackGround() {
        var oval: UIBezierPath = UIBezierPath(ovalInRect: CGRectMake(0, 0, frame.size.width, frame.size.height))
        UIColor.lightGrayColor().setFill()
        oval.fill()
    }
    
    func setGraph(numMale:Int, numFemale:Int) {
        self.numMale = numMale
        self.numFemale = numFemale
        
        let maleRaito:Double = Double(numMale) / Double(numMale + numFemale)
        let femaleRaito:Double = Double(numFemale) / Double(numMale + numFemale)
        
        UIGraphicsBeginImageContext(CGSizeMake(frame.size.width, frame.size.height))
        drawBackGround()
        
        if (numMale < numFemale) {
            drawHalfCircle(CGFloat(360*(maleRaito)*RADIAN_RAITO) - CGFloat(90*RADIAN_RAITO), drawContext: .male)
            drawHalfCircle(CGFloat(270*RADIAN_RAITO), drawContext: .female)
            drawHalfCircle(CGFloat(360*(maleRaito)*RADIAN_RAITO) + CGFloat(90*RADIAN_RAITO), drawContext: .female)
        } else if (numMale > numFemale){
            drawHalfCircle(CGFloat(360*(maleRaito)*RADIAN_RAITO) + CGFloat(90*RADIAN_RAITO), drawContext: .female)
            drawHalfCircle(CGFloat(90*RADIAN_RAITO), drawContext: .male)
            drawHalfCircle(CGFloat(360*(maleRaito)*RADIAN_RAITO) - CGFloat(90*RADIAN_RAITO), drawContext: .male)
        } else {
            drawHalfCircle(CGFloat(90*RADIAN_RAITO), drawContext: .male)
            drawHalfCircle(CGFloat(270*RADIAN_RAITO), drawContext: .female)
        }
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        isSetUped = true
    }
    
    func drawHalfCircle(startAngle: CGFloat, drawContext: DrawContext) {
        var arc: UIBezierPath = UIBezierPath(arcCenter: CGPointMake(frame.size.width/2, frame.size.height/2), radius: frame.size.width/2, startAngle: startAngle, endAngle: startAngle + CGFloat(180*RADIAN_RAITO), clockwise: false)
        
        switch (drawContext) {
        case .bg:
            UIColor.lightGrayColor().setFill()
            break
        case .male:
            UIColor.blueColor().setFill()
            break
        case .female:
            UIColor.redColor().setFill()
            break
        }
        arc.fill()
    }
    
    func startAnime(numMale:Int, numFemale:Int) {
        self.numMale = numMale
        self.numFemale = numFemale
        
        stopAnime()
        timer = NSTimer.scheduledTimerWithTimeInterval(TIMER_DELAY, target: self, selector: "onTick", userInfo: nil, repeats: true)
    }
    
    func stopAnime() {
        timer?.invalidate()
        timer = nil
    }
    
    func onTick() {
    }
}
