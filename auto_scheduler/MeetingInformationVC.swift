//
//  MeetingInformationVC.swift
//  auto_scheduler
//
//  Created by macbook_user on 10/31/16.
//
//

import UIKit
import EventKit

class MeetingInformationVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
   
//    @IBOutlet weak var contact1: UILabel!
    @IBOutlet weak var Control: UISegmentedControl!
//    @IBOutlet weak var contact2: UILabel!
    
    @IBOutlet weak var Location: UILabel!
    @IBOutlet weak var meetingTitle: UILabel!
   var meetingName: [String] = []
    var events_complete_info: [EKEvent] = []
    var contactsAttending: [EKParticipant] = []
    
//    @IBOutlet weak var cancel: UIButton!
//    @IBOutlet weak var group_chat: UIButton!
    
//    @IBOutlet weak var done: UIButton!
    
    @IBAction func canmetgc(_ sender: AnyObject) {
        if Control.selectedSegmentIndex == 0{
            navigationController?.popViewController(animated: true)
           
            
        }
        if Control.selectedSegmentIndex == 1{
         
        }

    }
    
/*    func InitUI(){
        
        InitLabel(oLabel: group_chat, color: UIColor(red: 95/255.0, green: 186/255.0, blue: 125/255.0, alpha: 0.8));
        InitLabel(oLabel: cancel, color: UIColor(red: 95/255.0, green: 186/255.0, blue: 125/255.0, alpha: 0.8));
        
        
    }
    
    
    func InitLabel(oLabel: UIView, color: UIColor){
        oLabel.layer.borderWidth = 2.0;
        oLabel.layer.cornerRadius = 8;
        oLabel.backgroundColor = color;
        oLabel.layer.masksToBounds = true;
    }*/
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsAttending.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.flashScrollIndicators()
       
        let cell = UITableViewCell(style: .default, reuseIdentifier: "CELL")
        
        cell.textLabel!.text = String(describing: contactsAttending[indexPath.row])
        return cell
    }
    
/*    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
        cell.textLabel!.text = contactsAttending[indexPath.row]
        return cell

    }*/

    
    override func viewDidAppear(_ animated: Bool) {
    //    InitUI()
    meetingTitle.text! = events_complete_info[0].title
        
        
 //   contact1.text! = meetingName[1]
 //       contact2.text! = meetingName[2]
        Location.text! = events_complete_info[0].location!
        print(type(of:events_complete_info[0].attendees))
        print(events_complete_info[0].attendees)
        
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
       tableView.dataSource = self
//        contactsAttending.append(meetingName[1])
 //       contactsAttending.append(meetingName[2])
 /*       contactsAttending.append("A")
        contactsAttending.append("B")
        contactsAttending.append("C")
        contactsAttending.append("D")
        contactsAttending.append("E")
        contactsAttending.append("F")
        contactsAttending.append("G")
        contactsAttending.append("H")*/
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
