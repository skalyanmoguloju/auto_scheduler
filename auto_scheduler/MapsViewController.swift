import UIKit
import GooglePlaces
import EventKit

class MapsViewController: UIViewController, UITextFieldDelegate {
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    let defaults = UserDefaults.standard
    var resultView: UITextView?
    var calendars: [EKCalendar]?
    let eventStore = EKEventStore()
    
    @IBAction func backButton(_ sender: UIButton) {
         dismiss(animated: false, completion: nil)
    }
    var dateFormatter : DateFormatter!
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var dateTextEndField: UITextField!
    
    var dateStart: Date?
    var dateEnd: Date?
    

    @IBOutlet weak var durationTextField: UITextField!
    
    @IBOutlet weak var locationLabel: UILabel!

    @IBAction func schedule(_ sender: Any) {
        
        if var contacts =  defaults.stringArray(forKey: "participants")
        {
        
            getFreeTime()
//            do{
//                var f = false
//                var request = URLRequest(url: NSURL(string: "http://192.168.0.27:3000/users/initiatemeeting") as! URL)
//                request.httpMethod = "POST"
//                //var params = ["username":"jameson", "password":"password"] as Dictionary<String, String>
//                let array = ["owner": "3199309832","participants":contacts, "location": locationLabel.text, "starttime" : dateTextField.text,
//                             "endtime": dateTextEndField.text, "duration":durationTextField.text] as [String : Any]
//                request.httpBody = try JSONSerialization.data(withJSONObject: array, options: JSONSerialization.WritingOptions.prettyPrinted)
//            
//            
//                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//                request.addValue("application/json", forHTTPHeaderField: "Accept")
//            
//                URLSession.shared.dataTask(with: request){ (data, response, error) in
//                    if error != nil {
//                        print(error)
//                    } else {
//                        do {
//                            let parsedData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject];
//                                print(parsedData)
//                        }
//                        catch let error as NSError {
//                            print(error)
//                        }
//                    }
//                }.resume()
//            
//            }
//            catch let error as NSError {
//                print(error)
//            }
        }
        
    }
        
    
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
        else{
            self.datePicker.minimumDate = NSDate() as Date
            self.datePicker.minuteInterval = 30
            textField.inputView = self.datePicker
            
            self.datePicker.addTarget(self, action: #selector(MapsViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        }
    }
    
    
    func getFreeTime()
    {
        self.calendars = eventStore.calendars(for: EKEntityType.event)
        for calendar in self.calendars! {
            let oneMonthAgo = dateStart
            let oneMonthAfter = dateEnd
            
            let predicate = eventStore.predicateForEvents(withStart: oneMonthAgo!, end: oneMonthAfter!, calendars: [calendar])
            
            let events = eventStore.events(matching: predicate)
            
            for event in events {
                
                print(event.location)
                print(event.title)
                print(event.startDate as NSDate)
                print(event.endDate as NSDate)
                
               
            }
        }

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
