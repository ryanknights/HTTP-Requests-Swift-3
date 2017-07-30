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
        let type = sender.accessibilityIdentifier
        
        if type != nil {
            let selector = NSSelectorFromString("send" + type! + "Request")
            perform(selector)
        }
    }
    
    func sendGETRequest () {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
    
        URLSession.shared.dataTask(with: url!, completionHandler: {data, response, error -> Void in
            guard let data = data, error == nil else {
                return print("error=\(String(describing: error))")
            }
            
            if let httpStatus = response as? HTTPURLResponse {
                print("Status Code => \(httpStatus.statusCode)")
            }
            
            do {
                let posts = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as! [[String:AnyObject]]
                    
                for post in posts {
                    if let id = post["id"], let title = post["title"] {
                        print("\(id) => \(title)")
                    }
                }
            } catch let error as NSError{
                print(error)
            }
        }).resume()
    }
    
    func sendPOSTRequest () {
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
        var request = URLRequest(url:url!)
        
        request.httpMethod = "POST"
        let postString = "title=foo&body=bar&userid=1"
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return print("error=\(String(describing: error))")
            }
            
            if let httpStatus = response as? HTTPURLResponse {
                print("Status Code => \(httpStatus.statusCode)")
            }
            
            do {
                let keys = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as! [String:AnyObject]
                
                for (key, value) in keys {
                    print("\(key) => \(value)")
                }
            } catch let error as NSError{
                print(error)
            }
        }
        task.resume()
    }
    
    func sendPUTRequest () {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1")
        var request = URLRequest(url:url!)
        
        request.httpMethod = "PUT"
        let postString = "id=10&title=foo&body=bar&userId=1"
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return print("error=\(String(describing: error))")
            }
            
            if let httpStatus = response as? HTTPURLResponse {
                print("Status Code => \(httpStatus.statusCode)")
            }
            
            do {
                let keys = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as! [String:AnyObject]
                
                for (key, value) in keys {
                    print("\(key) => \(value)")
                }
            } catch let error as NSError{
                print(error)
            }
        }
        task.resume()

    }
    
    func sendDELETERequest () {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1")
        var request = URLRequest(url:url!)
        
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return print("error=\(String(describing: error))")
            }
            
            if let httpStatus = response as? HTTPURLResponse {
                print("Status Code => \(httpStatus.statusCode)")
            }
            
            do {
                let keys = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as! [String:AnyObject]
                
                print(keys)
                
            } catch let error as NSError{
                print(error)
            }
        }
        task.resume()
    }
}

