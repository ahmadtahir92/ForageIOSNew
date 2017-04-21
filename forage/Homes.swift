//
//  Homes.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 1/30/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit
import Parse

class Homes: PFObject, PFSubclassing {
    // BoilerPlate Code
    static func parseClassName() -> String {
        return "Homes"
    }
    
    // Define table fields
    var address: String? {
        get {
            return self["address"] as! String?
        }
        set(v) {
            self["address"] = v
        }
    }
    
    var imgUrl: String? {
        get {
            return self["imgUrl"] as! String?
        }
        set(v) {
            self["imgUrl"] = v
        }
    }
    
    var owner: String? {
        get {
            return self["owner"] as! String?
        }
        set(v) {
            self["owner"] = v
        }
    }
    
    var email: String {
        get {
            return self["email"] as! String
        }
        set(v) {
            self["email"] = v
        }
    }
    
    var gardnerId: String? {
        get {
            return self["gardnerId"] as! String?
        }
        set(v) {
            self["gardnerId"] = v
        }
    }
    
    var yardDetails: String? {
        get {
            return self["yardDetails"] as! String?
        }
        set(v) {
            self["yardDetails"] = v
        }
    }
    
    var farmFavs: [Farm]? {
        get {
            return self["farmFavs"] as! [Farm]?
        }
        set(v) {
            self["farmFavs"] = v
        }
    }
    
    var currentOrder: Order? {
        get {
            return self["currentOrder"] as! Order?
        }
        set(v) {
            self["currentOrder"] = v
        }
    }
    
    var lastOrder: Order? {
        get {
            return self["lastOrder"] as! Order?
        }
        set(v) {
            self["lastOrder"] = v
        }
    }
    
    var stripeCustomerId: String? { // Stripe customer ID!!!
        get {
            return self["stripeCustomerId"] as! String?
        }
        set(v) {
            self["stripeCustomerId"] = v
        }
    }
    
    var uInsights: UserInsights? {
        get {
            return self["uInsights"] as! UserInsights?
        }
        set(v) {
            self["uInsights"] = v
        }
    }
    
    // Return the objectId for home!
    public func getHomeId() -> String {
        return self.objectId!;
    }
    
    //Add the constructors
    override init() {
        super.init()
    }

    init(address : String) {
        super.init()
        self.address = address
    }
}
