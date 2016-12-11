//
//  MeetingInformationVC.swift
//  auto_scheduler
//
//  Created by macbook_user on 10/31/16.
//
//

import UIKit
import EventKit
import MapKit
import CoreLocation

class MeetingInformationVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    //    @IBOutlet weak var contact1: UILabel!
    @IBOutlet weak var Control: UISegmentedControl!
    //    @IBOutlet weak var contact2: UILabel!
    
    @IBOutlet weak var Location: UILabel!
    @IBOutlet weak var meetingTitle: UILabel!
    var meetingName: [String] = []
    var events_complete_info: [EKEvent] = []
    var contactsAttending: [EKParticipant] = []
    var geocoder = CLGeocoder()
    let regionRadius: CLLocationDistance = 1000
    var initialLocation = CLLocation(latitude: 41.8781, longitude: -87.6298)
    
    @IBAction func canmetgc(_ sender: AnyObject) {
        if Control.selectedSegmentIndex == 0{
            navigationController?.popViewController(animated: true)
            
        }
        if Control.selectedSegmentIndex == 1{
            
        }
        
    }
    
 /*   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsAttending.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.flashScrollIndicators()
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "CELL")
        
        cell.textLabel!.text = String(describing: contactsAttending[indexPath.row])
        return cell
    }
    */
    
    override func viewDidAppear(_ animated: Bool) {
        //    InitUI()
        
        meetingTitle.text! = events_complete_info[0].title
        //contactsAttending = events_complete_info[0].attendees!
        
        
        
        //   contact1.text! = meetingName[1]
        //       contact2.text! = meetingName[2]
        Location.text! = events_complete_info[0].location!
        showLocationOnMap()
        //  print("Is it working")
        //     print(self.initialLocation)
        //        centerMapOnLocation(location: self.initialLocation)
        
        
        
        //      print(type(of:events_complete_info[0].attendees))
        //      print(events_complete_info[0].attendees)
        
        
        
    }
    
    func showLocationOnMap(){
        print("SHOW LOCATION FUNCTION CALLED")
        var address = String(events_complete_info[0].location!)
        //    var initialLocationCoordinates = CLLocationCoordinate2D(latitude: 21.282778, longitude: -157.829444)
        geocoder.geocodeAddressString(address!, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                //            print("Error", error)
            }
            if let placemark = placemarks?.first {
                let dropPin = MKPointAnnotation()
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                self.initialLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
                print("--------------location---------")
                print(self.initialLocation.coordinate)
                dropPin.coordinate = self.initialLocation.coordinate
                self.mapView.addAnnotation(dropPin)
                let coordinateRegion = MKCoordinateRegionMakeWithDistance(self.initialLocation.coordinate,self.regionRadius * 2.0, self.regionRadius * 2.0)
                self.mapView.setRegion(coordinateRegion, animated: true)
            }
        })
        
        
        
    }
    
    
    /*    func centerMapOnLocation(location: CLLocation) {
     let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius * 2.0, regionRadius * 2.0)
     mapView.setRegion(coordinateRegion, animated: true)
     }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
   //     tableView.delegate = self
   //     tableView.dataSource = self
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
        super.didReceiveMemoryWarning();
    }
}
