//
//  SocketSender.swift
//  WhatAreYouDrawing
//
//  Created by Thushen Mohanarajah on 2021-06-16.
//

import Foundation
import SwiftUI

class SocketSender {
    
    let manager = SocketIOManager().socket
    
    
    func sendDrawing(obj: MousePoint) {
        print("Hello")
        let mSocket = manager.defaultSocket
        let jsonData = try! JSONEncoder().encode(obj)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        mSocket.emit("mouse",jsonString)
    }
}
