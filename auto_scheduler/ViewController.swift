//
//  ViewController.swift
//  auto_scheduler
//
//  Created by macbook_user on 10/24/16.
//
//

import UIKit
import QuartzCore

class ViewController: UIViewController {

    @IBOutlet weak var dFromDateLabel: UILabel!
    @IBOutlet weak var dToDateLabel: UILabel!
    @IBOutlet weak var bScheduleButton: UIButton!

    var dateFormatter : DateFormatter!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        InitUI();
        
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd YYYY hh:mm a";
    }
    
    func InitLabel(oLabel: UIView, color: UIColor){
        oLabel.layer.borderWidth = 2.0;
        oLabel.layer.cornerRadius = 8;
        oLabel.backgroundColor = color;
        oLabel.layer.masksToBounds = true;
    }
    
    func InitUI(){
        // Label part
        InitLabel(oLabel: dFromDateLabel, color: UIColor.gray);
        InitLabel(oLabel: dToDateLabel, color: UIColor.gray);
        
        InitLabel(oLabel: bScheduleButton, color: UIColor(red: 95/255.0, green: 186/255.0, blue: 125/255.0, alpha: 0.8));
        
        //Datepicker part
        let screenWidth = self.view.frame.width;
        let screenHeight = self.view.frame.height/2;
        let centerX = self.view.center.x - screenWidth/2 + 50;
        let centerY = self.view.center.y - screenHeight/2 - 130;
        
        let datePicker : UIDatePicker = UIDatePicker(frame: CGRect(origin: CGPoint(x: centerX,y :centerY), size: CGSize(width: screenWidth, height: screenHeight)))
        datePicker.datePickerMode = UIDatePickerMode.dateAndTime
        self.view.addSubview(datePicker)
        datePicker.addTarget(self, action: #selector(ViewController.date_picker_change_action), for: UIControlEvents.valueChanged)
    }
    
    @IBAction func date_picker_change_action(sender : UIDatePicker)
    {
        
        //show date label in text
        
        dFromDateLabel.text = dateFormatter.string(from: sender.date)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if(segue.identifier == "GoToSuggestion"){
            
            //let dest = segue.destination as! SuggestionListController;
            
        }
        
    }
    
    @IBAction func GoToSuggestion(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToSuggestion", sender: self)
    }
    
    
    
}

