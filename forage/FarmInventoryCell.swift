//
//  FarmInventoryCell.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 2/12/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit

class FarmInventoryCell: UITableViewCell {

    
    @IBOutlet weak var inventoryProfile: UIImageView!

    @IBOutlet weak var farmName: UILabel!
    @IBOutlet weak var inventoryDescription: UITextField!
    @IBOutlet weak var totalAvailable: UITextField!
    @IBOutlet weak var inventoryName: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var unit: UITextField!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
