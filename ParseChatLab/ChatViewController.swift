//
//  ChatViewController.swift
//  ParseChatLab
//
//  Created by Whitney Griffith on 9/30/18.
//  Copyright © 2018 Whitney Griffith. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var messages: [PFObject] = []

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        cell.messages = (self.messages[indexPath.row])
        return cell
    }

    @IBAction func logOut(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)
    }
    @IBOutlet weak var newMessage: UITextField!
    
    @IBAction func sendMessage(_ sender: Any) {
        
        let chatMessage = PFObject(className: "Message")
        chatMessage["text"] = newMessage.text ?? ""
        chatMessage["user"] = PFUser.current()
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
                self.newMessage.text = ""
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
        
    }
    
    @IBOutlet weak var chatView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatView.dataSource = self
        chatView.delegate = self
        chatView.estimatedRowHeight = 150
        chatView.rowHeight = UITableView.automaticDimension
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ChatViewController.onTimer), userInfo: 0, repeats: true)
        
    }
    
    @objc func onTimer() {
        let query = PFQuery(className:"Message")
        query.whereKeyExists("text").includeKey("user")
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) -> Void in
            if ((error) != nil)  {
                // The find succeeded.
                self.messages = objects as! [PFObject]
                self.chatView.reloadData()
                
            } else {
                // Log details of the failure
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
}
