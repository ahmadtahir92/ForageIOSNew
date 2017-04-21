//
//  CourierOrderTableViewCell.swift
//  forage
//
//  Created by vamsi valluri on 3/16/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit

class CourierOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var orderTime: UITextView!
    @IBOutlet weak var orderNumber: UITextView!
    @IBOutlet weak var orderAddress: UITextView!
    @IBOutlet weak var orderPrice: UITextView!
    @IBOutlet weak var orderName: UITextView!
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
