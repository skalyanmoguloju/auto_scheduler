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

    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    @IBAction func rejectMeeting(_ sender: UIButton) {
        let defaults = UserDefaults.standard;
        let meetingId = defaults.value(forKey: "suggestedMeetingId") as! String
        var loggedInUser = defaults.value(forKey: "loggedInUser") as! String;
        
        DataService.RejectMeeting(Slvc: self, nUserNumber: loggedInUser,meetingId: meetingId);
    }
    @IBOutlet weak var durationLabel: UILabel!
    @IBAction func submitPref(_ sender: Any) {
        
        //post request to node by sending startDateFinal endDateFinal meeting id and his unique id
        
        let defaults = UserDefaults.standard;
        let meetingId = defaults.value(forKey: "suggestedMeetingId") as! String
        var loggedInUser = defaults.value(forKey: "loggedInUser") as! String;
        
        DataService.SetPriorities(Slvc: self, nUserNumber: loggedInUser, nMeetingId: meetingId, arrStartDateFinal: startDateFinal, arrEndDateFinal: endDateFinal, arrRanks: ranks)
        
    }
    
    func onSetPrioritiesComplete(){
        let alert = UIAlertController(title: "Alert", message: "Your priorities added succesfully.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            self.performSegue(withIdentifier: "prioritiesBack2Home", sender: self)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func onMeetingRejectedComplete(){
        let alert = UIAlertController(title: "Alert", message: "Meeting rejected succesfully.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            self.performSegue(withIdentifier: "prioritiesBack2Home", sender: self)
        }))
        self.present(alert, animated: true, completion: nil)
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
        let meetingId = defaults.value(forKey: "suggestedMeetingId") as! String;
        
        DataService.GetSuggestions(suggestionRequests: self, meetingId: meetingId);
        
        let dDateFormatter2 = DateFormatter()
        dDateFormatter2.dateFormat = "YYYY-MM-dd HH:mm";
     //   startDate.append(dDateFormatter2.date(from: s1[1].replacingOccurrences(of: "T", with: " ", options: .literal, range: nil).replacingOccurrences(of: ":00.000Z\"", with: "", options: .literal, range: nil))!)
        
        //let defaults = UserDefaults.standard;
        
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
        
        Selected.append(String(describing: startDate[indexPath[1]]))
        startDateFinal.append(startDate[(indexPath as NSIndexPath).row])
        endDateFinal.append(endDate[(indexPath as NSIndexPath).row])
        
        if(Selected.count == 1)
        {
            first.text=(String(describing: startDate[(indexPath as NSIndexPath).row]))
            ranks.append(1)
        }
        else if(Selected.count==2)
        {
            ranks.append(2)
            second.text=(String(describing: startDate[(indexPath as NSIndexPath).row]))
        }
        else if(Selected.count == 3)
        {
            ranks.append(3)
            third.text=(String(describing: startDate[(indexPath as NSIndexPath).row]))
        }
    
        print(Selected)
    }
    
    
}
