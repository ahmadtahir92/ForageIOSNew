//
//  UITheme.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 2/18/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit

/**
 * Map material design color template to iOS
 * https://www.materialpalette.com/brown/green
 *     @darkPrimaryColor:   #5D4037; // Dark Brown
 *     @primaryColor:       #795548; // Light Brown
 *     @lightPrimaryColor:  #D7CCC8; // Milky Coffee Brown
 *     @textPrimaryColor:   #FFFFFF; // White
 *     @accentColor:        #4CAF50; // Light Green
 *     @primaryTextColor:   #212121; // Black
 *     @secondaryTextColor: #757575; // Dark Gray
 *     @dividerColor:       #BDBDBD; // Light gray
 *
 *
 * Additional colors needed for the theme!
 *    @defaultBackgroundColor: #FFFFFF; // White is most elegant!
 *    @defaultTextColor : #212121; // Black
 */

open class UITheme: UIColor {
    
    // Change to San Francisco? - XXX Mouli!
    static let font = UIFont(name: "HelveticaNeue-Light", size: 17)
    static let emphasisFont = UIFont(name: "HelventicaNeue-Bold", size: 17)
    
    static let defaultBackgroundColor = hexStringToUIColor(hex: "#FFFFFF")
    static let defaultTextColor = hexStringToUIColor(hex: "#212121")
    
    static let darkPrimaryColor = hexStringToUIColor(hex: "#5D4037")
    static let primaryColor = hexStringToUIColor(hex: "#795548")
    static let lightPrimaryColor = hexStringToUIColor(hex: "#D7CCC8")
    static let textPrimaryColor = hexStringToUIColor(hex: "#FFFFFF")
    static let accentColor = hexStringToUIColor(hex: "#4CAF50")
    static let primaryTextColor = hexStringToUIColor(hex: "#212121")
    static let secondaryTextColor = hexStringToUIColor(hex: "#757575")
    static let dividerColor = hexStringToUIColor(hex: "#BDBDBD")
    
    // Additional helper colors
    static let defaultDisabledColor = lightPrimaryColor
    static let defaultErrorColor = darkPrimaryColor
    
    
    private static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
