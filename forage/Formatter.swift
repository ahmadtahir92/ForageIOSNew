//
//  Formatter.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 1/31/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit

/**
 * Helper util methods.
 */
class Formatter {
    
    static let PRICE_FORMAT = "%.2f %@"
    static let PRICE_FORMAT_NO_DECIMAL = "%.0f %@"
    static let PRICE_UNIT = "$"
    
    /**
     * Formats an Order String for display.
     *
     * @param count Number of items.
     * @param unit Unit of the produce
     * @param name name of the produce
     * @return The given price in a format suitable for display to the user.
     */
    static func formatOrderEntry(count : Int, unit : String, name : String) -> String {
        let dash_prefix = Constants.DASH_STR + Constants.SPACE_STR + String(count)
        let orderEntry = dash_prefix + Constants.SPACE_STR + unit + Constants.SPACE_STR + name
        return orderEntry
    }
    
    /* XXX - Mouli - consolidate with above ASAP!!! */
    static func formatQty(qty: Double) -> String {
        return String(format:"%.1f", qty)
    }
    
    /**
     * Strip whitespace and change to lowercase
     * @param inputName
     * @return
     */
    static func stripName(inputName : String) -> String {
        var mungeString = inputName.replacingOccurrences(of: "\\s", with: "_") as String
        mungeString = mungeString.replacingOccurrences(of: "\'", with: "")
        
        // Remember - All the whitespace are already replaced by "_" already
        mungeString = mungeString.components(separatedBy: "_-")[0]
        mungeString = mungeString.components(separatedBy: "\\.")[0]
        mungeString = mungeString.lowercased()
    
        return mungeString
    }
    
    
    /**
     *
     */
    static func dateToStr(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy"
        dateFormatter.locale = Locale.autoupdatingCurrent
        
        return(dateFormatter.string(from: date))
    }
    
    /**
     * Convert spaces to underscores in input!
     */
    static func underscorify_spaces(input : String) -> String {
        return (input.replacingOccurrences(of: " ", with: "_").lowercased())
    }
    
    /**
     * Map date to String - Date() - already produces a String
     */
    static func dateEndOfToday() -> Date? {
        let calendar = Calendar.autoupdatingCurrent
        let now = Date()
        let todayStart = calendar.startOfDay(for: now)
        var components = DateComponents()
        components.day = 1
        let todayEnd = calendar.date(byAdding: components, to: todayStart)
        return todayEnd
    }
    
    static func datePhraseRelativeToToday(from date: Date) -> String {
        
        // Don't use the current date/time. Use the end of the current day
        // (technically 0h00 the next day). Apple's calculation of
        // doesRelativeDateFormatting niavely depends on this start date.
        guard let todayEnd = Formatter.dateEndOfToday() else {
            return ""
        }
        
        let calendar = Calendar.autoupdatingCurrent
        
        let units = Set([Calendar.Component.year,
                         Calendar.Component.month,
                         Calendar.Component.weekOfMonth,
                         Calendar.Component.day])
        
        let difference = calendar.dateComponents(units, from: date, to: todayEnd)
        
        guard let year = difference.year,
            let month = difference.month,
            let week = difference.weekOfMonth,
            let day = difference.day else {
                return ""
        }
        
        let timeAgo = NSLocalizedString("%@ ago", comment: "x days ago")
        
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.locale = Locale.autoupdatingCurrent
            formatter.dateStyle = .medium
            formatter.doesRelativeDateFormatting = true
            return formatter
        }()
        
        if year > 0 {
            // sample output: "Jan 23, 2014"
            return dateFormatter.string(from: date)
        } else if month > 0 {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .brief // sample output: "1mth"
            formatter.allowedUnits = .month
            guard let timePhrase = formatter.string(from: difference) else {
                return ""
            }
            return String(format: timeAgo, timePhrase)
        } else if week > 0 {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .brief; // sample output: "2wks"
            formatter.allowedUnits = .weekOfMonth
            guard let timePhrase = formatter.string(from: difference) else {
                return ""
            }
            return String(format: timeAgo, timePhrase)
        } else if day > 1 {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .abbreviated; // sample output: "3d"
            formatter.allowedUnits = .day
            guard let timePhrase = formatter.string(from: difference) else {
                return ""
            }
            return String(format: timeAgo, timePhrase)
        } else {
            // sample output: "Yesterday" or "Today"
            return dateFormatter.string(from: date)
        }
    }
    
    /**
     * Return a random value!
     */
    static func getJunkTime() -> Int {
        return (Date().hashValue as Int)
    }
    
    /**
     *
     * Warning: only works for positive numbers! Negative needs more handling!
     *
     * @param min
     * @param max [Max -1 >= 0]
     * @return - a random number [min, max)
     *
     */
    static func getRandom(min : UInt32, max : UInt32) -> UInt32 {
        let maxVal = UInt32(max - 1)
        return (arc4random_uniform(maxVal) + min)
        /**
         * This does inclusive of max! [min, max] !!!
         * return (arc4random_uniform(max) + min)
         */
    }
    
    /**
     * Used for the item_inventory for editable quantity!
     *
     * @param qty
     * @return
     */
    static func formatInventoryQty(qty : Double) -> String {
        let formatStr = qty == floor(qty) ? PRICE_FORMAT_NO_DECIMAL : PRICE_FORMAT as String
        return String.localizedStringWithFormat(formatStr, qty, PRICE_UNIT)
    }
    
    /**
     * Extract search keywords from a string!
     *
     * @param keywordStr - The string to examine
     *
     * @return kList - return array list!
     */
    static func extractWords(keywordStr : String) -> [String] {
    
        var kList = [String]()
        
        let parts = keywordStr.lowercased().components(separatedBy: " ")
        
        var stopWordList = [String]()
        stopWordList.append("the")
        stopWordList.append("in")
        stopWordList.append("and")
        stopWordList.append("with")
        
        for i in 0...(parts.count - 1) {
            
            if (!stopWordList.contains(parts[i])) {
                
                let word = parts[i].lowercased()
                let wordCount = word.characters.count
                var singularWord = nil as String?
                
                if (word.hasSuffix("s")) {
                    let index = word.index(word.startIndex, offsetBy: wordCount - 1)
                    singularWord = word.substring(to: index)
                }
                
                if (word.hasSuffix("ies")) {
                    let index = word.index(word.startIndex, offsetBy: wordCount - 3)
                    singularWord = word.substring(to: index)
                }
                
                // Add both the word and its singular (if exists) the list!!!
                kList.append(word)
                if (singularWord != nil) {
                    kList.append(singularWord!)
                }
            }
        }
        return (kList)
    }
}
