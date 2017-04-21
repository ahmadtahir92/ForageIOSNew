//
//  myFeedCell.swift
//  forage
//
//  Created by cchannap on 3/26/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit

class myFeedCell: UICollectionViewCell {
    @IBOutlet weak var feedName: UILabel!
    @IBOutlet weak var feedStatus: UILabel!
    @IBOutlet weak var feedImage: UIImageView!
    
    var urlLink: String!
}
