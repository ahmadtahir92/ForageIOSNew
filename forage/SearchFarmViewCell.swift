//
//  SearchFarmViewCell.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 2/10/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit

class SearchFarmViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var farmProfile: UIImageView!
    
    @IBOutlet weak var farmName: UILabel!
    
    @IBOutlet weak var farmFav: UIImageView!
    
    @IBOutlet weak var farmTag: UIImageView!
    
    @IBOutlet weak var farmViewTap: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Init code
    }
    
    var onTap: (_ sender: UIButton) -> () = {_ in }
    
    public func setup(farm: Farm, tapFunc: @escaping (_ sender: UIButton) -> ()) {
        
        self.onTap = tapFunc
        
        let image = farm.farmImage!
        S3Enable.getFarmsImage(key: image, imageCB: { (imageLoc: String) -> Void in
            // XXX - Mouli - check if the cell is still in view before setting the image!!!
            self.farmProfile.image = UIImage(contentsOfFile: imageLoc)
        })
        
        let title = farm.farmName
        self.farmName.text = title
        self.farmName.sizeToFit()
        
        
        self.farmViewTap.backgroundColor = UIColor.clear // Hide the button!
        self.farmViewTap.addTarget(self, action: #selector(didTap), for: .touchUpInside)

        
        if let classResource = farm.getFarmClassResource() {
            self.farmTag.image = classResource
        } else {
            self.farmTag.image = nil
        }
        
        self.farmFav.image = #imageLiteral(resourceName: "heart_icon")
        if (ParseHomeOwner.farmInHomeFavs(farm: farm)) {
            // It is a favorite - enhance it!
            self.farmFav.alpha = Constants.ICON_BRIGHT_ALPHA
        } else {
            // Not a favorite for this home - dim it!
            self.farmFav.alpha = Constants.ICON_DIM_ALPHA
        }
    }
    
    func didTap() {
        self.onTap(self.farmViewTap)
    }
}
