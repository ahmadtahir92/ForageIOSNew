//
//  FarmOrdersTableViewCell.swift
//  forage
//
//  Created by vamsi valluri on 3/13/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit

class FarmOrdersTableViewCell: UITableViewCell {

    @IBOutlet weak var orderTotal: UITextView!
    @IBOutlet weak var orderTime: UITextView!
    @IBOutlet weak var orderNumber: UITextView!
    @IBOutlet weak var userName: UITextView!
    @IBOutlet weak var orderProfile: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
