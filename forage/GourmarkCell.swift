//
//  GourmarkCell.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 2/14/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class GourmarkCell: UICollectionViewCell {
    
    @IBOutlet weak var gourmarkProfile: UIImageView!
    @IBOutlet weak var gourmarkName: UILabel!
    @IBOutlet weak var gourmarkAuthor: UILabel!
    //@IBOutlet weak var gourmarkDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Init code
    }
    
    public func setup(gourmark: Gourmark) {
        let imageStr = gourmark.profile
        if (!gourmark.shared) {
            S3Enable.getGourmarkImage(key: imageStr, imageCB: { (imageLoc: String) -> Void in
                self.gourmarkProfile.image = UIImage(contentsOfFile: imageLoc)
            })
        } else {
            //cell.gourmarkProfile.sd_setImage(with: URL(string: image))
            Alamofire.request(imageStr).responseImage { response in
                if let image = response.result.value {
                    self.gourmarkProfile.image = image.af_imageRounded(withCornerRadius: Constants.IMAGE_CORNER_RADIUS)
                }
            }
        }
        
        let title = gourmark.name
        self.gourmarkName.text = title
        self.gourmarkName.sizeToFit()
        
        if let gourmarkAuthor = gourmark.shareAuthor {
            self.gourmarkAuthor.text = "Shared by: " + gourmarkAuthor
            self.gourmarkAuthor.sizeToFit()
        } else {
            self.gourmarkAuthor.text = ""
            self.gourmarkAuthor.sizeToFit()
        }
        
        /*
        if let gourmarkDesc = gourmark.gourmarkDescription {
            self.gourmarkDescription.text = gourmarkDesc
            self.gourmarkDescription.sizeToFit()
        } else {
            self.gourmarkDescription.text = ""
            self.gourmarkDescription.sizeToFit()
        }
        */
    }
}
