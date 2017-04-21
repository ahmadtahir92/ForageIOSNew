//
//  HomeInventory.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 1/30/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit
import Parse

class HomeInventory: PFObject, PFSubclassing {
    // BoilerPlate Code
    static func parseClassName() -> String {
        return "HomeInventory"
    }
    
    /**
     * Parse does not allow subclassing to another Parse subclass
     *    - resort to ugly copying of Inventory to HomeInventory!
     */
    
    // Define table fields
    var name: String {
        get {
            return self["name"] as! String
        }
        set(v) {
            self["name"] = v
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
    
    var homeCount: Double {
        get {
            return self["homeCount"] as! Double
        }
        set(v) {
            self["homeCount"] = v
        }
    }
    
    var farmInv: Inventory? {
        get {
            return self["farmInv"] as? Inventory
        }
        set(v) {
            self["farmInv"] = v
        }
    }
    
    
    var pendingDelete: Bool { // This is a runtime value - need not store in DB!
        get {
            return self.pendingDelete
        }
        set(v) {
            self.pendingDelete = v
        }
    }
    
    func updateHomeCount(count: Double) {
        let max = self.farmInv!.totalAvailable
        var tempCount = self.homeCount + count
        
        // No negative count allowed
        if (tempCount < 0.0) {
            tempCount = 0.0
        }
        
        // Set only to max allowed!
        if (tempCount > max) {
            tempCount = max
        }
        
        self.homeCount = tempCount
    }
    
    // Validate the inventory ids!
    func checkInvMatch(inv: Inventory) -> Bool {
        if ((self.farmId == inv.farmId) &&
            (inv.name.lowercased() == self.name.lowercased())) {
            return true
        }
        return false
    }
    
    func checkInvMatch(hInv : HomeInventory) -> Bool {
        let fInv = hInv.farmInv!
        return checkInvMatch(inv: fInv)
    }
    
    // Empty constructor!
    override init() {
        super.init()
    }
    
    func copyInventory(inv: Inventory, count: Double) {
        self.name = inv.name
        self.rate = inv.rate
        self.unit = inv.unit
        self.type = inv.type
        self.farmName = inv.farmName
        self.farmId = inv.farmId
        self.homeCount = count
        self.farmInv = inv
    }

    init (hInv : HomeInventory) {
        super.init()

        let fInv = hInv.farmInv!
        copyInventory(inv: fInv, count: hInv.homeCount)
    }

    init (inv : Inventory, count: Double) {
        super.init()
        copyInventory(inv: inv, count: count)
    }
}
