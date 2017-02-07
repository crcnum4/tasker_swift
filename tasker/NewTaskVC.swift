//
//  NewTaskVC.swift
//  tasker
//
//  Created by Cliff Choiniere on 1/30/17.
//  Copyright © 2017 Cliff Choiniere. All rights reserved.
//

import UIKit

class NewTaskVC: UIViewController {
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskDescriptionTextField: UITextView!
    
    let token = UserDefaults.standard.object(forKey: "tasker_token")
    
    let root_url = "https://rails-api-test-crcnum4.c9users.io/"
    
    @IBAction func saveButton(_ sender: Any) {
        
        if (taskNameTextField.text?.characters.count)! < 3 {
            print("Task name too short")
        } else {
            if (taskDescriptionTextField.text?.characters.count)! < 5 {
                print("Task description too short")
            } else {
                let params = "token=\(token!)&name=\(taskNameTextField.text!)&description=\(taskDescriptionTextField.text!)"
                
                let url = URL(string: root_url + "/tasks?" + params.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
                
                let request = NSMutableURLRequest(url: url!)
                request.httpMethod = "POST"
                
                let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
                    
                    if error != nil {
                        print(error ?? "No errors")
                    } else {
                        if let urlContent = data {
                            do {
                                let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                                
                                print(jsonResult)
                                
                                let status = jsonResult.value(forKey: "status") as! String
                                
                                if status == "error" {
                                    print("Error: \(jsonResult.value(forKey: "message") as! String)")
                                }
                                
                                if status == "success" {
                                    
                                    DispatchQueue.main.async {
                                        self.performSegue(withIdentifier: "returnToTaskListSegue", sender: nil)
                                    }
                                }
                            } catch {
                                print("did not succedd with API save request")
                            }
                        }
                    }
                }
                task.resume()
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
