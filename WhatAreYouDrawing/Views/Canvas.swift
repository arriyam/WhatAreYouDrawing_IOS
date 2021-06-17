//
//  Canvas.swift
//  WhatAreYouDrawing
//
//  Created by Thushen Mohanarajah on 2021-06-16.
//

import Foundation


import UIKit
import SwiftUI


class Canvas: UIView {
    
    let manager = SocketIOManager().socket
  
    fileprivate var strokeColour = UIColor.black
    fileprivate var strokeWidth: CGFloat = 1
    
    fileprivate var previousX :CGFloat = 0
    fileprivate var previousY :CGFloat = 0
    
    fileprivate var screenWidth :Float = Float(UIScreen.main.bounds.width)
    fileprivate var screenHeight :Float = Float(UIScreen.main.bounds.height)
    
    
    
    
//    public functions
    
    func setStrokeColour (colour: UIColor){
        self.strokeColour = colour
    }
    
    func setStrokeWidth (width: CGFloat) {
        self.strokeWidth = width
    }
    
    func undo(){
        _ = lines.popLast()
        setNeedsDisplay()
    }
    
    func clear(){
        lines.removeAll()
        SocketIOManager.sharedInstance.clearEmit()
        setNeedsDisplay()
    }
    override func draw (_ rect: CGRect) {
    
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else
            { return }
        
        
//        let startPoint = CGPoint(x: 0, y: 0)
//        let endPoint = CGPoint(x: 100, y: 100)
//
//        context.move(to: startPoint)
//        context.addLine(to: endPoint)
  

//        Makes the lines round
        context.setLineCap(.round)
        
        
        lines.forEach{ (line) in
            //        The colour of the lines
            context.setStrokeColor(line.colour.cgColor)
            //        The width of the line
            context.setLineWidth(line.strokeWidth)
            
            for (h,e) in line.points.enumerated() {
                if h == 0 {
                    context.move(to: e)
                }
                else {
                    context.addLine(to: e)
                }
            }
            context.strokePath()
        }
    }

//    var line = [CGPoint]()
    
    var lines = [Line]()
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: nil) else { return }
        
//        print("-------------------------------------------------------------------------------------------")
//        print(point)
//        print("-------------------------------------------------------------------------------------------")
//        (476.0, 219.0)
        
        
        self.previousX = point.x
        self.previousY = point.y
        let obj = MousePoint(x: Float(point.x), y: Float(point.y), px: Float(self.previousX), py: Float(self.previousY), windowX: screenWidth, windowY: screenHeight)
        SocketIOManager.sharedInstance.mouseBeginEmit(MouseData: obj)
        lines.append(Line.init(strokeWidth: strokeWidth, colour: strokeColour, points: []))
    }
    
    
//    Track Cordinates
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let point = touches.first?.location(in: nil) else { return }
        

//        let typeOfArray = point.dynamicType
//        print(typeOfArray)
        
        let obj = MousePoint(x: Float(point.x), y: Float(point.y), px: Float(self.previousX), py: Float(self.previousY), windowX: Float(900), windowY: Float(420))
        SocketIOManager.sharedInstance.mouseMoveEmit(MouseData: obj)
        
        self.previousX = point.x
        self.previousY = point.y
        
        guard var lastLine = lines.popLast() else { return }
        
        lastLine.points.append(point)
    
        lines.append(lastLine)
        
        setNeedsDisplay()
//        print(point)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: nil) else { return }
        self.previousX = point.x
        self.previousY = point.y
        let obj = MousePoint(x: Float(point.x), y: Float(point.y), px: Float(self.previousX), py: Float(self.previousY), windowX: self.screenWidth, windowY: self.screenHeight)
        SocketIOManager.sharedInstance.mouseEndedEmit(MouseData: obj)
    }
    
    public func touchesBeganServer(obj : MousePoint) {
        print("Begin")
        
        lines.append(Line.init(strokeWidth: strokeWidth, colour: strokeColour, points: []))
    }
    
    public func touchesMoveServer(obj : MousePoint) {
        print("Move")
        let object = screenUpdatedCordinates(obj: obj)
        let point = CGPoint(x: CGFloat(object.x), y: CGFloat(object.y))
        guard var lastLine = lines.popLast() else { return }

        lastLine.points.append(point)

        lines.append(lastLine)

        setNeedsDisplay()
    }
    
    public func touchesEndedServer(obj : MousePoint) {
        print("Ended")
    }
    
    public func clearServer() {
        lines.removeAll()
        setNeedsDisplay()
        
    }
    
    public func screenUpdatedCordinates (obj : MousePoint) -> MousePoint {
        let scaledX = obj.x * screenWidth / obj.windowX
        let scaledY = obj.y * screenHeight / obj.windowY
        
        return MousePoint(x: scaledX, y: scaledY, px: 0, py: 0, windowX: 0, windowY: 0)
        
        
    }
    
}
