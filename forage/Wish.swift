//
//  Wish.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 1/30/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit
import Parse

class Wish: PFObject, PFSubclassing {
    // BoilerPlate Code
    static func parseClassName() -> String {
        return "Wish"
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
    
    var feedback: String {
        get {
            return self["feedback"] as! String
        }
        set(v) {
            self["feedback"] = v
        }
    }
    
    var responseNeeded: Bool {
        get {
            return self["responseNeeded"] as! Bool
        }
        set(v) {
            self["responseNeeded"] = v
        }
    }
    
    // Empty constructor!
    override init() {
        super.init()
    }
    
    init (name : String, email: String, feedback: String, responseNeeded: Bool) {
        super.init()
        self.name = name
        self.email = email
        self.feedback = feedback
        self.responseNeeded = responseNeeded
    }
}
