//
//  ViewTaskVC.swift
//  tasker
//
//  Created by Cliff Choiniere on 1/30/17.
//  Copyright © 2017 Cliff Choiniere. All rights reserved.
//

import UIKit

class ViewTaskVC: UIViewController {
    var taskID = 0
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    let root_url = "https://rails-api-test-crcnum4.c9users.io/"
    let token = UserDefaults.standard.object(forKey: "tasker_token") as! String
    
    @IBAction func completeButton(_ sender: Any) {
        let params = "token=\(token)&id=\(taskID)"
        
        let url = URL(string: root_url + "tasks/check?" + params.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
        let request = NSMutableURLRequest(url: url!)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil {
                print(error ?? "no errors")
            } else {
                if let urlContent = data {
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                        
                        let status = jsonResult.value(forKey: "status") as! String
                        
                        if status == "error" {
                            print("Error: \(jsonResult.value(forKey: "message") as! String)")
                        }
                        
                        if status == "success" {
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "backToTable", sender: nil)
                            }
                        }
                    } catch {
                        print("failed to complete task via api")
                    }
                }
            }
        }
        task.resume()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(taskID)
        
        let params = "token=\(token)&id=\(taskID)"
        
        let url = URL(string: root_url + "tasks/show?" + params.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
        let request = NSMutableURLRequest(url: url!)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil {
                print( error ?? "no errors")
            } else {
                if let urlContent = data {
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                        
                        let status = jsonResult.value(forKey: "status") as! String
                        
                        if status == "error" {
                            print("Error: \(jsonResult.value(forKey: "message") as! String)")
                        }
                        
                        let taskTitle = jsonResult.value(forKey: "name") as! String
                        let taskDescription = jsonResult.value(forKey: "description") as! String
                        
                        if status == "success" {
                            DispatchQueue.main.async {
                                self.titleLabel.text = taskTitle
                                self.descriptionLabel.text = taskDescription
                            }
                            
                        }
                    } catch {
                        print("failed to pull task from api")
                    }
                }
            }
        }
        task.resume()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
