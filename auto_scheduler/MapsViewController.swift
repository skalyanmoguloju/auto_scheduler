import UIKit
import GooglePlaces
import EventKit

class MapsViewController: UIViewController, UITextFieldDelegate {
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    let defaults = UserDefaults.standard
    var resultView: UITextView?
    var dateFormatter : DateFormatter!
    var dateFormatter1 : DateFormatter!
    
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var dateTextEndField: UITextField!
    
    var dateStart: Date?
    var dateEnd: Date?
    
    @IBOutlet weak var durationTextField: UITextField!
    
    
    @IBAction func scheduleFinal(_ sender: Any) {
        
        if var contacts =  defaults.stringArray(forKey: "participants")
        {
            
            //
            
            let loggedInUser = defaults.value(forKey: "loggedInUser") as! String;
            
            for i in 0 ..< contacts.count  {
                var s = contacts[i];
                s = s.replacingOccurrences(of:
                    "\\D", with: "", options: .regularExpression,
                           range: s.startIndex..<s.endIndex);
                s = s.substring(from:s.index(s.endIndex, offsetBy: -10))
                contacts[i] = s;
            }
            
            DataService.InitiateMeeting(mapsInstance: self, contacts: contacts, loggedInUser: loggedInUser, location: locationLabel.text!, startTime: dateTextField.text!, endTime: dateTextEndField.text!, duration: durationTextField.text!);
            
            /*
             let alert = UIAlertController(title: "Enter your phone number", message: "10 digit phone number", preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
             //let secondViewController:HomeScreen_ViewController = HomeScreen_ViewController()
             //self.present(secondViewController, animated: true, completion: nil)
             
             if let vc3 = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeScreen_ViewController {
             let appDelegate = UIApplication.shared.delegate as! AppDelegate
             appDelegate.window?.rootViewController!.present(vc3, animated: true, completion: nil)
             }
             
             
             }))
             self.present(alert, animated: true, completion: nil)
             */
            
            
            
        }
    }
    @IBOutlet weak var locationLabel: UILabel!

   
    
    let datePicker = UIDatePicker()
    let datePickerEnd = UIDatePicker()
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.bordered, target: self, action: Selector(("donePicker")))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        
        toolBar.setItems([spaceButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        textField.inputAccessoryView = toolBar
        
        if textField.placeholder == "End Date & Time" {
            self.datePickerEnd.minimumDate = NSDate() as Date
            self.datePickerEnd.minuteInterval = 30
            textField.inputView = self.datePickerEnd
            self.datePickerEnd.addTarget(self, action: #selector(MapsViewController.datePickerValueChangedEnd), for: UIControlEvents.valueChanged)
            
        }
        else if(textField.placeholder == "Start Date & Time"){
            self.datePicker.minimumDate = NSDate() as Date
            self.datePicker.minuteInterval = 30
            textField.inputView = self.datePicker
            
            self.datePicker.addTarget(self, action: #selector(MapsViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        }
    }
    
    
    
    static func getFreeTime(meetingId: Int, strtDate: Date?, endDate: Date?)
    {
        let eventStore = EKEventStore();
        var oCalendars: [EKCalendar]?
        var dDateFormatter : DateFormatter!
        var dDateFormatter1 : DateFormatter!
        var strts = [String]()
        var ends = [String]()
        
        var sDate = strtDate;
        oCalendars = eventStore.calendars(for: EKEntityType.event)
        dDateFormatter = DateFormatter()
        dDateFormatter.dateFormat = "HH";
        dDateFormatter1 = DateFormatter()
        dDateFormatter1.dateFormat = "MMMM dd YYYY hh:mm a";
        let dates = 3600
        var f = true
        while(sDate!<endDate! )
        {
            
            for calendar in oCalendars!
            {
                let predicate = eventStore.predicateForEvents(withStart: sDate! as Date, end: (sDate! as Date)+TimeInterval(dates), calendars: [calendar])
                
                let events = eventStore.events(matching: predicate)
                
                if(events.count == 0 && Int(dDateFormatter.string(from: sDate!))! >= 7 && Int(dDateFormatter.string(from: sDate!+TimeInterval(dates)))! <= 21)
                {
                    
                }
                else{
                    f = false
                    break
                }
                
            }
            if(f)
            {
                strts.append(dDateFormatter1.string(from: sDate!))
                ends.append(dDateFormatter1.string(from: sDate!+TimeInterval(dates)))
            }
            f = true;
            sDate = sDate?.addingTimeInterval(TimeInterval(dates));
        }
        let userDefaults = UserDefaults.standard;
        var loggedInUser = userDefaults.value(forKey: "loggedInUser") as! String;
        DataService.SendAvailabilities(strts: strts, ends: ends, meetingId: meetingId, loggedInUser: loggedInUser);
    }
    
    func donePicker()
    {
        dateTextField.resignFirstResponder()
        dateTextEndField.resignFirstResponder()
    }
    
    func datePickerValueChangedEnd(sender:UIDatePicker) {
        
        dateTextEndField.text = dateFormatter.string(from: sender.date)
        dateEnd = sender.date
        
    }
    
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        dateTextField.text = dateFormatter.string(from: sender.date)
        dateStart = sender.date
    }
    
    
    @IBAction func nextFromLocation(_ sender: UIButton) {
        
        dismiss(animated: false, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        durationTextField.keyboardType = UIKeyboardType.numberPad;
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd YYYY hh:mm a";
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        GMSPlacesClient.provideAPIKey("AIzaSyDhYKzloCkhWrY7hqKtZZdvqmuU5i69zas")
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        let subView = UIView(frame: CGRect(x: 0, y: 63, width: 415, height: 300))
        
        subView.addSubview((searchController?.searchBar)!)
        self.view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        self.definesPresentationContext = true
    }
    
}
    // Handle the user's selection.
    extension MapsViewController: GMSAutocompleteResultsViewControllerDelegate {
        func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                               didAutocompleteWith place: GMSPlace) {
            searchController?.isActive = false
            // Do something with the selected place.
            print("Place name: ", place.name)
            print("Place address: ", place.formattedAddress)
            print("Place attributions: ", place.attributions)
            
            locationLabel.text = place.formattedAddress
        }
        
        func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                               didFailAutocompleteWithError error: Error){
            // TODO: handle the error.
            print(error)
        }
        
        // Turn the network activity indicator on and off again.
        func didRequestAutocompletePredictionsForResultsController(resultsController: GMSAutocompleteResultsViewController) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        func didUpdateAutocompletePredictionsForResultsController(resultsController: GMSAutocompleteResultsViewController) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }

