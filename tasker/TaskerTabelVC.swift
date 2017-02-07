//
//  TaskerTabelVC.swift
//  tasker
//
//  Created by Cliff Choiniere on 1/26/17.
//  Copyright © 2017 Cliff Choiniere. All rights reserved.
//

import UIKit

class TaskerTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var taskTable: UITableView!
    var tasks:NSArray = [] as NSArray
    var tasksflag:Bool = false
    var selectedTask = 0
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return tasks.count
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(5)
    }
    
    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let v: UIView = UIView()
        v.backgroundColor = UIColor.lightGray
        return v;
        
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aTask = tasks[indexPath.section] as! NSDictionary
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyProtoCell") as! MyTableCell
        
        cell.descriptionLabel.text = aTask.value(forKey: "name") as? String
        
        let apiDate = aTask.value(forKey: "created_at") as? String
        
        let format="yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let dateFmt = DateFormatter()
        dateFmt.dateFormat = format
        let newreadableDate = dateFmt.date(from: apiDate!)
        
        let dateFmtString = DateFormatter()
        dateFmtString.dateFormat = "MMMM dd '|' HH:mm"
        let taskDate = dateFmtString.string(from: newreadableDate!)
        
        cell.dateLabel.text = taskDate
        cell.taskID = aTask.value(forKey: "id") as! Int
        
        
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! MyTableCell
        
        selectedTask = currentCell.taskID
        
        performSegue(withIdentifier: "showTaskSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTaskSegue" {
            let secondVC = segue.destination as! ViewTaskVC
            secondVC.taskID = selectedTask
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let root_url = "https://rails-api-test-crcnum4.c9users.io/"
        
        if UserDefaults.standard.object(forKey: "tasker_token") != nil {
            let token = UserDefaults.standard.object(forKey: "tasker_token") as! String
            
            let params = "token=\(token)"
            
            let url = URL(string: root_url + "/tasks?" + params.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
            let request = NSMutableURLRequest(url: url!)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
                
                if error != nil {
                    print(error ?? "no errors")
                } else {
                    if let urlContent = data {
                        do {
                            let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                            
//                            print(jsonResult)
                            
                            let resultInfo = jsonResult.value(forKey: "status") as! NSDictionary
                            
                            let status = resultInfo.value(forKey: "status") as! String
                            
                            if status == "error" {
                                print("Error: \(resultInfo.value(forKey: "message") as! String)")
                            }
                            
                            if status == "success" {
//                                print(jsonResult.value(forKey: "tasks") as! NSArray)
                                self.tasks = jsonResult.value(forKey: "tasks") as! NSArray
                                DispatchQueue.main.async {
                                    self.taskTable.reloadData()
                                }
                            }
                        } catch {
                            //process error
                            print("failed to collect tasks")
                        }
                    }
                }
            }
            task.resume()
        } else {
            performSegue(withIdentifier: "returnLogin", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
