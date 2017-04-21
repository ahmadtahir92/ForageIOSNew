//
//  OrderListCell.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 2/14/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit

class OrderListCell: UICollectionViewCell {
    
    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var orderProfile: UIImageView!
    @IBOutlet weak var orderName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Init code
    }
    
    public func setup(order: Order) {
        let image = order.getProfile()
        S3Enable.getInventoryImage(key: image, imageCB: { (imageLoc: String) -> Void in
            self.orderProfile.image = UIImage(contentsOfFile: imageLoc)
        })
        
        let title = order.getOrderName()
        self.orderName.text = title
        self.orderName.sizeToFit()
    }
}
