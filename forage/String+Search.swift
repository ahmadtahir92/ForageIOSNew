//
//  String+Search.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 2/16/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

extension String {
    
    func contains(find: String) -> Bool {
        return (self.lowercased().range(of: find.lowercased()) != nil)
    }
}
