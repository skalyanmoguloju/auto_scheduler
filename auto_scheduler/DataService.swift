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
    //static let serviceURL = "http://172.17.36.224:3000/users/";
    
    static let serviceURL = "http://192.168.0.103:3000/users/";
    //static let serviceURL = "https://arcane-bayou-92592.herokuapp.com/users/";
    
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
            contacts.contacts_new.removeAll()
            print(contactsList)
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
    
    static func InitiateMeeting(mapsInstance:  MapsViewController,  contacts: [String], loggedInUser: String, location: String, startTime: String, endTime: String, duration: Double){
        do{
            var f = false
            var request = URLRequest(url: NSURL(string:  serviceURL + "initiatemeeting") as! URL)
            request.httpMethod = "POST";
            
            let array = ["owner": loggedInUser, "participants":contacts, "location": location, "starttime" : startTime, "endtime": endTime, "duration":duration] as [String : Any]
            request.httpBody = try JSONSerialization.data(withJSONObject: array, options: JSONSerialization.WritingOptions.prettyPrinted);
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type");
            request.addValue("application/json", forHTTPHeaderField: "Accept");
            
            URLSession.shared.dataTask(with: request){ (data, response, error) in
                if error != nil {
                    print(error)
                } else {
                    do {
                        let parsedData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject];
                        
                        print("1")
                        print(parsedData);
                        //let meetingId = parsedData["insertedId"] as! NSArray;
                        
                        MapsViewController.getFreeTime(meetingId: parsedData["insertedId"] as! Int, strtDate: mapsInstance.dateStart, endDate: mapsInstance.dateEnd, duration: duration);
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
    
    static func SendAvailabilities(strts : [String], ends: [String], meetingId: Int, loggedInUser: String){
        do{
            var f = false
            var request = URLRequest(url: NSURL(string: serviceURL + "updatefreetime") as! URL)
            request.httpMethod = "POST";
            
            let array = ["username":loggedInUser, "meetingid": meetingId,"strtdates": strts, "enddates": ends] as [NSString : Any]
            request.httpBody = try JSONSerialization.data(withJSONObject: array, options: JSONSerialization.WritingOptions.prettyPrinted)
            
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
    
    static func SetPriorities(nUserNumber: String, nMeetingId: String, arrStartDateFinal: [Date], arrEndDateFinal: [Date], arrRanks: [Int])
    {
        
        
        let sArrStartDateFinal = String(describing: arrStartDateFinal)
        let sArrEndDateFinal = String(describing: arrEndDateFinal)
        let sArrRanks = String(describing: arrRanks)
        do{
            var f = false
            var request = URLRequest(url: NSURL(string: DataService.serviceURL + "setpriorities") as! URL)
            request.httpMethod = "POST"
            var params = ["username":nUserNumber, "meetingid": nMeetingId, "strtdates": sArrStartDateFinal, "enddates": sArrEndDateFinal, "ranks": sArrRanks ] as Dictionary<String, String>
            
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            URLSession.shared.dataTask(with: request){ (data, response, error) in
                if error != nil {
                    print(error)
                } else {
                    // do nothing
                }
                }.resume()
            
        }
        catch let error as NSError {
            print(error)
        }
    }
    
    static func GetRequests(meetingRequests: meetingRequestVC, nUserNumber: String){
        do {
            var request = URLRequest(url: NSURL(string: serviceURL + "getRequests") as! URL)
            request.httpMethod = "POST"
            
            var params = ["username":nUserNumber ] as Dictionary<String, String>
            
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
                        for object in parsedData["rows"] as! NSArray as! [Dictionary<String, AnyObject>] {
                            print(object["meetingowner"]!)
                            print(object["location"]!)
                            meetingRequests.meetingInfoLst.append((object["meetingowner"]! as! String)+"||"+(object["location"]! as! String)+"||"+String(describing: object["meeting_Id"]!))
                            
                            meetingRequests.tableView.reloadData()

                        }
                        
                        
                        //contacts.currentConditions = parsedData["users"] as! NSArray
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
    
    
    static func GetSuggestions(suggestionRequests: SuggestionListController, meetingId: String){
        do {
            var request = URLRequest(url: NSURL(string: serviceURL + "getSuggestions") as! URL)
            request.httpMethod = "POST"
            
            var params = ["meetingid":meetingId ] as Dictionary<String, String>
            
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            var duration = 0.0
            URLSession.shared.dataTask(with: request){ (data, response, error) in
                if error != nil {
                    print(error)
                } else {
                    do {
                        let parsedData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject];
                        print(parsedData)
                        let dDateFormatter2 = DateFormatter()
                        for object in parsedData["rows"] as! NSArray as! [Dictionary<String, AnyObject>] {
                            
                            var dDate2: String = object["starttime"]! as! String;
                            dDateFormatter2.dateFormat = "YYYY-MM-dd HH:mm";
                            let strtTIme = dDate2.replacingOccurrences(of: "T", with: " ", options: .literal, range: nil).replacingOccurrences(of: ":00.000Z", with: "", options: .literal, range: nil)
                            suggestionRequests.startDate.append(dDateFormatter2.date(from: strtTIme)!)
                            dDate2 = object["endtime"]! as! String;
                            
                            dDateFormatter2.dateFormat = "YYYY-MM-dd HH:mm";
                            var endTime = dDate2.replacingOccurrences(of: "T", with: " ", options: .literal, range: nil).replacingOccurrences(of: ":00.000Z", with: "", options: .literal, range: nil)
                            
                            duration = dDateFormatter2.date(from: endTime)!.timeIntervalSince(dDateFormatter2.date(from: strtTIme)!)
                        }
                        
                        suggestionRequests.durationLabel.text = String(duration/3600) + " hrs"
                        suggestionRequests.tableView.reloadData()
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
    
    static func RejectMeeting(nUserNumber: String,meetingId: String){
        do {
            var request = URLRequest(url: NSURL(string: serviceURL + "rejectMeeting") as! URL)
            request.httpMethod = "POST"
            
            var params = ["meetingid":meetingId,"userid": nUserNumber ] as Dictionary<String, String>
            
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            var duration = 0.0
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
    
    

}
