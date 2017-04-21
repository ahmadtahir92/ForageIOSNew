//
//  FarmOrderDetailTableViewCell.swift
//  forage
//
//  Created by vamsi valluri on 3/15/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit

class FarmOrderDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var totalPrice: UITextView!
    @IBOutlet weak var orderTime: UITextView!
    @IBOutlet weak var orderQty: UITextView!
    @IBOutlet weak var orderRate: UITextView!
    @IBOutlet weak var orderDetailProfile: UIImageView!
    @IBOutlet weak var invName: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
