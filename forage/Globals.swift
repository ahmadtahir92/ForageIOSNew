//
//  Globals.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 2/3/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import Parse

class Globals {
    static let globObj = Globals()
    let userType = UserType(uType: UserType.MIN_USERTYPE)
    
    var homeRecord: Homes?
    
    var farmRecord: Farm?

    var courierRecord: Courier?
    
    var searchDictionary: [String]!
    
    public func getUserType() -> Int {
        return self.userType.getType()
    }
    
    public func setUserType(uType: Int) -> Bool{
        return userType.setType(uType: uType)
    }
    
    static func resetGlob() {
        globObj.homeRecord = nil
        globObj.courierRecord = nil
        globObj.farmRecord = nil
    }
    
    static func setupGlob() {
        globObj.searchDictionary = [String]()
    }
    
    static func addToSearchDictionary(word: String) {
        // This could get crazy big... stymie some words
        if (globObj.searchDictionary.count > Constants.MAX_SEARCH_DICTIONARY_SIZE) {
            let _ = globObj.searchDictionary.popLast()
        }
        if let index = globObj.searchDictionary.index(of: word) {
            globObj.searchDictionary.remove(at: index)
        }
        
        // Insert at the beginning - so we have LIFO!
        globObj.searchDictionary.insert(word, at: 0)
    }
}
