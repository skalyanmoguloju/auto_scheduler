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

    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var trainingConstraint: NSLayoutConstraint!
    @IBOutlet weak var needPermissionView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var calendars: [EKCalendar]?

    
    let eventStore = EKEventStore()
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.layer.shadowOpacity = 1
        mainView.layer.shadowRadius = 10

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var mainView: UIView!
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
        checkCalendarAuthorizationStatus()
    }
    func checkCalendarAuthorizationStatus() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            // This happens on first-run
            requestAccessToCalendar()
        case EKAuthorizationStatus.authorized:
            // Things are in line with being able to show the calendars in the table view
            loadCalendars()
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            // We need to help them give us permission
            needPermissionView.fadeIn()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if(segue.identifier == "meetingInfo"){
            
            print("Correct Segue is identified")
            
           let dest = segue.destination as! MeetingInformationVC
            dest.events_complete_info = meetingSelected
            
        }
        
    }
    
    func requestAccessToCalendar() {
        eventStore.requestAccess(to: EKEntityType.event, completion: {
            (accessGranted: Bool, error: Error?) in
            
            if accessGranted == true {
                DispatchQueue.main.async(execute: {
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
    
    var events_complete: [EKEvent] = []
    
    func loadCalendars() {
        self.calendars = eventStore.calendars(for: EKEntityType.event)
        print(self.calendars)
        for calendar in self.calendars! {
            let oneMonthAgo = NSDate(timeIntervalSinceNow: 0*24*3600)
            let oneMonthAfter = NSDate(timeIntervalSinceNow: +30*24*3600)
                
            let predicate = eventStore.predicateForEvents(withStart: oneMonthAgo as Date, end: oneMonthAfter as Date, calendars: [calendar])
            
            let events = eventStore.events(matching: predicate)
                
            for event in events {
                events_complete.append(event)
                print(event.location)
                print(event.title)
                print(event.startDate as NSDate)
                print(event.endDate as NSDate)
                
                titles.append(event.title)
                startDates.append(event.startDate as NSDate)
                endDates.append(event.endDate as NSDate)
            }
        }

    }
    
    
    var item = ["Meeting 1", "Meeting 2","Meeting3","Meeting 4","Meeting 1", "Meeting 2","Meeting3","Meeting 4","Meeting 1", "Meeting 2","Meeting3","Meeting 4"]
    var meetingInformation: [String] = []
    var meetingSelected: [EKEvent] = []
    var meeting1_detail: [String] = []
    var meeting2_detail: [String] = []
    
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
        
            print("Inside 1st click")
        meetingSelected = [self.events_complete[(indexPath as IndexPath).row]]
        print(meetingSelected[0].title)
            self.performSegue(withIdentifier: "meetingInfo", sender: self)
            
        
       
            print(self.events_complete[(indexPath as IndexPath).row])
    //        meetingSelected = meeting2_detail
        
        
    }

    
    
    
    
    
    
}
