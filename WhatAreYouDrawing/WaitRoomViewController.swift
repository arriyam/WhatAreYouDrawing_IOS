//
//  WaitRoomViewController.swift
//  WhatAreYouDrawing
//
//  Created by Thushen Mohanarajah on 2021-06-15.
//

import UIKit

class WaitRoomViewController: UIViewController {
    
    var username = ""
    
    let manager = SocketIOManager().socket

    @IBOutlet weak var greetingUser: UILabel!
    
    @IBOutlet weak var numberOfPlayers: UILabel!
    @IBAction func JoinBtn(_ sender: Any) {
//        performSegue(withIdentifier: "draw", sender: self)
        let vc = storyboard?.instantiateViewController(identifier: "DrawViewController") as! DrawViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SocketIOManager.sharedInstance.numbersConnectedReceived { (messageInfo) -> Void in
            self.numberOfPlayers.text = messageInfo
        }
    
        
        greetingUser.text = "Hello, "+username
        
        
    }
    

}
