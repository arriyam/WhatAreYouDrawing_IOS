//
//  DrawViewController.swift
//  WhatAreYouDrawing
//
//  Created by Thushen Mohanarajah on 2021-06-16.
//

import UIKit
import SocketIO


class DrawViewController: UIViewController {


//    let manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(true), .compress])
    
    
 
    let canvas = Canvas()
    
//    Buttons
    let undobutton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Undo", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleUndoAction), for: .touchUpInside)
        return button
    }()
    
    let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Clear", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleClearAction), for: .touchUpInside)
        return button
    }()
    
    

    
    let blackButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleColourChange), for: .touchUpInside)
        return button
    }()
    
    
    let redButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .red
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleColourChange), for: .touchUpInside)
        return button
    }()
    
    let yellowButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .yellow
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleColourChange), for: .touchUpInside)
        return button
    }()
    
    let blueButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .blue
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleColourChange), for: .touchUpInside)
        return button
    }()
    
    let orangeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .orange
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleColourChange), for: .touchUpInside)
        return button
    }()
    
    let greenButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .green
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleColourChange), for: .touchUpInside)
        return button
    }()
    
    let purpleButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .purple
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleColourChange), for: .touchUpInside)
        return button
    }()
    
    
//    Slider
    
    let slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 10
        slider.addTarget(self, action: #selector(handleSelecterChange), for: .valueChanged)
        return slider
    }()
    
//    Actions for buttons and for Slider
    @objc fileprivate func handleUndoAction() {
        print("Undo")
        canvas.undo()
    }
    
    @objc fileprivate func handleClearAction() {
        print("Clear")
        canvas.clear()
    }
    
    @objc fileprivate func handleNextAction() {
        print("Undo")
        canvas.undo()
    }
    
    @objc fileprivate func handleColourChange (button: UIButton) {
        canvas.setStrokeColour(colour: button.backgroundColor ?? .black)
    }
    
    @objc fileprivate func handleSelecterChange (button: UIButton) {
        canvas.setStrokeWidth(width:CGFloat(slider.value))
        print(slider.value)
    }

    
    
    

    
    override func loadView() {
        self.view = canvas
    }
    

    
    fileprivate func setUpLayout() {
        
        let colourStackView = UIStackView(arrangedSubviews: [blackButton, redButton, yellowButton, blueButton, orangeButton, greenButton, purpleButton])
        
        colourStackView.distribution = .fillEqually
        
        let stackView = UIStackView(arrangedSubviews: [
            undobutton,
            colourStackView,
            
            slider,
            clearButton
        ])
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.addSubview(canvas)
//        canvas.frame = view.frame


        canvas.backgroundColor = .white
        
        
        setUpLayout()
        

        SocketIOManager.sharedInstance.mouseBeginRecieved(canvas: self.canvas)
        SocketIOManager.sharedInstance.mouseMoveRecieved(canvas: self.canvas)
        SocketIOManager.sharedInstance.mouseEndedRecieved(canvas: self.canvas)
        SocketIOManager.sharedInstance.clearRecieved(canvas: self.canvas)
    }



}

