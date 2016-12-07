//
//  meetingRequestVC.swift
//  auto_scheduler
//
//  Created by macbook_user on 12/5/16.
//
//

import Foundation

import UIKit
import EventKit
class meetingRequestVC: UIViewController,  UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet var tableView: UITableView!
    
    var meetingInfoLst = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetingInfoLst.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as! MeetingViewCell
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "CELL")
        cell.ownerName.text = meetingInfoLst[(indexPath as NSIndexPath).row].components(separatedBy: "||")[0]
        cell.Location.text = meetingInfoLst[(indexPath as NSIndexPath).row].components(separatedBy: "||")[1]
        cell.meetingId = meetingInfoLst[(indexPath as NSIndexPath).row].components(separatedBy: "||")[2]
        cell.titleName.text = meetingInfoLst[(indexPath as NSIndexPath).row].components(separatedBy: "||")[3]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(meetingInfoLst[(indexPath as NSIndexPath).row].components(separatedBy: "||")[2])
        let defaults = UserDefaults.standard
        defaults.set(meetingInfoLst[(indexPath as NSIndexPath).row].components(separatedBy: "||")[2], forKey: "suggestedMeetingId")
        self.performSegue(withIdentifier: "showsuggestions", sender: self)
        

        
    }
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let defaults = UserDefaults.standard;
        var loggedInUser = defaults.value(forKey: "loggedInUser") as! String;
        DataService.GetRequests(meetingRequests: self, nUserNumber: loggedInUser)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }

}
