//
//  RestAPIManager.swift
//  auto_scheduler
//
//  Created by Sai on 11/4/16.
//
//


typealias ServiceResponse = (JSON, NSError?) -> Void



import UIKit
class RestAPIManager: NSObject {
    static let sharedInstance = RestAPIManager()
    
    let baseURL = "http://localhost:8081/listUsers"
    
    func getRandomUser(onCompletion: @escaping () -> Void) {
        let route = baseURL
        makeHTTPGetRquest(path: route, onCompletion: { json, err in
            onCompletion()
        })
    }
    
    func makeHTTPGetRquest(path: String, onCompletion: @escaping ServiceResponse) {
        let request = NSMutableURLRequest(url: NSURL(string: path)! as URL)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            let json:JSON = JSON(data: data!)
            onCompletion(json, error as NSError?)
        })
        task.resume()
    }
}

