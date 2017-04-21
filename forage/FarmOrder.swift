//
//  FarmOrder.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 3/10/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import Parse

class FarmOrder: PFObject, PFSubclassing {
    // BoilerPlate Code
    static func parseClassName() -> String {
        return "FarmOrder"
    }
    
    // Define table fields
    var farmId: String {
        get {
            return self["farmId"] as! String
        }
        set(v) {
            self["farmId"] = v
        }
    }
    
    var userOrderId: String? { // Index to the user order
        get {
            return self["userOrderId"] as! String?
        }
        set(v) {
            self["userOrderId"] = v
        }
    }
    
    var userOrder: Order? {
        get {
            return self["userOrder"] as! Order?
        }
        set(v) {
            self["userOrder"] = v
        }
    }

    var homeInventories: [HomeInventory] {
        get {
            return self["homeInventories"] as! [HomeInventory]
        }
        set(v) {
            self["homeInventories"] = v
        }
    }
    
    var farmTotalPrice: Double? {
        get {
            return self["farmTotalPrice"] as! Double?
        }
        set(v) {
            self["farmTotalPrice"] = v
        }
    }
    
    // Getters and Setters
    public func getFarmOrderId() -> String {
        return self.objectId!
    }
    
    public func addToHomeInventory(homeInv: HomeInventory) {
        self.homeInventories.append(homeInv)
    }
    /**
     * Add the constructors
     */
    override init() {
        super.init()
    }
    
    init(orderId: String) {
        super.init()
        self.userOrderId = orderId
        self.homeInventories = [HomeInventory]()
    }
}
