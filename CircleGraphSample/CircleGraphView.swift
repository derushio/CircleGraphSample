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
    
    private var permilliMale: Int = 0
    private var permilliFemale: Int = 0
    
    private var count: Int = 0
    
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
    
    func setGraph(numMale: Int, numFemale: Int) {
        setGraph(numMale, numFemale: numFemale, numBlank: 0)
    }
    
    func setGraph(numMale: Int, numFemale: Int, numBlank: Int) {
        self.numMale = numMale
        self.numFemale = numFemale
        
        let malePoint: CGFloat = CGFloat(360*(Double(numMale) / Double(numMale + numFemale + numBlank))*RADIAN_RAITO)
        let femalePoint: CGFloat = CGFloat(360*(Double(numFemale) / Double(numMale + numFemale + numBlank))*RADIAN_RAITO) + malePoint
        let blankPoint: CGFloat = CGFloat(360*(Double(numBlank) / Double(numMale + numFemale + numBlank))*RADIAN_RAITO) + femalePoint
        
        UIGraphicsBeginImageContext(CGSizeMake(frame.size.width, frame.size.height))
        drawBackGround()

        drawGraph(0, endAngle: malePoint, drawContext: .male)
        drawGraph(malePoint, endAngle: femalePoint, drawContext: .female)
        drawGraph(femalePoint, endAngle: blankPoint, drawContext: .bg)
    
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        isSetUped = true
    }
    
    func drawGraph(startAngle: CGFloat, endAngle: CGFloat, drawContext: DrawContext) {
        let tempStartAngle: CGFloat = startAngle - CGFloat(90*RADIAN_RAITO)
        let tempEndAngle: CGFloat = endAngle - CGFloat(90*RADIAN_RAITO)
        
        var arc: UIBezierPath = UIBezierPath(arcCenter: CGPointMake(frame.size.width/2, frame.size.height/2), radius: frame.size.width/2, startAngle: tempStartAngle, endAngle: tempEndAngle, clockwise: true)
        arc.addLineToPoint(CGPointMake(frame.size.width/2, frame.size.height/2))
        
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
        
        permilliMale = Int(1000 * (Double(numMale)/Double(numMale + numFemale)))
        permilliFemale = Int(1000 * (Double(numFemale)/Double(numMale + numFemale)))
        count = 0
        
        stopAnime()
        timer = NSTimer.scheduledTimerWithTimeInterval(TIMER_DELAY, target: self, selector: "onTick", userInfo: nil, repeats: true)
    }
    
    func stopAnime() {
        timer?.invalidate()
        timer = nil
    }
    
    func onTick() {
        var numMale: Int = count
        var numFemale: Int = 0
        if (permilliMale < count) {
            numMale = permilliMale
            
            if (permilliFemale < count - numMale) {
                numFemale = permilliFemale
            } else {
                numFemale = count - permilliMale
            }
        }
        
        var numBlank: Int = 1000 - numMale - numFemale
        
        setGraph(numMale, numFemale: numFemale, numBlank: numBlank)
        
        count += 10
        if (1000 < count) {
            stopAnime()
        }
    }
}
