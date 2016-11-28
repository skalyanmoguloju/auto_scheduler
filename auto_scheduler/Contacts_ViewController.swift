//
//  ViewController.swift
//  auto_scheduler
//
//  Created by macbook_user on 10/24/16.
//
//

import UIKit
import Contacts

import EventKit


class Contacts_ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    let intervalCellIdentifier = "intervalCellIdentifier"
    
    let limit = 10
    var contactsSelected = [String]()
    var validContacts = [String]()
    let defaults = UserDefaults.standard
    var totalContacts = [String]()
    
    @IBAction func nextButton(_ sender: Any) {
        defaults.set(contactsSelected, forKey: "participants")
        self.performSegue(withIdentifier: "nextFromContacts", sender: self)
        
    }
    
    // outlets
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var noContactsLabel: UILabel!
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // data
    var contactStore = CNContactStore()
    var contacts = [ContactEntry]()
    var contacts_full = [ContactEntry]()
    var filteredData = [ContactEntry]()
    
    var contacts_new = [ContactEntry]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactTableViewCell");
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        tableView.isHidden = true
        //noContactsLabel.isHidden = false
        //noContactsLabel.text = "Retrieving contacts..."
        addDummyData()
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
                        self.contacts_full = contacts!
                        self.filteredData = self.contacts
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
                    if contact.phone != nil && contact.name != "" && (contact.phone) != "" &&  (contact.phone?.characters.count)! >= 10
                    {
                        do {
                            print("knfdknkdsn")
                            print(contact.phone)
                            var s = try String(contact.phone!);
                            s = try s!.replacingOccurrences(of:
                                "\\D", with: "", options: .regularExpression,
                                       range: s!.startIndex..<s!.endIndex);
                        
                             s = try s!.substring(from:s!.index(s!.endIndex, offsetBy: -10));
                             self.totalContacts.append(s!)
                             contacts.append(contact)
                        }
                        catch
                        {
                            print("error")
                        }
                    }
                }
            })
            filterList(contacts)
            completion(true, contacts)
        } catch {
            completion(false, nil)
        }
    }
    
    func filterList(_ contacts_bckup: [ContactEntry]?)
    {
        var counter = 1
        
        var valStrng = ""
        //print(contacts_bckup);
        for val in contacts_bckup!
        {
            if(counter == contacts_bckup?.count)
            {
//                valStrng = String(val.phone!);
//                valStrng = valStrng
//                    .replacingOccurrences(of: " ", with: "")
//                    .replacingOccurrences(of: ")", with: "")
//                    .replacingOccurrences(of: "(", with: "+");
//                //.characters.suffix(10))+"'"
                
                //+ "-";
                
                

//                str = "'" + String(str.replacingOccurrences(of: "+",with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "").characters.suffix(10)) + "'";
//                valStrng = valStrng + str;
                
                var s = String(val.phone!);
                s = s!.replacingOccurrences(of:
                    "\\D", with: "", options: .regularExpression,
                           range: s!.startIndex..<s!.endIndex);
                s = s!.substring(from:s!.index(s!.endIndex, offsetBy: -10))
                s = "'" + s! + "'";
                valStrng = valStrng + s!;
                counter = 0
            }
            else
            {
//                valStrng = valStrng+"'"+String(val.phone!.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "(", with: "+").characters.suffix(10))+"',"
                
                var s = String(val.phone!);
                s = s!.replacingOccurrences(of:
                    "\\D", with: "", options: .regularExpression,
                           range: s!.startIndex..<s!.endIndex);
                s = s!.substring(from:s!.index(s!.endIndex, offsetBy: -10))
                s = "'" + s! + "',";
                valStrng = valStrng + s!;
                counter = counter+1
            }
        }
     //   print(valStrng);
        retrivecontactsfromNode(contactsList: valStrng)
        
    }
    var currentConditions: NSArray = []
    func retrivecontactsfromNode(contactsList: String)
    {
       DataService.retrieveContacts(contacts: self, contactsList: contactsList);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      //  print(filteredData.count)
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
    
    
    func addDummyData() {
        
        var titles : [String] = []
        var startDates : [NSDate] = []
        var endDates : [NSDate] = []
        
        let eventStore = EKEventStore()
        let calendars = eventStore.calendars(for: .event)
        
        for calendar in calendars {
            if calendar.title == "Work" {
                
                let oneMonthAgo = NSDate(timeIntervalSinceNow: -30*24*3600)
                let oneMonthAfter = NSDate(timeIntervalSinceNow: +30*24*3600)
                
                let predicate = eventStore.predicateForEvents(withStart: oneMonthAgo as Date, end: oneMonthAfter as Date, calendars: [calendar])
                
                var events = eventStore.events(matching: predicate)
                
                for event in events {
                    titles.append(event.title)
                    startDates.append(event.startDate as NSDate)
                    endDates.append(event.endDate as NSDate)
                }
            }
        }
    }
}
