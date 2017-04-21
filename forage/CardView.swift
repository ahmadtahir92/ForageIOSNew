//
//  CardView.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 2/13/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit

@IBDesignable
class CardView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable var cornerRadius: CGFloat = Constants.IMAGE_CORNER_RADIUS
    
    @IBInspectable var shadowOffsetWidth = Constants.IMAGE_SHADOW_OFFSET_WIDTH
    @IBInspectable var shadowOffsetHeight = Constants.IMAGE_SHADOW_OFFSET_HEIGHT
    @IBInspectable var shadowColor: UIColor? = UIColor.lightGray
    @IBInspectable var shadowRadius = Constants.IMAGE_SHADOW_RADIUS
    @IBInspectable var shadowOpacity: Float = Constants.IMAGE_SHADOW_OPACITY
    
    override func layoutSubviews() {
        
        layer.cornerRadius = cornerRadius
        // This makes the rendering faster
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = true
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.masksToBounds = false
        layer.shadowPath = shadowPath.cgPath
    }
}
