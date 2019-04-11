//
//  ViewController.swift
//  Destini
//
//  Created by Philipp Muellauer on 01/09/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let stories = StoryBank()
    
    // UI Elements linked to the storyboard
    @IBOutlet weak var topButton: UIButton!         // Has TAG = 1
    @IBOutlet weak var bottomButton: UIButton!      // Has TAG = 2
    @IBOutlet weak var storyTextView: UILabel!
    @IBOutlet weak var restartButton: UIButton!
    
    // TODO Step 5: Initialise instance variables here
    var currentStory : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    
    // User presses one of the buttons
    @IBAction func buttonPressed(_ sender: UIButton) {
        goToNextStory(tagIn: sender.tag)
                
        // TODO Step 6: Modify the IF-Statement to complete the story
        
    
    }
    
    func goToNextStory(tagIn: Int){
        if currentStory == 0{
            if tagIn == 1 {
                currentStory = 2
            }
            else {
                currentStory = 1
            }
        }
        else if currentStory == 1 {
            if tagIn == 1 {
                currentStory = 2
            }
            else {
                currentStory = 3
            }
        }
        else if currentStory == 2 {
            if tagIn == 1 {
                currentStory = 5
            }
            else {
                currentStory = 4
            }
        }
        updateUI()
    }
    
    func updateUI(){
        storyTextView.text = stories.storyList[currentStory].story
        topButton.setTitle(stories.storyList[currentStory].answerA, for: .normal)
        bottomButton.setTitle(stories.storyList[currentStory].answerB, for: .normal)
        if currentStory == 3 || currentStory == 4 || currentStory == 5 {
            topButton.isHidden = true
            bottomButton.isHidden = true
            restartButton.isHidden = false
        }
        else{
            restartButton.isHidden = true
            topButton.isHidden = false
            bottomButton.isHidden = false
        }
    }

    @IBAction func restartPressed(_ sender: UIButton) {
        currentStory = 0
        updateUI()
    }
    

}

