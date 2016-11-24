//
//  DataService.swift
//  auto_scheduler
//
//  Created by macbook_user on 11/23/16.
//
//

import Foundation


class DataService {
    
    static var deviceid = "";
    static let serviceURL = "http://192.168.0.27:3000/users/";
    
    static func insert_user(number: String)
    {
        do{
            var f = false
            var request = URLRequest(url: NSURL(string: DataService.serviceURL + "signup") as! URL)
            request.httpMethod = "POST"
            var params = ["username":number, "identification": DataService.deviceid] as Dictionary<String, String>
            //let array = ["username":contactsList]
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            URLSession.shared.dataTask(with: request){ (data, response, error) in
                if error != nil {
                    print(error)
                } else {
                    do {
                        let parsedData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject];
                        print(parsedData)
                    }
                    catch let error as NSError {
                        print(error)
                    }
                }
                }.resume()
            
        }
        catch let error as NSError {
            print(error)
        }
    }
    
    static func retrieveContacts(contacts: Contacts_ViewController, contactsList: String){
        do {
            var f = false
            var request = URLRequest(url: NSURL(string: serviceURL + "firstpost") as! URL)
            request.httpMethod = "POST"
            let array = ["username":contactsList]
            request.httpBody = try JSONSerialization.data(withJSONObject: array, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            URLSession.shared.dataTask(with: request){ (data, response, error) in
                if error != nil {
                    print(error)
                } else {
                    do {
                        let parsedData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject];
                        contacts.currentConditions = parsedData["users"] as! NSArray
                        for object in contacts.currentConditions as! [Dictionary<String, AnyObject>] {
                            print(object["users_number"]!)
                            contacts.validContacts.append(object["users_number"]! as! String)
                            if(contacts.totalContacts.contains(object["users_number"]! as! String))
                            {
                                contacts.contacts_new.append(contacts.contacts_full[contacts.totalContacts.index(of: object["users_number"]! as! String)!])
                                f = true
                            }
                        }
                        if(f){
                            contacts.contacts = contacts.contacts_new
                            contacts.filteredData = contacts.contacts
                            contacts.tableView.reloadData()
                        }
                        
                    }
                    catch let error as NSError {
                        print(error)
                    }
                }
                }.resume()
        }
        catch let error as NSError {
            print(error)
        }
    }
}
