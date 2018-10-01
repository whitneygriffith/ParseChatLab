//
//  ChatCell.swift
//  
//
//  Created by Whitney Griffith on 9/30/18.
//

import UIKit

import Parse

class ChatCell: UITableViewCell {

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var messages: PFObject! {
        didSet {
            messageLabel.text = messages.object(forKey: "text") as? String
            
            let user = messages.object(forKey: "user") as? PFUser
            if (user != nil) {
                userLabel.text = user?.username
            }
            else {
                userLabel.text = "Unknown"
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
