//
//  Order.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 1/30/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit
import Parse

class Order: PFObject, PFSubclassing {
    // BoilerPlate Code
    static func parseClassName() -> String {
        return "Order"
    }
    
    // Define table fields
    var home: Homes { // Back pointer for future look ups for past orders that are no longer linked from a home!
        get {
            return self["home"] as! Homes
        }
        set(v) {
            self["home"] = v
        }
    }
    
    var checkoutPrice: Double {
        get {
            return self["checkoutPrice"] as! Double
        }
        set(v) {
            self["checkoutPrice"] = v
        }
    }
    
    var homeName: String? {
        get {
            return self["homeName"] as! String?
        }
        set(v) {
            self["homeName"] = v
        }
    }
    
    var homeEmail: String {
        get {
            return self["homeEmail"] as! String
        }
        set(v) {
            self["homeEmail"] = v
        }
    }
    
    var homeAddress: String {
        get {
            return self["homeAddress"] as! String
        }
        set(v) {
            self["homeAddress"] = v
        }
    }
    
    var delivered: Bool {
        get {
            return self["delivered"] as! Bool
        }
        set(v) {
            self["delivered"] = v
        }
    }
    
    var charged: Bool {
        get {
            return self["charged"] as! Bool
        }
        set(v) {
            self["charged"] = v
        }
    }
    
    var deliveryRequested: Bool {
        get {
            return self["deliveryRequested"] as! Bool
        }
        set(v) {
            self["deliveryRequested"] = v
        }
    }
    
    var customerId: String? {
        get {
            return self["customerId"] as! String?
        }
        set(v) {
            self["customerId"] = v
        }
    }
    
    var stripePaymentId: String? {
        get {
            return self["stripePaymentId"] as! String?
        }
        set(v) {
            self["stripePaymentId"] = v
        }
    }
    
    var checkoutTime: Date? {
        get {
            return self["checkoutTime"] as! Date?
        }
        set(v) {
            self["checkoutTime"] = v
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
    
    // Getters and Setters
    public func getOrderId() -> String {
        return self.objectId!
    }
    
    public func addToHomeInventory(homeInv: HomeInventory) {
        /*
         * Default init insertLoc to zero!!!
         *     - if farmId match - insertLoc = position found (add to existing list)
         *     - if no match - insertLoc = 0; Insert in the beginning.
         *
         * The idea with zero is that next items added will be from same farm, so will be faster lookup
         * The lookup hit, should only be for the first item!
         */
        var insertloc = 0
    
        var hInvList = self.homeInventories
        for i in 0..<hInvList.count {
            let hInv = hInvList[i]
            if (homeInv.farmId == hInv.farmId) {
                // Found a match - mark position and break;
                insertloc = i
                break
            }
        }
    
        hInvList.insert(homeInv, at: insertloc)
        self.homeInventories = hInvList
    }
    
    public func updateCheckoutPrice() -> Double {
        var updatePrice = 0.0 as Double
    
        let homeInvArr = self.homeInventories
        for homeInv in homeInvArr {
            updatePrice = updatePrice + homeInv.rate * homeInv.homeCount
        }
        self.checkoutPrice = updatePrice
        return updatePrice
    }
    
    
    /**
     * Add the constructors
     */
    override init() {
        super.init()
    }
    
    init(home: Homes) {
        super.init()
        self.home = home
        self.homeName = home.owner
        self.homeEmail = home.email
        if let address = home.address {
            self.homeAddress = address
        }
        self.delivered = false
        self.charged = false
        self.checkoutPrice = 0.0
        self.homeInventories = [HomeInventory]()
    }
    
    /**
     * Return the total count!
     */
    public func getItemsInCart() -> Int {
        return self.homeInventories.count
    }
    
    /**
     * Get an image for the order!
     *
     * Complex - !@#$%^&*!!!
     *
     * Return url of a random inventory in the order! :))
     */
    public func getProfile() -> String {
        let homeInventories = self.homeInventories
    
        let index = Int(Formatter.getRandom(min: 0, max: UInt32(homeInventories.count)))
        return homeInventories[index].farmInv!.profile
    }
    
    /**
     * Get a display name for the order!
     */
    public func getOrderName() -> String {
        var name: String? = nil
        
        if (ParseHomeOwner.isOrderMine(order: self)) {
            name = Constants.ORDER_NAME + Formatter.datePhraseRelativeToToday(from: self.checkoutTime!)
        } else {
            name = self.homeName! + "'s Picks!"
        }
        return name!
    }
}
