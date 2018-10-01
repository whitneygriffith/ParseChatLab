//
//  LoginViewController.swift
//  ParseChatLab
//
//  Created by Whitney Griffith on 9/30/18.
//  Copyright © 2018 Whitney Griffith. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    let alertController = UIAlertController(title: "Invalid username/password", message: "Please enter a valid username/password", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add OK button to alert
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
    }
    
    @IBAction func login(_ sender: Any) {
        let username = usernameLabel.text ?? ""
        let password = passwordLabel.text ?? ""
        
         PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("User log in failed: \(error.localizedDescription)")
                self.alertController.message = error.localizedDescription
                self.present(self.alertController, animated: true)
                
                
            } else {
                print("User logged in")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    
    @IBAction func signUp(_ sender: Any) {
        let newUser = PFUser()
        
        newUser.username = usernameLabel.text
        newUser.password = passwordLabel.text
        
        newUser.signUpInBackground { (succeeded: Bool, error: Error?)-> Void in
            if succeeded{
                print("signed up")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                
            }else{
                let errorString = error?.localizedDescription
                let alertController = UIAlertController(title: "Try again", message: errorString, preferredStyle: .alert)
                
                // add ok button
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: {
                    (action) in
                })
                
                alertController.addAction(okAction)
            }
        }
    }
    
}
