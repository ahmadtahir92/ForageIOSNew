//
//  SeasonalListCell.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 2/13/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit

class SeasonalListCell: UICollectionViewCell {
    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var inventoryProfile: UIImageView!
    @IBOutlet weak var inventoryPrice: UILabel!
    @IBOutlet weak var inventoryName: UILabel!
    @IBOutlet weak var inventoryDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Init code
    }
    
    public func setup(inv: Inventory) {
        let image = inv.profile
        S3Enable.getInventoryImage(key: image, imageCB: { (imageLoc: String) -> Void in
            self.inventoryProfile.image = UIImage(contentsOfFile: imageLoc)
        })
        
        let title = inv.name
        self.inventoryName.text = title
        self.inventoryName.sizeToFit()
        
        if let invDesc = inv.itemDescription {
            self.inventoryDescription.text = invDesc
            self.inventoryDescription.sizeToFit()
        } else {
            self.inventoryDescription.text = ""
            self.inventoryDescription.sizeToFit()
        }
        
        let price = inv.rate
        self.inventoryPrice.text = "$" + String(format:"%.1f", price)
        self.inventoryPrice.sizeToFit()
    }
}
