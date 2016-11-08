//
//  MeetingRequestController.swift
//  auto_scheduler
//
//  Created by macbook_user on 11/1/16.
//
//

import UIKit


class MeetingRequest_VC: UIViewController {
    
    @IBOutlet weak var bDone: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        InitUI();
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func InitUI(){
        InitLabel(oLabel: bDone, color: UIColor(red: 95/255.0, green: 186/255.0, blue: 125/255.0, alpha: 0.8));
    }
    
    
    func InitLabel(oLabel: UIView, color: UIColor){
        oLabel.layer.borderWidth = 2.0;
        oLabel.layer.cornerRadius = 8;
        oLabel.backgroundColor = color;
        oLabel.layer.masksToBounds = true;
    }
    
    @IBAction func GoToSuggestion(_ sender: UIButton) {
        performSegue(withIdentifier: "meetingSelectedUser", sender: self)
    }
    
}
