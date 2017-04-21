//
//  EventSample.swift
//  forage
//
//  Created by vamsi valluri on 2/21/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit
import Parse

class EventSample: PFObject, PFSubclassing {
    // BoilerPlate Code
    static func parseClassName() -> String {
        return "EventSample"
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
    
    var type: String {
        get {
            return self["type"] as! String
        }
        set(v) {
            self["type"] = v
        }
    }
    
    var value: Double {
        get {
            return self["value"] as! Double
        }
        set(v) {
            self["value"] = v
        }
    }
    
    var startTime: Int64 {
        get {
            return self["startTime"] as! Int64
        }
        set(v) {
            self["startTime"] = v
        }
    }
    
    var stopTime: Int64 {
        get {
            return self["stopTime"] as! Int64
        }
        set(v) {
            self["stopTime"] = v
        }
    }
    
    var tagKVs: [String: Any] {
        get {
            return self["tagKVs"] as! [String: Any]
        }
        set(v) {
            self["tagKVs"] = v
        }
    }
    
    var fieldKVs: [String: Any] {
        get {
            return self["fieldKVs"] as! [String: Any]
        }
        set(v) {
            self["fieldKVs"] = v
        }
    }
    
    // Get elapsed time
    func getElapsedTime() -> Int64 {
        return stopTime - startTime
    }
    
    // Set one tag
    func setTagValue(tag: String, value: Any!) {
        tagKVs[tag] = value
    }
    
    // Set one field
    func setFieldValue(field: String, value: Any!) {
        fieldKVs[field] = value
    }
    
    // Empty constructor!
    override init() {
        super.init()
    }
    
    init (name : String, type: String, value: Double, tagKVs: [String: Any]?, fieldKVs: [String: Any]?) {
        super.init()
        self.name = name
        self.type = type
        self.value = value
        if let tags = tagKVs {
            self.tagKVs = tags
        }
        if let fields = fieldKVs {
            self.fieldKVs = fields
        }
    }
}
