//
//  ViewController.swift
//  Magic 8 Ball
//
//  Created by Brian Durham on 4/4/19.
//  Copyright © 2019 Brian Durham. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ballImageView: UIImageView!
    
    var randomBallNumber : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateBallFace()
    }

    @IBAction func askButtonPressed(_ sender: UIButton) {
        updateBallFace()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        updateBallFace()
    }
    
    func updateBallFace(){
        randomBallNumber  = Int.random(in: 1 ... 5)
        ballImageView.image = UIImage(named: "ball\(randomBallNumber)")
    }
    
}

