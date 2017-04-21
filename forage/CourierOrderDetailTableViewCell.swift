//
//  CourierOrderDetailTableViewCell.swift
//  forage
//
//  Created by vamsi valluri on 3/16/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit

class CourierOrderDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var invTime: UITextView!
    @IBOutlet weak var invPrice: UITextView!
    @IBOutlet weak var invQty: UITextView!
    @IBOutlet weak var invRate: UITextView!
    @IBOutlet weak var invName: UITextView!
    @IBOutlet weak var invProfile: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
