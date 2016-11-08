//
//  SuggestionListController.swift
//  auto_scheduler
//
//  Created by macbook_user on 11/1/16.
//
//

import UIKit

class SuggestionListController: UIViewController, SSRadioButtonControllerDelegate {
    
    var arrButtons = [UIButton]()
    
    @IBOutlet weak var bDone: UIButton!
    var radioButtonController: SSRadioButtonsController?
    
    override func viewDidLoad() {
        super.viewDidLoad();
        InitUI();
    }
    
    func InitUI(){
        //customLabel?.InitLabel(oLabel: button1, color: UIColor(red: 168/255.0, green: 200/255.0, blue: 255/255.0, alpha: 0.8));
        
        //InitLabel(oLabel: button1, color: UIColor(red: 168/255.0, green: 200/255.0, blue: 255/255.0, alpha: 0.8));
        
        /*
         customLabel?.InitLabel(oLabel: button2, color: UIColor(red: 168/255.0, green: 200/255.0, blue: 255/255.0, alpha: 0.8));
         
         
         customLabel?.InitLabel(oLabel: button3, color: UIColor(red: 168/255.0, green: 200/255.0, blue: 255/255.0, alpha: 0.8));
         
         
         customLabel?.InitLabel(oLabel: bDone, color: UIColor(red: 95/255.0, green: 186/255.0, blue: 125/255.0, alpha: 0.8));
         */
        /*
         let button = CustomButton(withValue: UIColor(red: 168/255.0, green: 200/255.0, blue: 255/255.0, alpha: 0.8));
         button.setTitle("Hello", for: UIControlState.normal);
         // auto layout
         button.translatesAutoresizingMaskIntoConstraints = false
         view.addSubview(button)
         button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
         button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
         
         */
        AddButtons();
        radioButtonController = SSRadioButtonsController(buttons: arrButtons);
        radioButtonController!.delegate = self;
        radioButtonController!.shouldLetDeSelect = true;
    }
    
    
    
    func AddButtons(){
        let width: CGFloat = 200.0;
        let height: CGFloat = 25.0;
        let getMainViewX = view.center.x - width/2;
        let getMainViewY = view.center.y - 100;
        
        for var i in 0 ..< 5
        {
            //let oButton = CustomButton(withValue: UIColor(red: 168/255.0, green: 200/255.0, blue: 255/255.0, alpha: 0.8),
            //frame: CGRect(x: getMainViewX, y: CGFloat(i) * 21, width: 200, height: 21));
            /*
             
             let oButton = UIButton(frame: CGRect(x: getMainViewX, y: CGFloat(i) * 21, width: 200, height: 21));
             //oButton.center = CGPoint(x: getMainViewX, y: getMainViewY);
             //oButton.textAlignment = .center;
             oButton.setTitle("I'am a test label: " + String(i), for: UIControlState.normal);
             self.view.addSubview(oButton);
             
             */
            
            //let button = UIButton(frame: CGRect(x: getMainViewX, y: CGFloat(i) * height + 5.0, width: width, height: height));
            let button = SSRadioButton(withValue: UIColor(red: 168/255.0, green: 200/255.0, blue: 255/255.0, alpha: 0.5),
                                       frame: CGRect(x: getMainViewX, y: (CGFloat(i) * (height + 5.0)) + getMainViewY, width: width, height: height));
            button.setTitle("Test Button: " + String(i), for: .normal);
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside);
            self.view.addSubview(button);
            arrButtons.append(button);
        }
    }
    
    func buttonAction(sender: UIButton!) {
        print("Button tapped")
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
