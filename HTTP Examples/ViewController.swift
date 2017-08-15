//
//  ViewController.swift
//  HTTP Examples
//
//  Created by Ryan Knights on 14/07/2017.
//  Copyright © 2017 Ryan Knights. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButtons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addButtons () {
        addButton(type: "GET", y: 100)
        addButton(type: "POST", y: 200)
        addButton(type: "PUT", y: 300)
        addButton(type: "DELETE", y: 400)
    }
    
    func addButton (type: String, y: Int) {
        let button = UIButton(frame: CGRect(x: 20, y: y, width: 200, height: 50))
        button.center.x = view.frame.width/2
        button.backgroundColor = .blue
        button.accessibilityIdentifier = type
        button.setTitle("Send \(type) Request", for: .normal)
        button.addTarget(self, action: #selector(sendRequest(sender:)), for: .touchUpInside)
        
        self.view.addSubview(button)
    }
    
    func sendRequest (sender: UIButton) {
        if let type = sender.accessibilityIdentifier {
            switch type {
            case "GET":
                sendGETRequest() {(json, response, error) -> Void in
                    print("GET Callback")
                    
                    if error != nil || response == nil {
                        return print(error! as NSError)
                    }
                    
                    if let statusCode = response?.statusCode {
                        print("Status Code => \(statusCode)")
                    }
                    
                    if json != nil {
                        let posts = json as! [[String:AnyObject]]
                        
                        for post in posts {
                            if let id = post["id"], let title = post["title"] {
                                print("\(id) => \(title)")
                            }
                        }
                    }
                }
                break;
            case "POST":
                sendPOSTRequest() {(json, response, error) -> Void in
                    print("POST Callback")
                    
                    if error != nil || response == nil {
                        return print(error! as NSError)
                    }
                    
                    if let statusCode = response?.statusCode {
                        print("Status Code => \(statusCode)")
                    }
                    
                    if json != nil {
                        let keys = json as! [String:AnyObject]
                        
                        for (key, value) in keys {
                            print("\(key) => \(value)")
                        }
                    }
                }
                break;
            case "PUT":
                sendPUTRequest() {(json, response, error) -> Void in
                    print("POST Callback")
                    
                    if error != nil || response == nil {
                        return print(error! as NSError)
                    }
                    
                    if let statusCode = response?.statusCode {
                        print("Status Code => \(statusCode)")
                    }
                    
                    if json != nil {
                        let keys = json as! [String:AnyObject]
                        
                        for (key, value) in keys {
                            print("\(key) => \(value)")
                        }
                    }
                }
                break;
            case "DELETE":
                sendDELETERequest() {(json, response, error) -> Void in
                    print("POST Callback")
                    
                    if error != nil || response == nil {
                        return print(error! as NSError)
                    }
                    
                    if let statusCode = response?.statusCode {
                        print("Status Code => \(statusCode)")
                    }
                    
                    if json != nil {
                        let keys = json as! [String:AnyObject]
                        
                        for (key, value) in keys {
                            print("\(key) => \(value)")
                        }
                    }
                }
                break;
            default:
                break;
            }
            
            //let selector = NSSelectorFromString("send" + type + "Request")
            //perform(selector)
        }
    }
    
    func sendGETRequest (callback:@escaping (Any?, HTTPURLResponse?, NSError?)->()) {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
        
        URLSession.shared.dataTask(with: url!, completionHandler: {data, response, error -> Void in
            if let httpStatus = response as? HTTPURLResponse {
                guard let data = data, error == nil else {
                    return callback(nil, httpStatus, error as NSError?)
                }
                
                do {
                    let posts = try JSONSerialization.jsonObject(with: data, options:.allowFragments)
                    return callback(posts, httpStatus, nil)
                    
                } catch let error as NSError{
                    return callback(nil, httpStatus, error)
                }
            } else {
                return callback(nil, nil, error as NSError?)
            }
        }).resume()
    }
    
    func sendPOSTRequest (callback:@escaping (Any?, HTTPURLResponse?, NSError?)->()) {
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
        var request = URLRequest(url:url!)
        
        request.httpMethod = "POST"
        let postString = "title=foo&body=bar&userid=1"
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpStatus = response as? HTTPURLResponse {
                guard let data = data, error == nil else {
                    return callback(nil, httpStatus, error as NSError?)
                }
                
                do {
                    let keys = try JSONSerialization.jsonObject(with: data, options:.allowFragments)
                    return callback(keys, httpStatus, nil)
                } catch let error as NSError{
                    return callback(nil, httpStatus, error)
                }
            } else {
                return callback(nil, nil, error as NSError?)
            }
        }
        task.resume()
    }
    
    func sendPUTRequest (callback:@escaping (Any?, HTTPURLResponse?, NSError?)->()) {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1")
        var request = URLRequest(url:url!)
        
        request.httpMethod = "PUT"
        let postString = "id=10&title=foo&body=bar&userId=1"
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpStatus = response as? HTTPURLResponse {
                guard let data = data, error == nil else {
                    return callback(nil, httpStatus, error as NSError?)
                }
                
                do {
                    let keys = try JSONSerialization.jsonObject(with: data, options:.allowFragments)
                    return callback(keys, httpStatus, nil)
                } catch let error as NSError{
                    return callback(nil, httpStatus, error)
                }
            } else {
                return callback(nil, nil, error as NSError?)
            }
        }
        task.resume()
        
    }
    
    func sendDELETERequest (callback:@escaping (Any?, HTTPURLResponse?, NSError?)->()) {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1")
        var request = URLRequest(url:url!)
        
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpStatus = response as? HTTPURLResponse {
                guard let data = data, error == nil else {
                    return callback(nil, httpStatus, error as NSError?)
                }
                
                do {
                    let keys = try JSONSerialization.jsonObject(with: data, options:.allowFragments)
                    return callback(keys, httpStatus, nil)
                } catch let error as NSError{
                    return callback(nil, httpStatus, error)
                }
            } else {
                return callback(nil, nil, error as NSError?)
            }
        }
        task.resume()
    }
}

