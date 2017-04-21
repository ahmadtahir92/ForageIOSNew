//
//  UserType.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 2/3/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

class UserType {
    
    static let MIN_USERTYPE = 0 as Int
    static let HOMEOWNER_USER = 1 as Int
    static let FARMER_USER = 2 as Int
    static let COURIER_USER = 3 as Int
    static let GARDNER_USER = 4 as Int
    static let MAX_USERTYPE = 5 as Int
        
    var uType: Int
    
    init(uType: Int) {
        self.uType = uType
    }
        
    // Return true if input validation succeeded!
    func setType(uType: Int) -> Bool {
        if ((uType > UserType.MIN_USERTYPE) && (uType < UserType.MAX_USERTYPE)) {
            self.uType = uType;
            return true
        }
        return false
    }

    func getType() -> Int {
        return self.uType
    }
}
