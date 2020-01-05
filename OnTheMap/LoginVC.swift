//
//  ViewController.swift
//  OnTheMap
//
//  Created by Work  on 11/11/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import Foundation

class LoginVC: UIViewController {

     private static var sessionId: String?
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
   
    override func viewWillAppear(_ animated: Bool) {
        email.borderStyle = UITextField.BorderStyle.roundedRect
        password.borderStyle = UITextField.BorderStyle.roundedRect
    }

    @IBAction func signup(_ sender: Any) {
        //ref: stackoverflow
        if let url = NSURL(string: "https://www.udacity.com/account/auth#!/signup"){
            UIApplication.shared.openURL(url as URL)
        }//end if
    }//Signup
    
    @IBAction func Login(_ sender: Any) {
       
        //check nil
        if (email.text?.isEmpty)! || (password.text?.isEmpty)! {
            showAlert(title: "Some fields are missing", msg: "Please fill all fields any try again")
        } else {
            API.shared.login(email.text!, password.text!) { (pass, error) in
                DispatchQueue.main.async {
                    if (!pass) {
                       
                        let err =  error!.localizedDescription
                        let status = error as? HTTPURLResponse
//                       if status?.statusCode
                         self.showAlert(title: "Error!", msg: err)

                    } else {
                        self.performSegue(withIdentifier: "login", sender: nil)
                    }//inner else
                }//dispatch block
            }//login api method block
        }//outer else
    }//Login
    
    func showAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title , message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay!", style: .default, handler: nil))
        self.present(alert, animated: true)
    }//End showAlert
}//End class
