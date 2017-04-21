//
//  Buttons.swift
//
//  Adapted from Ben Guo's highlighting button in the Stripe example
//  Copyright © 2016 Stripe. All rights reserved.
//
import UIKit

class ForageButton: UIButton {
    let disabledColor = UITheme.defaultDisabledColor
    var enabledColor = UITheme.accentColor
    
    override var isEnabled: Bool {
        didSet {
            let color = isEnabled ? enabledColor : disabledColor
            self.layer.backgroundColor = color.cgColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = Constants.BUTTON_CORNER_RADIUS
        self.setTitleColor(UITheme.textPrimaryColor, for: UIControlState())
        self.clipsToBounds = true
    }
    
    func setup(title: String, enabled: Bool) {
        self.setTitle(title, for: UIControlState())
        self.isEnabled = enabled
    }
}

class ForageSecondaryButton: ForageButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.enabledColor = UITheme.lightPrimaryColor
    }
}
