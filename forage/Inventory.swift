//
//  Inventory.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 1/30/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit
import Parse

class Inventory: PFObject, PFSubclassing {

    // BoilerPlate Code
    static func parseClassName() -> String {
        return "Inventory"
    }
    
    // Define table fields
    var name: String {
        get {
            return self["name"] as! String
        }
        set(v) {
            self["name"] = v
        }
    }
    
    var profile: String { // Image Profile
        get {
            return self["profile"] as! String
        }
        set(v) {
            self["profile"] = v
        }
    }
    
    var rate: Double {
        get {
            return self["rate"] as! Double
        }
        set(v) {
            self["rate"] = v
        }
    }
    
    var unit: String {
        get {
            return self["unit"] as! String
        }
        set(v) {
            self["unit"] = v
        }
    }
    
    var type: String {
        get {
            return self["type"] as! String
        }
        set(v) {
            self["type"] = v
        }
    }
    
    var totalAvailable: Double {
        get {
            return self["totalAvailable"] as! Double
        }
        set(v) {
            self["totalAvailable"] = v
        }
    }
    
    var farmName: String {
        get {
            return self["farmName"] as! String
        }
        set(v) {
            self["farmName"] = v
        }
    }
    
    var farmId: String {
        get {
            return self["farmId"] as! String
        }
        set(v) {
            self["farmId"] = v
        }
    }
    
    var itemDescription: String? {
        get {
            return self["description"] as! String?
        }
        set(v) {
            self["description"] = v
        }
    }
    
    var seasonal: Bool {
        get {
            return self["seasonal"] as! Bool
        }
        set(v) {
            self["seasonal"] = v
        }
    }
    
    
    var keywords: [String]? {
        get {
            return self["keywords"] as! [String]?
        }
        set(v) {
            self["keywords"] = v
        }
    }
    
    // Empty constructor!
    override init() {
        super.init()
    }
    
    init (inv: Inventory) {
        super.init()
        self.name = inv.name
        self.profile = inv.profile
        self.rate = inv.rate
        self.unit = inv.unit
        self.type = inv.type
        self.totalAvailable = inv.totalAvailable
        self.farmName = inv.farmName
        if let description = inv.itemDescription {
            self.itemDescription = description
        }
        self.farmId = inv.farmId
        self.seasonal = inv.seasonal
        if let keywords = inv.keywords {
            self.keywords = keywords
        }
    }
    
    /**
     * Extract keywords from the inventory name and type!
     *    - assumes name and type fields have already been setup!
     */
    func extractKeywords() {
        var keyList = Formatter.extractWords(keywordStr: self.name)
        // keyList.append(contentsOf: Formatter.extractWords(self.itemDescription))
        keyList.append(contentsOf: Formatter.extractWords(keywordStr: self.type))
        
        let invType = self.type.lowercased() as String
        if (invType == "baked goods") {
            keyList.append("bread")
        }
        keyList.append(invType)
    
        self.keywords = keyList
    }
}
