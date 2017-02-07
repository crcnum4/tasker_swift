//
//  ViewController.swift
//  tasker
//
//  Created by Cliff Choiniere on 1/21/17.
//  Copyright © 2017 Cliff Choiniere. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let root_url = "https://rails-api-test-crcnum4.c9users.io/"
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signup: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBAction func signupClick(_ sender: Any) {
        if signup.titleLabel?.text! == "Sign Up" {
            emailTextField.isHidden = false
            signup.setTitle("Cancel", for: .normal)
            loginBtn.setTitle("Register", for: .normal)
        }
        if signup.titleLabel?.text! == "Cancel" {
            emailTextField.isHidden = true
            signup.setTitle("Sign Up", for: .normal)
            loginBtn.setTitle("Log In", for: .normal)
        }
    }
    
    @IBAction func loginClick(_ sender: Any) {
        var username = ""
        print("loginbutton clicked")
        if loginBtn.titleLabel?.text! == "Log In" {
            //process login process
        }
        
        if loginBtn.titleLabel?.text! == "Register" {
            print("button was Register")
            if emailTextField.text != nil && usernameTextField.text != nil && passwordTextField.text != nil {
                print("fields not empty")
                var data = "email=" + emailTextField.text!
                data += "&username=" + usernameTextField.text!
                data += "&password=" + passwordTextField.text!
                
                let url = URL(string: root_url + "users?" + data.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
                
                let request = NSMutableURLRequest(url: url!)
                request.httpMethod = "POST"
                
                let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
                    if error != nil {
                        print(error ?? "no errors")
                    } else {
                        if let urlContent = data {
                            do {
                                let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                                
//                                print(jsonResult)
                                
                                let idnsnum = jsonResult.value(forKey: "id") as? NSNumber
                                
                                let id = idnsnum?.intValue
                                print(id!)
                                
                                if id != nil {
                                    print("got into here")
                                    
                                    // user created time to register device.
                                    let uuid_unwrapped = UIDevice.current.identifierForVendor
                                    let uuid = uuid_unwrapped?.uuidString
                                    
                                    let model = UIDevice.current.model
                                    let name = UIDevice.current.name
                                    
                                    var deviceData = "uuid=" + uuid!
                                    deviceData += "&model=" + model
                                    deviceData += "&user_id=\(id!)"
                                    deviceData += "&name=\(name)"
                                    
                                    let deviceURL = URL(string: self.root_url + "devices?" + deviceData.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
                                    
                                    let deviceRequest = NSMutableURLRequest(url: deviceURL!)
                                    deviceRequest.httpMethod = "POST"
                                    
                                    let deviceTask = URLSession.shared.dataTask(with: deviceRequest as URLRequest) { (devData, devRequest, devError) in
                                        
                                        if devError != nil {
                                            print(devError ?? "no errors")
                                        } else {
                                            if let devurlContent = devData {
                                                do {
                                                    let devJsonResult = try JSONSerialization.jsonObject(with: devurlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                                                    
                                                    print(devJsonResult)
                                                    
                                                    self.emailTextField.text = ""
                                                    self.emailTextField.isHidden = true
                                                    self.usernameTextField.text = ""
                                                    self.passwordTextField.text = ""
                                                    self.signup.setTitle("Sign Up", for: .normal)
                                                    self.loginBtn.setTitle("Log In", for: .normal)
                                                } catch {
                                                    //process errors
                                                    print("errored on try")
                                                    //delete the new user created.
                                                }
                                            }
                                        }
                                    }
                                    deviceTask.resume()
                                }
                            } catch {
                                //process error
                            }
                        }
                    }
                }
                
                task.resume()
                
            }
        } else {
            //button was log in
            if usernameTextField.text != nil && passwordTextField.text != nil {
                //fiels are empty.
                //check first if user exists.
                
                
                
                var params = "username=\(usernameTextField.text!)&password=\(passwordTextField.text!)"
                
                let url = URL(string: root_url + "/login?" + params.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
                let request = NSMutableURLRequest(url: url!)
                
                let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, responce, error) in
                    if error != nil {
                        print(error ?? "No Errors")
                    } else {
                        if let urlContent = data {
                            do {
                                let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                                
                                if let status = jsonResult.value(forKey: "status") as? String{
                                
                                    if status == "error" {
                                        print("Error: " + (jsonResult.value(forKey: "message") as! String))
                                    }
                                    if status == "success" {
                                        UserDefaults.standard.set(username, forKey: "tasker_username")
                                        username = jsonResult.value(forKey: "username") as! String
                                        print(username)
                                        
                                        let uuid_unwrapped = UIDevice.current.identifierForVendor
                                        let uuid = uuid_unwrapped?.uuidString
                                        
                                        params = "username=\(username)&uuid=\(uuid!)"
                                        
                                        let url = URL(string: self.root_url + "/req_tok?" + params.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
                                        let request = NSMutableURLRequest(url: url!)
                                        
                                        let task2 = URLSession.shared.dataTask(with: request as URLRequest) { (data, responce, error) in
                                            if error != nil {
                                                print(error ?? "no errors")
                                            } else {
                                                if let urlContent = data {
                                                    do {
                                                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                                                        
                                                        if let status = jsonResult.value(forKey: "status") as? String {
                                                            
                                                            if status == "error" {
                                                                print("Error: " + (jsonResult.value(forKey: "message") as! String))
                                                            }
                                                            if status == "new_device" {
                                                                //process new device through json request
                                                                
                                                                let uuid_unwrapped = UIDevice.current.identifierForVendor
                                                                let uuid = uuid_unwrapped?.uuidString
                                                                
                                                                let model = UIDevice.current.model
                                                                let name = UIDevice.current.name
                                                                
                                                                
                                                                let params = "username=\(username)&uuid=\(uuid!)&model=\(model)&name=\(name)"
                                                                let url = URL(string: self.root_url + "/new_dev?" + params.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
                                                                let request = NSMutableURLRequest(url: url!)
                                                                
                                                                let tasknew_dev = URLSession.shared.dataTask(with: request as URLRequest) { (data, responce, error) in
                                                                    if error != nil {
                                                                        print(error ?? "no errors")
                                                                    } else {
                                                                        if let urlContent = data {
                                                                            do {
                                                                                let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                                                                                
                                                                                if let status = jsonResult.value(forKey: "status") as? String {
                                                                                    if status == "error" {
                                                                                        print("Error: " + (jsonResult.value(forKey: "message") as! String))
                                                                                    } else {
                                                                                        print("success")
                                                                                    }
                                                                                }
                                                                            } catch {
                                                                                //process error
                                                                                print("couldn't register new device api")
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                                tasknew_dev.resume()
                                                                
                                                            }
                                                            if status == "success" {
                                                                UserDefaults.standard.set((jsonResult.value(forKey: "token") as! String), forKey: "tasker_token")
                                                                print(jsonResult.value(forKey: "token") as! String)
                                                            }
                                                            
                                                        }
                                                        
                                                    } catch {
                                                        //process error
                                                        print("couldn't get device api")
                                                    }
                                                }
                                            }
                                        }
                                        
                                        task2.resume()
                                        
                                    }
                                }
                                
                            } catch {
                                //Process error
                                print ("error logging in")
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
        // Do any additional setup after loading the view, typically from a nib.
        
        if UserDefaults.standard.object(forKey: "tasker_token") != nil {
            
            let token = UserDefaults.standard.object(forKey: "tasker_token") as! String
            
            let uuid_unwrapped = UIDevice.current.identifierForVendor
            let uuid = uuid_unwrapped?.uuidString
            
            let params = "token=\(token)&uuid=\(uuid!)"
            
            let url = URL(string: root_url + "/check_tkn?" + params.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
            
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
                            if status == "mismatch" {
                                print("Error: \(jsonResult.value(forKey: "message") as! String)")
                            }
                            if status == "unconfirmed" {
                                print("Error: \(jsonResult.value(forKey: "message") as! String)")
                            }
                            if status == "success" {
                                self.performSegue(withIdentifier: "login", sender: self)
                            }
                        } catch {
                            print("couln not connect to api")
                        }
                    }
                }
                
            }
            task.resume()
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

