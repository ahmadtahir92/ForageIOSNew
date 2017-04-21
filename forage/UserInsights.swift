//
//  UserInsights.swift
//  forage
//
//  Created by vamsi valluri on 4/2/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit
import Parse

class UserInsights: PFObject, PFSubclassing {
    static func parseClassName() -> String {
        return "UserInsights"
    }

    // Return the objectId for home!
    public func getUserInsightsId() -> String {
        return self.objectId!;
    }
    
    //Add the constructors
    override init() {
        super.init()
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
    
    var msgRegToken: String? {
        get {
            return self["msgRegToken"] as! String?
        }
        set(v) {
            self["msgRegToken"] = v
        }
    }
    
    var msgRegTokenApple: String? {
        get {
            return self["msgRegTokenApple"] as! String?
        }
        set(v) {
            self["msgRegTokenApple"] = v
        }
    }
    
    var home: Homes? {
        get {
            return self["home"] as! Homes?
        }
        set(v) {
            self["home"] = v
        }
    }
    
    var topItems: [String]? {
        get {
            return self["topItems"] as! [String]?
        }
        set(v) {
            self["topItems"] = v
        }
    }

}
