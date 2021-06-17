//
//  PlayViewController.swift
//  WhatAreYouDrawing
//
//  Created by Thushen Mohanarajah on 2021-06-15.
//

import UIKit

class PlayViewController: ViewController {
    
    var usernameText = ""

    @IBOutlet weak var usernameTextField: UITextField!
    

    
    @IBAction func joinBtn(_ sender: Any) {
        self.usernameText = usernameTextField.text!
        
        performSegue(withIdentifier: "waitroom", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SocketIOManager.sharedInstance.establishConnection()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! WaitRoomViewController

        
        
        SocketIOManager.sharedInstance.joinEmit()
        
        
        SocketIOManager.sharedInstance.numbersConnectedReceived { (messageInfo) -> Void in
            vc.numberOfPlayers.text = messageInfo

        }
        
        vc.username = self.usernameText
    }
    

}

