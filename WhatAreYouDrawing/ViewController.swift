//
//  ViewController.swift
//  WhatAreYouDrawing
//
//  Created by Thushen Mohanarajah on 2021-06-15.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func playBtn(_ sender: Any) {
        performSegue(withIdentifier: "play", sender: self)
    }
    @IBAction func rulesBtn(_ sender: Any) {
        performSegue(withIdentifier: "rules", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

