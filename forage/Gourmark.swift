//
//  Gourmark.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 1/30/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit
import Parse

class Gourmark: PFObject, PFSubclassing {
    // BoilerPlate Code
    static func parseClassName() -> String {
        return "Gourmark"
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

    var profile: String {
        get {
            return self["profile"] as! String
        }
        set(v) {
            self["profile"] = v
        }
    }
    
    var sourceUrl: String? {
        get {
            return self["sourceUrl"] as! String?
        }
        set(v) {
            self["sourceUrl"] = v
        }
    }
    
    var instructions: String? {
        get {
            return self["instructions"] as! String?
        }
        set(v) {
            self["instructions"] = v
        }
    }
    
    var shareAuthor: String? {
        get {
            return self["shareAuthor"] as! String?
        }
        set(v) {
            self["shareAuthor"] = v
        }
    }
    
    var origAuthor: String {
        get {
            return self["origAuthor"] as! String
        }
        set(v) {
            self["origAuthor"] = v
        }
    }
    
    var gourmarkDescription: String? {
        get {
            return self["description"] as! String?
        }
        set(v) {
            self["description"] = v
        }
    }
    
    var shared: Bool {
        get {
            return self["shared"] as! Bool
        }
        set(v) {
            self["shared"] = v
        }
    }
    
    //Empty constructor
    override init() {
        super.init()
    }
    
    init(name : String?, profile : String?, srcUrl: String?, instructions: String?, origAuthor: String, shareAuthor: String?,  description: String?, shared: Bool) {
        super.init()
        self.name = name ?? "Gourmark Anon"
        
        if let profile = profile {
            self.profile = profile
        }
        
        if let sourceUrl = srcUrl {
            self.sourceUrl = sourceUrl
        }
        
        if let instructions = instructions {
            self.instructions = instructions
        }
        
        self.origAuthor = origAuthor
        
        if let shareAuthor = shareAuthor {
            self.shareAuthor = shareAuthor
        }
        
        if let description = description {
            self.gourmarkDescription = description
        }
        
        self.shared = shared
    }
}
