//
//  SeparatorView.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 2/27/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit

class HairlineSeparatorView: UIView {
    override func awakeFromNib() {
        let backgroundColor = UITheme.darkPrimaryColor
        self.layer.borderColor = backgroundColor.cgColor
        self.layer.borderWidth = (1.0 / UIScreen.main.scale) / 2;
        self.backgroundColor = UIColor.clear
    }
}
