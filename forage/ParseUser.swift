//
//  ParseUser.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 2/3/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import Parse

class ParseUser: PFQuery<User> {
    
    /**
     * Parse Installation is mixed here - needed for push functions!
     * Add functionality later
     */
    //private var installation: PFInstallation
    
    /* API to map users to our DB objects!!! */
    static func buildUserDBObj(user: User) {
        
        let uType = user.userType
        
        if (!Globals.globObj.setUserType(uType: uType)) {
            // Parse DB does not have a valid value for user type - barf!
            NSLog("Q_ERROR", "Parse DB does not have a valid value for user type")
            return
        }
        
        /*
         * Create a new home or farm!
         */
        switch (uType) {
            case UserType.HOMEOWNER_USER:
                // Should we do home validation to see if this home already exists!!!
                // We could have many users to the same house
                // Now - Should they have the same inventory or different?
                // They should have different carts - or some random guy can access the real user's house! Fuck!
                let hRec = ParseHomeOwner.createHomeOwnerUser(user: user)
        
                // The object Id is only allocated after the save in the cloud
                // Wait to save the back pointer in the user!
                user.homeId = hRec.getHomeId()
                break
        
            case UserType.FARMER_USER:
                // TODO - XXX - do farm validation to see if this farm already exists!!!
                // Same headache as the house? This is a little different
                // Farms we should do external validation and data entry!
                // Farm is todo!!!
                break
        
            case UserType.COURIER_USER:
                let cRec = ParseCourier.createCourierRecord(user: user)!

                // The object Id is only allocated after the save in the cloud
                // Wait to save the back pointer in the user!
                user.courierId = cRec.getCourierId()
                break
        
            default:
                break;
        }
        
        // WTF - Another inline save!!! This is a must have - so we have things ready for login!
        do {
            try user.save()
        } catch {
            NSLog("PARSE_ERR", error.localizedDescription)
        }
        
        //saveInstallation(user.name)
    }
        
    /* API to setup the glob based on the user */
    static func setupUserGlob(currUser: User) -> Bool {
        
        let uType = currUser.userType
        var setup = false
        
        if (!Globals.globObj.setUserType(uType: uType)) {
            // Parse DB does not have a valid value for user type - barf!
            NSLog("Q_ERROR", "Parse DB does not have a valid value for user type")
            return setup
        }
        
        switch (uType) {
            case UserType.HOMEOWNER_USER:
                setup = ParseHomeOwner.setHomeOwnerUser(homeId: currUser.homeId!)
                break
        
            case UserType.FARMER_USER:
                setup = ParseFarmer.setFarmRecord(farmId: currUser.farmId!)
                break
        
            case UserType.COURIER_USER:
                setup = ParseCourier.setCourierRecord(courierId: currUser.courierId!)
                break
        
            default:
                break
        }
        
        if (setup) {
            //saveInstallation(currUser.name)
        }
        
        return setup
    }

    override init() {
        super.init()
    }
}
