//
//  Courier.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 1/30/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit
import Parse

class Courier: PFObject, PFSubclassing {
    // BoilerPlate Code
    static func parseClassName() -> String {
        return "Courier"
    }
    
    // Define table fields
    var imgUrl: String? {
        get {
            return self["imgUrl"] as! String?
        }
        set(v) {
            self["imgUrl"] = v
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
    
    var name: String {
        get {
            return self["name"] as! String
        }
        set(v) {
            self["name"] = v
        }
    }
    
    
    // Add an empty constructor
    override init() {
        super.init()
    }
    
    init(name : String) {
        super.init()
        self.name = name
    }
    
    public func getCourierId() -> String {
        return self.objectId!
    }
}
