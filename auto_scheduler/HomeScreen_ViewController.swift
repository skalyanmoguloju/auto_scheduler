//
//  HomeScreen_ViewController.swift
//  auto_scheduler
//
//  Created by Sai on 11/2/16.
//
//

import UIKit
import EventKit
class HomeScreen_ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var locationIndexLabel: UILabel!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trainingConstraint: NSLayoutConstraint!
    @IBOutlet weak var needPermissionView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    var events_complete: [EKEvent] = []
    var calendars: [EKCalendar]?
    var Participant: [EKParticipant] = []
    let eventStore = EKEventStore()
    override func viewDidLoad() {
        checkCalendarAuthorizationStatus()
        super.viewDidLoad()
        mainView.layer.shadowOpacity = 1
        mainView.layer.shadowRadius = 10

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var mainView: UIView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    var menuOpen = false

    @IBAction func menuOpening(_ sender: UIButton) {
        if !menuOpen{
            leadingConstraint.constant = 125
            trainingConstraint.constant = -100
        }
        else
        {
            leadingConstraint.constant = 0
            trainingConstraint.constant = 0
            
        }
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.view.layoutIfNeeded()
        })
        menuOpen = !menuOpen
    }
    
    
    //Callender
    override func viewWillAppear(_ animated: Bool) {
    //    checkCalendarAuthorizationStatus()
        /*
        let urlString = "http://192.168.0.27:3000/users/test";
        //let urlString = "https://arcane-bayou-92592.herokuapp.com/users/test";
        
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print(error)
            } else {
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any];
                    print(parsedData);
                    
                } catch let error as NSError {
                    print(error)
                }
            }
            
            }.resume()
 */
        
    }
    func checkCalendarAuthorizationStatus() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            // This happens on first-run
            requestAccessToCalendar()
        case EKAuthorizationStatus.authorized:
            // Things are in line with being able to show the calendars in the table view
           self.loadCalendars()
          
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            // We need to help them give us permission
            needPermissionView.fadeIn()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if(segue.identifier == "meetingInfo"){
           let dest = segue.destination as! MeetingInformationVC
            dest.events_complete_info = meetingSelected
        }
    }
    
    func enterPhoneNumber(){
        let alert = UIAlertController(title: "Enter your phone number", message: "10 digit phone number", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = ""
            textField.keyboardType = UIKeyboardType.numberPad
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            let countValue = textField!.text?.characters.count
      //      print(countValue)
            if (countValue! != 10){
       //         print("Inside this")
                let alert1 = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
                alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                        self.enterPhoneNumber()
                    }))
                self.present(alert1, animated: true, completion: nil)
            }
            print("Text field: \(countValue)");
            DataService.insert_user(number: (textField?.text)!);
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func requestAccessToCalendar() {
        eventStore.requestAccess(to: EKEntityType.event, completion: {
            (accessGranted: Bool, error: Error?) in
            if accessGranted == true {
                DispatchQueue.main.async(execute: {
                    self.enterPhoneNumber()
                    self.loadCalendars()
                })
            } else {
                DispatchQueue.main.async(execute: {
                    self.needPermissionView.fadeIn()
                })
            }
        })
        
    }
    var titles : [String] = []
    var startDates : [NSDate] = []
    var endDates : [NSDate] = []
    
    func loadCalendars(){
   //     print("function called")
        self.calendars = eventStore.calendars(for: EKEntityType.event)
        for calendar in self.calendars!{
            let oneMonthAgo = NSDate(timeIntervalSinceNow: 0*24*3600)
            let oneMonthAfter = NSDate(timeIntervalSinceNow: +30*24*3600)
            let predicate = eventStore.predicateForEvents(withStart: oneMonthAgo as Date, end: oneMonthAfter as Date, calendars: [calendar])
            let events = eventStore.events(matching: predicate)
            for event in events {
                events_complete.append(event)
    //            print(type(of:event.attendees))
    //            print("------------------------------------------------------------")
            }
        }
        events_complete = events_complete.sorted(by: { $1.startDate > $0.startDate })
    }
    
 /*   func loadCalendars() {
        print("Load Calendar function called")
        sortCalendarEvents()
        self.calendars = eventStore.calendars(for: EKEntityType.event)
      //  print(type(of: self.calendars))
        for calendar in self.calendars! {
       //     print(calendar.title)
            let oneMonthAgo = NSDate(timeIntervalSinceNow: 0*24*3600)
            let oneMonthAfter = NSDate(timeIntervalSinceNow: +30*24*3600)
            
            let predicate = eventStore.predicateForEvents(withStart: oneMonthAgo as Date, end: oneMonthAfter as Date, calendars: [calendar])
            let events = eventStore.events(matching: predicate)
            
            events.sorted(by: { $1.startDate > $0.startDate })
  //          print (type(of: events))
    //        print(events)
            for event in events {
                events_complete.append(event)
         //       print(event.location)
         //       print(event.title)
         //       print(event.startDate as NSDate)
                         //       print(events)
         //       print(event.startDate as NSDate)
        //        print(event.endDate as NSDate)
                
                titles.append(event.title)
                startDates.append(event.startDate as NSDate)
                endDates.append(event.endDate as NSDate)
            }
          //  print("This should sort this mess")
            for event1 in events{
          //      print(event1.startDate as NSDate)
                
            }
        }

    }
    
    
    var item = ["Meeting 1", "Meeting 2","Meeting3","Meeting 4","Meeting 1", "Meeting 2","Meeting3","Meeting 4","Meeting 1", "Meeting 2","Meeting3","Meeting 4"]
    var meetingInformation: [String] = []
    
    var meeting1_detail: [String] = []
    var meeting2_detail: [String] = []*/
    
    
    var meetingSelected: [EKEvent] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.events_complete.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let dateformatter = DateFormatter()
        
        dateformatter.dateFormat = "MM/dd/yy h:mm a Z"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.titleLabel!.text = self.events_complete[(indexPath as IndexPath).row].title
    
        cell.locationLabel!.text = self.events_complete[(indexPath as IndexPath).row].location
        cell.timeLabel!.text = dateformatter.string(from: self.events_complete[(indexPath as IndexPath).row].startDate)
//        print(cell.titleLabel!.text)
//        print(cell.locationLabel!.text)
 //       print(cell.timeLabel!.text)
        switch indexPath[1]%4 {
        case 0:
            cell.backgroundColor = UIColor.darkGray
            break
        case 1:
            cell.backgroundColor = UIColor.cyan
            break
        case 2:
            cell.backgroundColor = UIColor.gray
            break;
        case 3:
            cell.backgroundColor = UIColor.magenta
            break
        default:
            cell.backgroundColor = UIColor.white
            break
        }
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
      //      print("Inside 1st click")
    //    for eve in events_complete{
      //      print (eve.title)
    //    }
   //     print(indexPath)
        meetingSelected = [self.events_complete[(indexPath as IndexPath).row]]
    //    print(meetingSelected[0].title)
    //    print(meetingSelected[0].location)
        
            self.performSegue(withIdentifier: "meetingInfo", sender: self)
            
        
       
      //      print(self.events_complete[(indexPath as IndexPath).row])
    //        meetingSelected = meeting2_detail
        
        
    }

    
    
    
    
    
    
}
