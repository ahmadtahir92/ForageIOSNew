//
//  User.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 1/29/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit
import Parse

class User: PFUser {
    
    // No need to define subClassing or even the className function for PFUser
    // PFUser already defines username, password, email, and auth tokens!
    
    // Define table fields
    var userType: Int {
        get {
            return self["userType"] as! Int
        }
        set(v) {
            self["userType"] = v
        }
    }
    
    // Human friendly name for the user!
    var name: String? {
        get {
            return self["name"] as! String?
        }
        set(v) {
            self["name"] = v
        }
    }
    
    // Delivery location
    var address: String? {
        get {
            return self["address"] as! String?
        }
        set(v) {
            self["address"] = v
        }
    }
    
    // This is specifically validated!
    var emailVerified: Bool? {
        get {
            return self["emailVerified"] as! Bool?
        }
        set(v) {
            self["emailVerified"] = v
        }
    }
    
    // Home Specific
    var homeId: String? {
        get {
            return self["homeId"] as! String?
        }
        set(v) {
            self["homeId"] = v
        }
    }
    
    // Farmer Specific
    var farmId: String? {
        get {
            return self["farmId"] as! String?
        }
        set(v) {
            self["farmId"] = v
        }
    }
    
    // Courier Specific
    var courierId: String? {
        get {
            return self["courierId"] as! String?
        }
        set(v) {
            self["courierId"] = v
        }
    }
    
    class func getCurrentUser() -> User {
        return PFUser.current() as! User
    }
}
