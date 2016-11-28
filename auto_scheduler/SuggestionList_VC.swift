//
//  SuggestionListController.swift
//  auto_scheduler
//
//  Created by macbook_user on 11/1/16.
//
//

import UIKit

class SuggestionListController: UIViewController,  UITableViewDataSource, UITableViewDelegate {
    
    var userString = ""
    var Data = ["A","B","C","D","E"]
    var Selected: [String] = []
    var startDate = [Date]()
    var endDate = [Date]()
    var startDateFinal = [Date]()
    var endDateFinal = [Date]()
    var ranks = [Int]()

    
    @IBAction func submitPref(_ sender: Any) {
        
        //post request to node by sending startDateFinal endDateFinal meeting id and his unique id
        
        let defaults = UserDefaults.standard;
        let meetingId = defaults.value(forKey: "suggestedTimes1MeetingId") as! String
        //let meetingId = "41";
        var loggedInUser = defaults.value(forKey: "loggedInUser") as! String;
        
        DataService.SetPriorities(nUserNumber: loggedInUser, nMeetingId: meetingId, arrStartDateFinal: startDateFinal, arrEndDateFinal: endDateFinal, arrRanks: ranks)
        
    }
    @IBOutlet weak var tableView: UITableView!
 //   var arrButtons = [UIButton]()
    
    @IBOutlet weak var bDone: UIButton!
    @IBOutlet weak var third: UILabel!
    @IBOutlet weak var second: UILabel!
    @IBOutlet weak var first: UILabel!
 //   var radioButtonController: SSRadioButtonsController?
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.allowsMultipleSelection = true;
        super.viewDidLoad();
        let defaults = UserDefaults.standard;
        userString = defaults.value(forKey: "suggestedTimes") as! String
        userString = userString.substring(to: userString.index(before: userString.endIndex))
        userString = userString.substring(to: userString.index(before: userString.endIndex))
        let fullNameArr : [String] = userString.components(separatedBy: "},{")
        let dDateFormatter2 = DateFormatter()
        dDateFormatter2.dateFormat = "YYYY-MM-dd HH:mm";
        for val in fullNameArr
        {
            let n : [String] = val.components(separatedBy: ",")
            let s1 = n[0].components(separatedBy: "\":\"")
            
            startDate.append(dDateFormatter2.date(from: s1[1].replacingOccurrences(of: "T", with: " ", options: .literal, range: nil).replacingOccurrences(of: ":00.000Z\"", with: "", options: .literal, range: nil))!)
            
            let e1 = n[1].components(separatedBy: "\":\"")
            
            endDate.append(dDateFormatter2.date(from: e1[1].replacingOccurrences(of: "T", with: " ", options: .literal, range: nil).replacingOccurrences(of: ":00.000Z\"", with: "", options: .literal, range: nil))!)
            
            print("-------")
        }
        InitUI();
    }
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return startDate.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.flashScrollIndicators()
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "CELL")
        
        cell.textLabel!.text = String(describing: startDate[indexPath.row])
      //  print(indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath[1])
        
        Selected.append(String(describing: startDate[indexPath[1]]))
        startDateFinal.append(startDate[indexPath[1]])
        endDateFinal.append(endDate[indexPath[1]])
        
        if(Selected.count == 1)
        {
            first.text=(String(describing: startDate[indexPath[1]]))
            ranks.append(1)
        }
        else if(Selected.count==2)
        {
            ranks.append(2)
            second.text=(String(describing: startDate[indexPath[1]]))
        }
        else if(Selected.count == 3)
        {
            ranks.append(3)
            third.text=(String(describing: startDate[indexPath[1]]))
        }
    
        print(Selected)
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
    /*    AddButtons();
        radioButtonController = SSRadioButtonsController(buttons: arrButtons);
        radioButtonController!.delegate = self;
        radioButtonController!.shouldLetDeSelect = true;
    }*/
    
    
    
  /*  func AddButtons(){
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
    }*/
    
    func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  /*  func InitLabel(oLabel: UIView, color: UIColor){
        oLabel.layer.borderWidth = 2.0;
        oLabel.layer.cornerRadius = 8;
        oLabel.backgroundColor = color;
        oLabel.layer.masksToBounds = true;
    }
    
    @IBAction func GoToSuggestion(_ sender: UIButton) {
        performSegue(withIdentifier: "meetingSelected", sender: self)
    }*/
    }
}
