//
//  GZRangeSlider.swift
//  RangeSlider
//
//  Created by zzh on 16/1/3.
//  Copyright © 2016年 Gavin Zeng. All rights reserved.
//

import Foundation
import UIKit

class GZRangeSlider: UIControl{
    private var leftHandleLayer: CALayer!
    private var rightHandleLayer: CALayer!
    private var normalbackImageView: UIImageView!
    private var highlightedImageView: UIImageView!
    private var leftTextLayer: CATextLayer!
    private var rightTextLayer: CATextLayer!
    
    private var barHeight: CGFloat = 10
    private var barWidth: CGFloat = 0
    private var handleWidth: CGFloat = 30
    private var handleHeight: CGFloat = 30
    
    private var insideMax: Int = 1000
    private var insideMin: Int = 0
    private var leftValue: Int = 0
    private var rightValue: Int = 0
    private var insideAccuracy: Int = 1
    
    private var previouslocation = CGPointZero
    
    private var isLeftSelected = false
    private var isRightSelected = false
    
    var valueChangeClosure: ((minValue: Int, maxValue: Int) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setInitValue()
        
        barWidth = frame.width - 2 * handleWidth
        normalbackImageView = UIImageView()
        normalbackImageView.layer.cornerRadius = 4
        normalbackImageView.backgroundColor = UIColor.lightGrayColor()
        normalbackImageView.frame = CGRectMake(handleWidth * 0.5,0.5 * (frame.height - barHeight),frame.width - handleWidth,barHeight)
        addSubview(normalbackImageView)
        
        highlightedImageView = UIImageView()
        highlightedImageView.backgroundColor = UIColor.blueColor()
        highlightedImageView.frame = CGRectMake(handleWidth * 0.5 ,0.5 * (frame.height - barHeight),frame.width - handleWidth,barHeight)
        addSubview(highlightedImageView)
        
        leftHandleLayer = createHandleLayer()
        leftHandleLayer.frame = CGRectMake(0, 0.5 * (frame.height - handleHeight), handleWidth, handleHeight)
        layer.addSublayer(leftHandleLayer)
        
        rightHandleLayer = createHandleLayer()
        rightHandleLayer.frame = CGRectMake(frame.width - handleWidth, leftHandleLayer.frame.minY, handleWidth, handleHeight)
        layer.addSublayer(rightHandleLayer)
        
        let kTextWidth: CGFloat = 50
        let kTextHeight: CGFloat = 20
        leftTextLayer = createTextLayer()
        leftTextLayer.string = "\(insideMin)"
        layer.addSublayer(leftTextLayer)
        leftTextLayer.frame = CGRectMake(leftHandleLayer.frame.minX - 0.5 * (kTextWidth - leftHandleLayer.frame.width), leftHandleLayer.frame.minY - kTextHeight, kTextWidth, kTextHeight)
        
        rightTextLayer = createTextLayer()
        rightTextLayer.string = "\(insideMax)"
        layer.addSublayer(rightTextLayer)
        rightTextLayer.frame = CGRectMake(rightHandleLayer.frame.minX - 0.5 * (kTextWidth - leftHandleLayer.frame.width), leftTextLayer.frame.minY, kTextWidth, kTextHeight)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: public method
    func setRange(minRange: Int, maxRange: Int, accuracy: Int){
        assert(maxRange >= minRange, "maxRange = \(maxRange) less than minRange = \(minRange)")
        insideMax = maxRange
        insideMin = minRange
        insideAccuracy = accuracy
        setInitValue()
        setLabelText()
    }
    
    func setCurrentValue(left: Int, right: Int){
        if left >= right{
            return
        }
        leftValue = max(insideMin,left)
        leftValue = min(insideMax,leftValue)
        
        rightValue = max(right,insideMin)
        rightValue = min(rightValue,insideMax)
        
        let range = insideMax - insideMin
        let leftX = CGFloat(leftValue - insideMin)/CGFloat(range)
        let rightX = CGFloat(rightValue - insideMin)/CGFloat(range)
        
        leftHandleLayer.frame = CGRectMake(leftX * barWidth, 0.5 * (frame.height - handleHeight), handleWidth, handleHeight)
        rightHandleLayer.frame = CGRectMake(rightX * barWidth + leftHandleLayer.frame.width, leftHandleLayer.frame.minY, handleWidth, handleHeight)
        
        setLabelText()
        updateHighlightedBar()
    }
    
    //MARK: private method
    private func setInitValue(){
        leftValue = insideMin
        rightValue = insideMax
    }
    
    private func updateHighlightedBar(){
        highlightedImageView.frame = CGRectMake(leftHandleLayer.frame.maxX - 0.5 * handleWidth,0.5 * (frame.height - barHeight), rightHandleLayer.frame.minX - leftHandleLayer.frame.maxX + handleWidth,barHeight)
        setLabelText()
        valueChangeClosure?(minValue: leftValue/insideAccuracy * insideAccuracy,maxValue: rightValue/insideAccuracy * insideAccuracy)
    }
    
    private func setLabelText(){
        leftTextLayer.string = "\(leftValue/insideAccuracy * insideAccuracy)"
        rightTextLayer.string = "\(rightValue/insideAccuracy * insideAccuracy)"
    }
    
    private func createHandleLayer() -> CALayer{
        let layer = CALayer()
        layer.cornerRadius = handleWidth * 0.5
        layer.backgroundColor = UIColor.redColor().CGColor
        return layer
    }
    
    private func createTextLayer() -> CATextLayer{
        let layer = CATextLayer()
        layer.contentsScale = UIScreen.mainScreen().scale
        layer.foregroundColor = UIColor.purpleColor().CGColor
        layer.fontSize = 12
        layer.alignmentMode = "center"
        return layer
    }
}

//MARK: touch
extension GZRangeSlider{
    private func setHitRect(rect: CGRect) -> CGRect{
        let offset:CGFloat = 10
        return CGRectMake(rect.minX, rect.minY - offset, rect.width, 2 * offset + rect.height)
    }
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        previouslocation = touch.locationInView(self)
        isLeftSelected = setHitRect(leftHandleLayer.frame).contains(previouslocation)
        isRightSelected = setHitRect(rightHandleLayer.frame).contains(previouslocation)
        return isLeftSelected || isRightSelected
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let location = touch.locationInView(self)
        let deltaLocation = (location.x - previouslocation.x)
        previouslocation = location
        
        if isLeftSelected{
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            leftHandleLayer.frame.origin.x = max(leftHandleLayer.frame.origin.x + deltaLocation, normalbackImageView.frame.minX + 0.5 * handleWidth - leftHandleLayer.frame.width)
            leftHandleLayer.frame.origin.x = min(leftHandleLayer.frame.origin.x, rightHandleLayer.frame.origin.x - leftHandleLayer.frame.width)
            leftValue = Int(leftHandleLayer.frame.origin.x/barWidth * CGFloat(insideMax - insideMin)) + insideMin
            updateHighlightedBar()
            CATransaction.commit()
            
        }else if isRightSelected{
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            rightHandleLayer.frame.origin.x = min(rightHandleLayer.frame.origin.x + deltaLocation,frame.width - rightHandleLayer.frame.width)
            rightHandleLayer.frame.origin.x = max(rightHandleLayer.frame.origin.x,leftHandleLayer.frame.origin.x + leftHandleLayer.frame.width)
            rightValue = Int((rightHandleLayer.frame.origin.x - leftHandleLayer.frame.width)/barWidth * CGFloat(insideMax - insideMin)) + insideMin
            updateHighlightedBar()
            CATransaction.commit()
        }
        
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        isLeftSelected = false
        isRightSelected = false
    }
    
    
}
