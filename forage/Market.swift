//
//  Market.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 1/30/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit
import Parse

class Market: PFObject, PFSubclassing {
    // BoilerPlate Code
    static func parseClassName() -> String {
        return "Market"
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
    
    var email: String {
        get {
            return self["email"] as! String
        }
        set(v) {
            self["email"] = v
        }
    }

    var address: String {
        get {
            return self["address"] as! String
        }
        set(v) {
            self["address"] = v
        }
    }
    
    var phone: String {
        get {
            return self["phone"] as! String
        }
        set(v) {
            self["phone"] = v
        }
    }
    
    var img: String {
        get {
            return self["img"] as! String
        }
        set(v) {
            self["img"] = v
        }
    }
    
    // Add an empty constructor
    override init() {
        super.init()
    }
    
    init(name: String, email: String, address: String, phone: String, img: String) {
        super.init()
        self.name = name
        self.email = email
        self.address = address
        self.phone = phone
        self.img = img
    }
    
    public func getMarketId() -> String {
        return self.objectId!
    }
}
