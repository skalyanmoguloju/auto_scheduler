//
//  SuggestionListController.swift
//  auto_scheduler
//
//  Created by macbook_user on 11/1/16.
//
//

import UIKit

class SuggestionListController: UIViewController, SSRadioButtonControllerDelegate {
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    @IBOutlet weak var bDone: UIButton!
    var radioButtonController: SSRadioButtonsController?
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
         InitUI();
        
        radioButtonController = SSRadioButtonsController(buttons: button1, button2, button3)
        radioButtonController!.delegate = self
        radioButtonController!.shouldLetDeSelect = true
        
    }
    
    func InitUI(){
        
        InitLabel(oLabel: button1, color: UIColor(red: 168/255.0, green: 200/255.0, blue: 255/255.0, alpha: 0.8));
        
        
        InitLabel(oLabel: button2, color: UIColor(red: 168/255.0, green: 200/255.0, blue: 255/255.0, alpha: 0.8));
        
        
        InitLabel(oLabel: button3, color: UIColor(red: 168/255.0, green: 200/255.0, blue: 255/255.0, alpha: 0.8));
        
        
     InitLabel(oLabel: bDone, color: UIColor(red: 95/255.0, green: 186/255.0, blue: 125/255.0, alpha: 0.8));
    }
    
    func didSelectButton(aButton: UIButton?) {
        print(aButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func InitLabel(oLabel: UIView, color: UIColor){
        oLabel.layer.borderWidth = 2.0;
        oLabel.layer.cornerRadius = 8;
        oLabel.backgroundColor = color;
        oLabel.layer.masksToBounds = true;
    }
    
    @IBAction func GoToSuggestion(_ sender: UIButton) {
        performSegue(withIdentifier: "meetingSelected", sender: self)
    }
    
    
}

