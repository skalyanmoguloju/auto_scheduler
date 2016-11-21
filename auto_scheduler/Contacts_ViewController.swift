//
//  ViewController.swift
//  auto_scheduler
//
//  Created by macbook_user on 10/24/16.
//
//
import UIKit
import Contacts

class Contacts_ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    let intervalCellIdentifier = "intervalCellIdentifier"
    
    let limit = 10
    var contactsSelected = [String]()
    
    

    // outlets
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var noContactsLabel: UILabel!
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // data
    var contactStore = CNContactStore()
    var contacts = [ContactEntry]()
    var filteredData = [ContactEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactTableViewCell")
        
        /*
        let sURL = "http://127.0.0.1:3000/users/test";
       // string URL = "https://arcane-bayou-92592.herokuapp.com/users/test";
        
        
        var request = URLRequest(url: URL(string: sURL)!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        session.dataTask(with: request) {data, response, err in
            print("Entered the completionHandler")
            print(data);
            print(response);
            print(err);
            }.resume()
        
        */
        
        //let urlString = "https://api.forecast.io/forecast/apiKey/37.5673776,122.048951"
        let urlString = "http://127.0.0.1:3000/users/test";
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
        
        
        // POST
        
        var request = URLRequest(url: URL(string: "http://127.0.0.1:3000/users/PostURL")!)
        request.httpMethod = "POST"
        let postString = "id=13&name=Jack"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        task.resume()
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.isHidden = true
        //noContactsLabel.isHidden = false
        //noContactsLabel.text = "Retrieving contacts..."
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestAccessToContacts { (success) in
            if success {
                self.retrieveContacts({ (success, contacts) in
                    self.tableView.isHidden = !success
                    //self.noContactsLabel.isHidden = success
                    if success && (contacts?.count)! > 0 {
                        self.contacts = contacts!
                        self.filteredData = self.contacts
                        self.tableView.reloadData()
                    } else {
                        //self.noContactsLabel.text = "Unable to get contacts..."
                    }
                })
            }
        }
    }

    @IBAction func backToHome(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    
    func requestAccessToContacts(_ completion: @escaping (_ success: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized: completion(true) // authorized previously
        case .denied, .notDetermined: // needs to ask for authorization
            self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (accessGranted, error) -> Void in
                completion(accessGranted)
            })
        default: // not authorized.
            completion(false)
        }
    }
    
    func retrieveContacts(_ completion: (_ success: Bool, _ contacts: [ContactEntry]?) -> Void) {
        var contacts = [ContactEntry]()
        do {
            let contactsFetchRequest = CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactImageDataKey as CNKeyDescriptor, CNContactImageDataAvailableKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor])
            try contactStore.enumerateContacts(with: contactsFetchRequest, usingBlock: { (cnContact, error) in
                if let contact = ContactEntry(cnContact: cnContact)
                {
                    if contact.phone != nil && contact.name != ""
                    {
                        contacts.append(contact)
                    }
                }
            })
            completion(true, contacts)
        } catch {
            completion(false, nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(filteredData.count)
        return filteredData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath) as! ContactTableViewCell
        let entry = filteredData[(indexPath as NSIndexPath).row]
        cell.configureWithContactEntry(entry)
        cell.layoutIfNeeded()
        cell.accessoryType = .none
        if contactsSelected.contains(entry.phone!) {
            cell.accessoryType = .checkmark
            cell.isSelected = true
        }
        
        return cell
    }
    
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        filteredData = contacts.filter( { return $0.name.hasPrefix(searchText)} )
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if contactsSelected.count == limit {
            let alertController = UIAlertController(title: "Oops", message:
                "You are limited to \(limit) selections", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            }))
            self.present(alertController, animated: true, completion: nil)
            
            return nil
        }
        
        
        return indexPath
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("selected  \(filteredData[(indexPath as NSIndexPath).row])")
        let entry = filteredData[(indexPath as NSIndexPath).row]
        if contactsSelected.contains(entry.phone!)
        {
            let v = contactsSelected.index(of: entry.phone!)
            //let v1 = contactsSelected.index(entry.phone!)
            contactsSelected.remove(at: v!)
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .none

        }
        else
        {
            if let cell = tableView.cellForRow(at: indexPath){
                if cell.isSelected {
                    contactsSelected.append(entry.phone!)
                    cell.accessoryType = .checkmark
                }
            }
            if let sr = tableView.indexPathsForSelectedRows {
                print("didDeselectRowAtIndexPath selected rows:\(sr)")
            }
        }
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        print("deselected  \(filteredData[(indexPath as NSIndexPath).row])")
        
        if let cell = tableView.cellForRow(at: indexPath) {
            let entry = filteredData[(indexPath as NSIndexPath).row]
            let v = contactsSelected.index(of: entry.phone!)
            //let v1 = contactsSelected.index(entry.phone!)
            contactsSelected.remove(at: v!)
            cell.accessoryType = .none
        }
        
        if let sr = tableView.indexPathsForSelectedRows {
            print("didDeselectRowAtIndexPath selected rows:\(sr)")
        }
    }
    
    @IBAction func GoToSuggestion(_ sender: UIButton) {
        performSegue(withIdentifier: "CreateMeeting", sender: self)
    }
    
    
}



