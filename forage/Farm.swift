//
//  Farm.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 1/30/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit
import Parse

class Farm: PFObject, PFSubclassing {
    // BoilerPlate Code
    static func parseClassName() -> String {
        return "Farm"
    }
    
    // Define table fields
    var farmImage: String? {
        get {
            return self["farmImage"] as! String?
        }
        set(v) {
            self["farmImage"] = v
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
    
    var farmLocation: String? {
        get {
            return self["farmLocation"] as! String?
        }
        set(v) {
            self["farmLocation"] = v
        }
    }
    
    var farmSpecialty: String? {
        get {
            return self["farmSpecialty"] as! String?
        }
        set(v) {
            self["farmSpecialty"] = v
        }
    }

    var farmClassification: String? {
        get {
            return self["farmClassification"] as! String?
        }
        set(v) {
            self["farmClassification"] = v
        }
    }
    
    var farmAddress: String? {
        get {
            return self["farmAddress"] as! String?
        }
        set(v) {
            self["farmAddress"] = v
        }
    }
    
    var farmReviews: String? {
        get {
            return self["farmReviews"] as! String?
        }
        set(v) {
            self["farmReviews"] = v
        }
    }
    
    var featured: Bool {
        get {
            return self["featured"] as! Bool
        }
        set(v) {
            self["featured"] = v
        }
    }
    
    var farmInventory: [Inventory] {
        get {
            return self["farmInventory"] as! [Inventory]
        }
        set(v) {
            self["farmInventory"] = v
        }
    }
    
    func addToFarmInventory(inv: Inventory) {
        self.farmInventory.append(inv)
    }
    
    func removeFromFarmInventory(inv: Inventory) {
        let fInvList = self.farmInventory
        self.farmInventory = fInvList.filter(){$0 != inv}
    }
    
    func getFarmClassResource() -> UIImage? {
        var image: UIImage? = nil
        
        guard let farmClass = self.farmClassification as String! else {
            return (image)
        }
        if (farmClass == Constants.FARM_CLASS_ORGANIC) {
            image = #imageLiteral(resourceName: "ccof_logo")
        } else if (farmClass == Constants.FARM_CLASS_NATURAL) {
            image = #imageLiteral(resourceName: "certified_natural")
        }
        return (image)
    }
    
    func getFarmId() -> String {
        return self.objectId as String!
    }
    
    // Empty constructor!
    override init() {
        super.init()
    }
}
