//
//  HomeInventoryCell.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 2/17/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit

class HomeInventoryCell: UITableViewCell {
    
    @IBOutlet weak var inventoryProfile: UIImageView!
    @IBOutlet weak var inventoryQty: UITextField!
    @IBOutlet weak var farmName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var unit: UILabel!
    @IBOutlet weak var inventoryName: UILabel!
    @IBOutlet weak var inventoryDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    public func setup(hInv: HomeInventory) {
        
        let inv = hInv.farmInv!
        
        let image = inv.profile
        S3Enable.getInventoryImage(key: image, imageCB: { (imageLoc: String) -> Void in
            self.inventoryProfile.image = UIImage(contentsOfFile: imageLoc)
        })
        
        let title = inv.name
        self.inventoryName.text = title
        self.inventoryName.sizeToFit()
        
        /**
         * Add farm Name in the cart!
         */
        // let fName = inv.farmName
        self.farmName.text = "" //fName
        self.farmName.sizeToFit()
        
        
        if let invDesc = inv.itemDescription {
            self.inventoryDescription.text = invDesc
            self.inventoryDescription.sizeToFit()
        } else {
            self.inventoryDescription.text = ""
            self.inventoryDescription.sizeToFit()
        }
        
        let price = inv.rate
        self.price.text = "$" + String(format:"%.1f", price)
        self.price.sizeToFit()
        
        let unit = inv.unit
        self.unit.text = "/  " + unit
        self.unit.sizeToFit()
        
        let qty = hInv.homeCount
        self.inventoryQty.text = Formatter.formatQty(qty: qty)
    }
    
}
