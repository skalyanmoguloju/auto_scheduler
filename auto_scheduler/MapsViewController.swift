import UIKit
import GooglePlaces

class MapsViewController: UIViewController, UITextFieldDelegate {
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    @IBAction func backButton(_ sender: UIButton) {
         dismiss(animated: false, completion: nil)
    }
    var dateFormatter : DateFormatter!
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var dateTextEndField: UITextField!

    
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
            textField.inputView = self.datePickerEnd
            self.datePickerEnd.addTarget(self, action: #selector(MapsViewController.datePickerValueChangedEnd), for: UIControlEvents.valueChanged)
            
        }
        else{
            textField.inputView = self.datePicker
            self.datePicker.addTarget(self, action: #selector(MapsViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        }
    }
    
    func donePicker()
    {
        dateTextField.resignFirstResponder()
        dateTextEndField.resignFirstResponder()
    }
    
    func datePickerValueChangedEnd(sender:UIDatePicker) {
        
        dateTextEndField.text = dateFormatter.string(from: sender.date)
        
    }
    
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        dateTextField.text = dateFormatter.string(from: sender.date)
        
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
