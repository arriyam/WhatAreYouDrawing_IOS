//
//  SocketIOManager.swift
//  WhatAreYouDrawing
//
//  Created by Thushen Mohanarajah on 2021-06-15.
//

import Foundation
import SocketIO

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    
    let socket = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(true), .compress])
     
    var mSocket: SocketIOClient!
    
    override init() {
        super.init()
        mSocket = socket.defaultSocket
    }
    
    
    func establishConnection() {
        mSocket.connect()
        
    }
    
    
    func closeConnection() {
        mSocket.disconnect()
    }
    
    func joinEmit(){

        let obj = User(username: "hen", state:-1)
        let jsonData = try! JSONEncoder().encode(obj)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        mSocket.emit("join",jsonString)
    }
    
    
    func mouseBeginEmit(MouseData: MousePoint) {
        let jsonData = try! JSONEncoder().encode(MouseData)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        mSocket.emit("mouseBegin",jsonString)
    }
    
    func mouseMoveEmit(MouseData: MousePoint) {

        let jsonData = try! JSONEncoder().encode(MouseData)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        mSocket.emit("mouse",jsonString)
    }
    
    
    func mouseEndedEmit(MouseData: MousePoint) {
        let jsonData = try! JSONEncoder().encode(MouseData)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        mSocket.emit("mouseEnded",jsonString)
    }
    
    
    
    
    func mouseBeginRecieved(canvas: Canvas) {

        mSocket.on("mouseBegin") { ( dataArray, ack) -> Void in
            let dataInfo = dataArray[0] as! String
            
            let mousePointData = try! JSONDecoder().decode(MousePoint.self, from: dataInfo.data(using: .utf8)!)
            canvas.touchesBeganServer(obj: mousePointData)
            
        }
    }
    
    func mouseMoveRecieved(canvas: Canvas) {

        mSocket.on("mouse") { ( dataArray, ack) -> Void in
            let dataInfo = dataArray[0] as! String
            
            let mousePointData = try! JSONDecoder().decode(MousePoint.self, from: dataInfo.data(using: .utf8)!)
            canvas.touchesMoveServer(obj: mousePointData)
            
        }
    }
    
    func mouseEndedRecieved(canvas: Canvas) {

        mSocket.on("mouseEnded") { ( dataArray, ack) -> Void in
            let dataInfo = dataArray[0] as! String
            
            let mousePointData = try! JSONDecoder().decode(MousePoint.self, from: dataInfo.data(using: .utf8)!)
            canvas.touchesEndedServer(obj: mousePointData)
            
        }
    }
    
    func clearRecieved(canvas: Canvas) {

        mSocket.on("clear") { ( dataArray, ack) -> Void in
            canvas.clearServer()
        }
    }
    
    
    func clearEmit() {
        mSocket.emit("clear")
    }
    
    func numbersConnectedReceived(completionHandler: @escaping (_ messageInfo: String) -> Void) {

        mSocket.on("numberConnected") { ( dataArray, ack) -> Void in
            let dataInfo = dataArray[0] as! Int
            
            completionHandler("Players in lobby: \(dataInfo)")
            
        }
    }
    
    
}
