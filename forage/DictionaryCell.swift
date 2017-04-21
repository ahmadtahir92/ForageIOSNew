//
//  DictionaryCell.swift/Users/Mouli/Forage/iOSApp/forage/DictionaryCell.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 3/7/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit

class DictionaryCell: UITableViewCell {

    @IBOutlet weak var dictionaryEntry: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setup(dEntry: String) {
        dictionaryEntry.text = dEntry
        dictionaryEntry.sizeToFit()
    }
}
